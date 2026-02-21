#!bin/bash
# ============================================================
# apply-changes.sh
# Run from project root: bash apply-changes.sh
# Applies all frontend + infrastructure changes.
# Does NOT touch backend business logic or Prisma migrations.
# ============================================================
set -euo pipefail

GREEN='\033[0;32m'; BLUE='\033[0;34m'; YELLOW='\033[1;33m'; NC='\033[0m'
log()  { echo -e "${BLUE}[apply]${NC}  $*"; }
ok()   { echo -e "${GREEN}[done]${NC}   $*"; }
warn() { echo -e "${YELLOW}[warn]${NC}   $*"; }

# Confirm we're in the project root
if [[ ! -f "docker-compose.yml" ]]; then
  echo "Error: run this script from the project root (where docker-compose.yml lives)"
  exit 1
fi

# ── Create directory tree ─────────────────────────────────────────────────
log "Creating directories..."
mkdir -p \
  graphql/operations \
  backend/api/src \
  client/modules/graphql/generated \
  client/web/src/apollo \
  client/web/src/pages \
  client/web/src/components/ui \
  client/web/src/components/hotels \
  client/web/src/components/rooms \
  client/web/src/components/bookings
ok "Directories ready"

# ── Remove files that no longer exist in the new architecture ─────────────
log "Removing obsolete files..."
rm -f client/web/src/components/rooms/RoomDetail.tsx
rm -f client/web/src/components/bookings/BookingForm.tsx
rm -f client/web/src/components/availability/AvailabilityChecker.tsx
rmdir --ignore-fail-on-non-empty client/web/src/components/availability 2>/dev/null || true
ok "Obsolete files removed"

# ── Write all files via Python (safe with quotes/backslashes) ─────────────
log "Writing files..."

python3 << 'PYEOF'
import os, sys

def write(path, content):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, 'w') as f:
        f.write(content)
    print(f"  wrote {path}")

# ════════════════════════════════════════════════════════════
# GRAPHQL — shared schema and operations
# ════════════════════════════════════════════════════════════

write("graphql/schema.graphql", """\
scalar DateTime

type Hotel {
  id: ID!
  name: String!
  city: String!
  rooms: [Room!]!
  createdAt: DateTime!
}

type Room {
  id: ID!
  hotelId: ID!
  number: String!
  title: String
  capacity: Int!
  priceEur: Int!
  bookings(status: BookingStatus = ACTIVE): [Booking!]!
  createdAt: DateTime!
}

enum BookingStatus {
  ACTIVE
  CANCELED
}

type Booking {
  id: ID!
  roomId: ID!
  guestName: String!
  startDate: DateTime!
  endDate: DateTime!
  status: BookingStatus!
  createdAt: DateTime!
  canceledAt: DateTime
}

type Availability {
  roomId: ID!
  startDate: DateTime!
  endDate: DateTime!
  isAvailable: Boolean!
  conflicts: [Booking!]!
}

type Query {
  hotels: [Hotel!]!
  rooms(hotelId: ID!): [Room!]!
  room(id: ID!): Room!
  availability(roomId: ID!, startDate: DateTime!, endDate: DateTime!): Availability!
}

type Mutation {
  createBooking(
    roomId: ID!
    guestName: String!
    startDate: DateTime!
    endDate: DateTime!
  ): Booking!
  cancelBooking(bookingId: ID!): Booking!
}
""")

write("graphql/operations/hotels.graphql", """\
query GetHotels {
  hotels {
    id
    name
    city
    createdAt
  }
}
""")

write("graphql/operations/rooms.graphql", """\
query GetRooms($hotelId: ID!) {
  rooms(hotelId: $hotelId) {
    id
    hotelId
    number
    title
    capacity
    priceEur
    createdAt
  }
}

query GetRoom($id: ID!, $bookingStatus: BookingStatus) {
  room(id: $id) {
    id
    hotelId
    number
    title
    capacity
    priceEur
    bookings(status: $bookingStatus) {
      id
      guestName
      startDate
      endDate
      status
      createdAt
      canceledAt
    }
  }
}
""")

write("graphql/operations/bookings.graphql", """\
query GetAvailability($roomId: ID!, $startDate: DateTime!, $endDate: DateTime!) {
  availability(roomId: $roomId, startDate: $startDate, endDate: $endDate) {
    roomId
    startDate
    endDate
    isAvailable
    conflicts {
      id
      guestName
      startDate
      endDate
      status
    }
  }
}

mutation CreateBooking(
  $roomId: ID!
  $guestName: String!
  $startDate: DateTime!
  $endDate: DateTime!
) {
  createBooking(
    roomId: $roomId
    guestName: $guestName
    startDate: $startDate
    endDate: $endDate
  ) {
    id
    roomId
    guestName
    startDate
    endDate
    status
    createdAt
  }
}

mutation CancelBooking($bookingId: ID!) {
  cancelBooking(bookingId: $bookingId) {
    id
    roomId
    status
    canceledAt
  }
}
""")

# ════════════════════════════════════════════════════════════
# BACKEND — schema.ts (resolvers + readFileSync)
# ════════════════════════════════════════════════════════════

write("backend/api/src/schema.ts", """\
import { readFileSync } from "fs";
import { join } from "path";
import { PrismaClient, BookingStatus } from "@prisma/client";
import { GraphQLError } from "graphql";

// Shared schema.graphql is the single source of truth for all clients and the backend.
// Mounted in docker-compose as ./graphql:/app/graphql:ro
// __dirname = /app/src (dev, ts-node-dev) or /app/dist (prod, node)
// ../graphql resolves to /app/graphql in both cases ✓
export const typeDefs = readFileSync(
  join(__dirname, "../graphql/schema.graphql"),
  "utf-8"
);

export type Context = {
  prisma: PrismaClient;
  log: (msg: string, extra?: Record<string, unknown>) => void;
};

// --- helpers ---

function asDate(value: unknown, field: string): Date {
  const d = new Date(String(value));
  if (Number.isNaN(d.getTime())) {
    throw new GraphQLError(`Invalid ${field}`, {
      extensions: { code: "BAD_USER_INPUT" },
    });
  }
  return d;
}

function validateRange(start: Date, end: Date) {
  if (start.getTime() >= end.getTime()) {
    throw new GraphQLError("Invalid date range: startDate must be < endDate", {
      extensions: { code: "BAD_USER_INPUT" },
    });
  }
}

async function findConflicts(
  prisma: PrismaClient,
  roomId: string,
  start: Date,
  end: Date
) {
  return prisma.booking.findMany({
    where: {
      roomId,
      status: BookingStatus.ACTIVE,
      startDate: { lt: end },
      endDate: { gt: start },
    },
    orderBy: { startDate: "asc" },
  });
}

function mapDbError(e: unknown): GraphQLError | null {
  const msg = e instanceof Error ? e.message : String(e);
  if (msg.includes("23P01") || msg.toLowerCase().includes("exclusion")) {
    return new GraphQLError("Booking conflicts with existing booking(s)", {
      extensions: { code: "CONFLICT" },
    });
  }
  return null;
}

// --- resolvers ---

export const resolvers = {
  Query: {
    hotels: async (_: unknown, __: unknown, ctx: Context) => {
      return ctx.prisma.hotel.findMany({ orderBy: { createdAt: "asc" } });
    },

    rooms: async (_: unknown, args: { hotelId: string }, ctx: Context) => {
      return ctx.prisma.room.findMany({
        where: { hotelId: args.hotelId },
        orderBy: { number: "asc" },
      });
    },

    room: async (_: unknown, args: { id: string }, ctx: Context) => {
      const room = await ctx.prisma.room.findUnique({ where: { id: args.id } });
      if (!room) {
        throw new GraphQLError("Room not found", {
          extensions: { code: "NOT_FOUND" },
        });
      }
      return room;
    },

    availability: async (
      _: unknown,
      args: { roomId: string; startDate: string; endDate: string },
      ctx: Context
    ) => {
      const start = asDate(args.startDate, "startDate");
      const end = asDate(args.endDate, "endDate");
      validateRange(start, end);
      const conflicts = await findConflicts(ctx.prisma, args.roomId, start, end);
      return {
        roomId: args.roomId,
        startDate: start,
        endDate: end,
        isAvailable: conflicts.length === 0,
        conflicts,
      };
    },
  },

  Mutation: {
    createBooking: async (
      _: unknown,
      args: { roomId: string; guestName: string; startDate: string; endDate: string },
      ctx: Context
    ) => {
      const start = asDate(args.startDate, "startDate");
      const end = asDate(args.endDate, "endDate");
      validateRange(start, end);

      const conflicts = await findConflicts(ctx.prisma, args.roomId, start, end);
      if (conflicts.length > 0) {
        throw new GraphQLError("Booking conflicts with existing booking(s)", {
          extensions: { code: "CONFLICT", conflictsCount: conflicts.length },
        });
      }

      try {
        const booking = await ctx.prisma.booking.create({
          data: {
            roomId: args.roomId,
            guestName: args.guestName,
            startDate: start,
            endDate: end,
            status: BookingStatus.ACTIVE,
          },
        });
        ctx.log("booking_created", {
          bookingId: booking.id,
          roomId: booking.roomId,
          startDate: booking.startDate.toISOString(),
          endDate: booking.endDate.toISOString(),
        });
        return booking;
      } catch (e) {
        const mapped = mapDbError(e);
        if (mapped) throw mapped;
        throw e;
      }
    },

    cancelBooking: async (_: unknown, args: { bookingId: string }, ctx: Context) => {
      const existing = await ctx.prisma.booking.findUnique({
        where: { id: args.bookingId },
      });
      if (!existing) {
        throw new GraphQLError("Booking not found", {
          extensions: { code: "NOT_FOUND" },
        });
      }
      if (existing.status === BookingStatus.CANCELED) {
        return existing;
      }
      const canceled = await ctx.prisma.booking.update({
        where: { id: args.bookingId },
        data: { status: BookingStatus.CANCELED, canceledAt: new Date() },
      });
      ctx.log("booking_canceled", { bookingId: canceled.id, roomId: canceled.roomId });
      return canceled;
    },
  },

  Hotel: {
    rooms: async (parent: { id: string }, _: unknown, ctx: Context) => {
      return ctx.prisma.room.findMany({
        where: { hotelId: parent.id },
        orderBy: { number: "asc" },
      });
    },
  },

  Room: {
    bookings: async (
      parent: { id: string },
      args: { status?: BookingStatus },
      ctx: Context
    ) => {
      const status = args.status ?? BookingStatus.ACTIVE;
      return ctx.prisma.booking.findMany({
        where: { roomId: parent.id, status },
        orderBy: { startDate: "asc" },
      });
    },
  },
};
""")

# ════════════════════════════════════════════════════════════
# CLIENT MODULES — codegen config
# ════════════════════════════════════════════════════════════

write("client/modules/graphql/codegen.yml", """\
# Paths are relative to cwd when codegen runs: /app/client/web
# (invoked via `npm run codegen` from client/web/)
schema: "../../graphql/schema.graphql"
documents: "../../graphql/operations/**/*.graphql"
generates:
  ../modules/graphql/generated/index.ts:
    plugins:
      - typescript
      - typescript-operations
      - typescript-react-apollo
    config:
      scalars:
        DateTime: string
      withHooks: true
      withResultType: true
      withMutationFn: true
      withComponent: false
      documentMode: documentNode
""")

# ════════════════════════════════════════════════════════════
# CLIENT/WEB — config files
# ════════════════════════════════════════════════════════════

write("client/web/package.json", """\
{
  "name": "web",
  "version": "1.0.0",
  "private": true,
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "tsc && vite build",
    "preview": "vite preview",
    "codegen": "graphql-codegen --config ../modules/graphql/codegen.yml",
    "codegen:watch": "graphql-codegen --config ../modules/graphql/codegen.yml --watch"
  },
  "dependencies": {
    "@apollo/client": "^3.11.0",
    "graphql": "^16.9.0",
    "react": "^18.3.0",
    "react-dom": "^18.3.0",
    "react-router-dom": "^6.28.0"
  },
  "devDependencies": {
    "@graphql-codegen/cli": "^5.0.0",
    "@graphql-codegen/typescript": "^4.0.0",
    "@graphql-codegen/typescript-operations": "^4.0.0",
    "@graphql-codegen/typescript-react-apollo": "^4.0.0",
    "@types/react": "^18.3.0",
    "@types/react-dom": "^18.3.0",
    "@vitejs/plugin-react": "^4.3.0",
    "autoprefixer": "^10.4.0",
    "postcss": "^8.4.0",
    "tailwindcss": "^3.4.0",
    "typescript": "^5.6.0",
    "vite": "^5.4.0"
  }
}
""")

write("client/web/tsconfig.json", """\
{
  "compilerOptions": {
    "target": "ES2022",
    "lib": ["ES2022", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "moduleResolution": "Bundler",
    "jsx": "react-jsx",
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true,
    "skipLibCheck": true,
    "esModuleInterop": true,
    "baseUrl": ".",
    "paths": {
      "@modules/*": ["../modules/*"]
    }
  },
  "include": ["src"]
}
""")

write("client/web/vite.config.ts", """\
import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import { resolve } from "path";

export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      "@modules": resolve(__dirname, "../modules"),
    },
  },
  server: {
    port: 3000,
    proxy: {
      "/graphql": {
        target: "http://api:4000",
        changeOrigin: true,
      },
    },
  },
});
""")

write("client/web/tailwind.config.js", """\
/** @type {import('tailwindcss').Config} */
export default {
  content: ["./index.html", "./src/**/*.{ts,tsx}"],
  theme: { extend: {} },
  plugins: [],
};
""")

write("client/web/postcss.config.js", """\
export default {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
};
""")

write("client/web/.npmrc", """\
fetch-retries=5
fetch-retry-maxtimeout=60000
fetch-retry-mintimeout=1000
""")

write("client/web/index.html", """\
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Hotel Booking</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.tsx"></script>
  </body>
</html>
""")

write("client/web/nginx.conf", """\
server {
  listen 80;
  root /usr/share/nginx/html;
  index index.html;

  location / {
    try_files $uri $uri/ /index.html;
  }

  location /graphql {
    proxy_pass http://api:4000/graphql;
    proxy_http_version 1.1;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
  }
}
""")

write("client/web/Dockerfile", """\
# Build context: project root (.)
# docker-compose: context: .  dockerfile: client/web/Dockerfile

# ── Stage 1: deps ──────────────────────────────────────────────────────────
FROM node:20-alpine AS deps
WORKDIR /app/client/web
COPY client/web/package.json client/web/package-lock.json ./
RUN npm ci

# ── Stage 2: dev ───────────────────────────────────────────────────────────
FROM deps AS dev
WORKDIR /app/client/web
EXPOSE 3000
CMD ["sh", "-c", "npm run codegen && npm run dev -- --host"]

# ── Stage 3: build ─────────────────────────────────────────────────────────
FROM deps AS build
WORKDIR /app
COPY graphql/ ./graphql/
COPY client/modules/ ./client/modules/
COPY client/web/ ./client/web/
WORKDIR /app/client/web
RUN npm run codegen
RUN npm run build

# ── Stage 4: prod ──────────────────────────────────────────────────────────
FROM nginx:alpine AS prod
COPY --from=build /app/client/web/dist /usr/share/nginx/html
COPY client/web/nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
""")

# ════════════════════════════════════════════════════════════
# CLIENT/WEB — src files
# ════════════════════════════════════════════════════════════

write("client/web/src/index.css", """\
@tailwind base;
@tailwind components;
@tailwind utilities;
""")

write("client/web/src/main.tsx", """\
import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import { ApolloProvider } from "@apollo/client";
import { client } from "./apollo/client";
import { App } from "./App";
import "./index.css";

const root = document.getElementById("root");
if (!root) throw new Error("#root element not found");

createRoot(root).render(
  <StrictMode>
    <ApolloProvider client={client}>
      <App />
    </ApolloProvider>
  </StrictMode>
);
""")

write("client/web/src/App.tsx", """\
import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom";
import { Layout } from "./components/ui/Layout";
import { HotelListPage } from "./pages/HotelListPage";
import { RoomListPage } from "./pages/RoomListPage";
import { RoomDetailPage } from "./pages/RoomDetailPage";
import { ErrorBoundary } from "./components/ui/ErrorBoundary";

export function App() {
  return (
    <BrowserRouter>
      <Layout>
        <ErrorBoundary>
          <Routes>
            <Route path="/" element={<HotelListPage />} />
            <Route path="/hotels/:hotelId" element={<RoomListPage />} />
            <Route path="/hotels/:hotelId/rooms/:roomId" element={<RoomDetailPage />} />
            <Route path="*" element={<Navigate to="/" replace />} />
          </Routes>
        </ErrorBoundary>
      </Layout>
    </BrowserRouter>
  );
}
""")

write("client/web/src/apollo/client.ts", """\
import { ApolloClient, HttpLink, from } from "@apollo/client";
import { onError } from "@apollo/client/link/error";
import { cache } from "./cache";

const errorLink = onError(({ graphQLErrors, networkError }) => {
  if (graphQLErrors) {
    graphQLErrors.forEach(({ message, extensions }) => {
      console.error(`[GraphQL error] ${extensions?.code ?? "UNKNOWN"}: ${message}`);
    });
  }
  if (networkError) {
    console.error(`[Network error]: ${networkError.message}`);
  }
});

const httpLink = new HttpLink({
  // Dev: Vite proxy /graphql → http://api:4000/graphql
  // Prod: nginx /graphql → http://api:4000/graphql
  uri: "/graphql",
});

export const client = new ApolloClient({
  link: from([errorLink, httpLink]),
  cache,
  defaultOptions: {
    watchQuery: { fetchPolicy: "cache-and-network" },
  },
});
""")

write("client/web/src/apollo/cache.ts", """\
import { InMemoryCache } from "@apollo/client";

export const cache = new InMemoryCache({
  typePolicies: {
    Room: {
      fields: {
        // Cache ACTIVE and CANCELED bookings lists separately
        bookings: { keyArgs: ["status"] },
      },
    },
  },
});
""")

# ── Pages ─────────────────────────────────────────────────

write("client/web/src/pages/HotelListPage.tsx", """\
import { useGetHotelsQuery } from "@modules/graphql/generated";
import { HotelCard } from "../components/hotels/HotelCard";

export function HotelListPage() {
  const { data, loading, error } = useGetHotelsQuery();

  if (loading) return <p className="text-gray-500">Loading hotels…</p>;
  if (error) return <p className="text-red-600">Error: {error.message}</p>;
  if (!data?.hotels.length) return <p className="text-gray-500">No hotels found.</p>;

  return (
    <div className="flex flex-col gap-3">
      {data.hotels.map((hotel) => (
        <HotelCard key={hotel.id} hotel={hotel} />
      ))}
    </div>
  );
}
""")

write("client/web/src/pages/RoomListPage.tsx", """\
import { useParams } from "react-router-dom";
import { useGetRoomsQuery } from "@modules/graphql/generated";
import { RoomCard } from "../components/rooms/RoomCard";

export function RoomListPage() {
  const { hotelId } = useParams<{ hotelId: string }>();
  const { data, loading, error } = useGetRoomsQuery({
    variables: { hotelId: hotelId! },
  });

  if (loading) return <p className="text-gray-500">Loading rooms…</p>;
  if (error) return <p className="text-red-600">Error: {error.message}</p>;
  if (!data?.rooms.length) return <p className="text-gray-500">No rooms found.</p>;

  return (
    <div className="flex flex-col gap-3">
      {data.rooms.map((room) => (
        <RoomCard key={room.id} room={room} hotelId={hotelId!} />
      ))}
    </div>
  );
}
""")

write("client/web/src/pages/RoomDetailPage.tsx", """\
import { useParams } from "react-router-dom";
import { useGetRoomQuery } from "@modules/graphql/generated";
import { BookingPanel } from "../components/bookings/BookingPanel";
import { BookingList } from "../components/bookings/BookingList";

export function RoomDetailPage() {
  const { roomId } = useParams<{ roomId: string }>();
  const { data, loading, error } = useGetRoomQuery({
    variables: { id: roomId! },
  });

  if (loading) return <p className="text-gray-500">Loading room…</p>;
  if (error) return <p className="text-red-600">Error: {error.message}</p>;

  const room = data!.room;

  return (
    <div className="flex flex-col gap-8">
      <div className="rounded-lg border border-gray-200 bg-gray-50 p-4">
        <h3 className="font-semibold text-gray-900">
          Room {room.number}{room.title ? ` — ${room.title}` : ""}
        </h3>
        <p className="mt-1 text-sm text-gray-500">
          Capacity: {room.capacity} · €{room.priceEur}/night
        </p>
      </div>

      <section>
        <h2 className="mb-4 text-lg font-semibold text-gray-900">Book this room</h2>
        <BookingPanel roomId={roomId!} />
      </section>

      <section>
        <h2 className="mb-4 text-lg font-semibold text-gray-900">Active Bookings</h2>
        <BookingList bookings={room.bookings} />
      </section>
    </div>
  );
}
""")

# ── UI primitives ─────────────────────────────────────────

write("client/web/src/components/ui/ErrorBoundary.tsx", """\
import { Component, ErrorInfo, ReactNode } from "react";

interface Props {
  children: ReactNode;
  fallback?: ReactNode;
}

interface State {
  hasError: boolean;
  error: Error | null;
}

export class ErrorBoundary extends Component<Props, State> {
  state: State = { hasError: false, error: null };

  static getDerivedStateFromError(error: Error): State {
    return { hasError: true, error };
  }

  componentDidCatch(error: Error, info: ErrorInfo) {
    console.error("[ErrorBoundary] Uncaught render error:", error, info.componentStack);
  }

  private handleRetry = () => {
    this.setState({ hasError: false, error: null });
  };

  render() {
    if (this.state.hasError) {
      if (this.props.fallback) return this.props.fallback;
      return (
        <div className="rounded-lg border border-red-200 bg-red-50 p-6 text-center">
          <p className="font-semibold text-red-700">Something went wrong</p>
          {this.state.error && (
            <p className="mt-1 text-sm text-red-500">{this.state.error.message}</p>
          )}
          <button
            onClick={this.handleRetry}
            className="mt-4 rounded-md bg-red-600 px-4 py-2 text-sm font-medium text-white hover:bg-red-700"
          >
            Retry
          </button>
        </div>
      );
    }
    return this.props.children;
  }
}
""")

write("client/web/src/components/ui/Button.tsx", """\
import { ButtonHTMLAttributes } from "react";

type Variant = "primary" | "secondary" | "danger";

interface Props extends ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: Variant;
  loading?: boolean;
}

const variantClasses: Record<Variant, string> = {
  primary:   "bg-blue-600 text-white hover:bg-blue-700",
  secondary: "bg-gray-100 text-gray-900 hover:bg-gray-200",
  danger:    "bg-red-600 text-white hover:bg-red-700",
};

export function Button({
  variant = "primary",
  loading = false,
  disabled,
  children,
  className = "",
  ...rest
}: Props) {
  const isDisabled = disabled ?? loading;
  return (
    <button
      disabled={isDisabled}
      className={[
        "rounded-md px-4 py-2 text-sm font-medium transition-colors",
        "focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500",
        variantClasses[variant],
        isDisabled ? "cursor-not-allowed opacity-60" : "cursor-pointer",
        className,
      ].join(" ")}
      {...rest}
    >
      {loading ? "Loading…" : children}
    </button>
  );
}
""")

write("client/web/src/components/ui/Input.tsx", """\
import { InputHTMLAttributes } from "react";

interface Props extends InputHTMLAttributes<HTMLInputElement> {
  label: string;
  error?: string;
}

export function Input({ label, error, id, ...rest }: Props) {
  const inputId = id ?? label.toLowerCase().replace(/\\s+/g, "-");
  return (
    <div className="flex flex-col gap-1">
      <label htmlFor={inputId} className="text-sm font-medium text-gray-700">
        {label}
      </label>
      <input
        id={inputId}
        className={[
          "rounded-md border px-3 py-2 text-sm",
          "focus:outline-none focus:ring-2 focus:ring-blue-500",
          error ? "border-red-400" : "border-gray-300",
        ].join(" ")}
        {...rest}
      />
      {error && <span className="text-xs text-red-600">{error}</span>}
    </div>
  );
}
""")

write("client/web/src/components/ui/Layout.tsx", """\
import { ReactNode } from "react";
import { Link, useLocation, useNavigate } from "react-router-dom";

interface Props {
  children: ReactNode;
}

function useBreadcrumbs() {
  const { pathname } = useLocation();
  const segments = pathname.split("/").filter(Boolean);
  const crumbs: { label: string; to: string }[] = [{ label: "Hotels", to: "/" }];
  if (segments[0] === "hotels" && segments[1]) {
    crumbs.push({ label: "Rooms", to: `/hotels/${segments[1]}` });
  }
  if (segments[2] === "rooms" && segments[3]) {
    crumbs.push({ label: "Room detail", to: pathname });
  }
  return crumbs;
}

export function Layout({ children }: Props) {
  const navigate = useNavigate();
  const crumbs = useBreadcrumbs();
  const isRoot = crumbs.length === 1;

  return (
    <div className="mx-auto max-w-3xl px-4 py-8 font-sans">
      <header className="mb-6">
        <h1 className="text-2xl font-bold text-gray-900">🏨 Hotel Booking</h1>
        <nav className="mt-2 flex items-center gap-1 text-sm text-gray-500">
          {crumbs.map((crumb, i) => {
            const isLast = i === crumbs.length - 1;
            return (
              <span key={crumb.to} className="flex items-center gap-1">
                {i > 0 && <span className="text-gray-300">/</span>}
                {isLast ? (
                  <span className="font-medium text-gray-900">{crumb.label}</span>
                ) : (
                  <Link to={crumb.to} className="hover:underline">{crumb.label}</Link>
                )}
              </span>
            );
          })}
        </nav>
        {!isRoot && (
          <button
            onClick={() => navigate(-1)}
            className="mt-3 text-sm text-blue-600 hover:underline"
          >
            ← Back
          </button>
        )}
      </header>
      <main>{children}</main>
    </div>
  );
}
""")

write("client/web/src/components/ui/Modal.tsx", """\
import { ReactNode } from "react";
import { Button } from "./Button";

interface Props {
  open: boolean;
  title: string;
  children: ReactNode;
  onClose: () => void;
}

export function Modal({ open, title, children, onClose }: Props) {
  if (!open) return null;
  return (
    <div
      className="fixed inset-0 z-50 flex items-center justify-center bg-black/50"
      onClick={onClose}
    >
      <div
        className="w-full max-w-sm rounded-xl bg-white p-6 shadow-xl"
        onClick={(e) => e.stopPropagation()}
      >
        <h3 className="text-lg font-semibold text-gray-900">{title}</h3>
        <div className="mt-2 text-sm text-gray-600">{children}</div>
        <div className="mt-6 flex justify-end">
          <Button onClick={onClose}>Choose new dates</Button>
        </div>
      </div>
    </div>
  );
}
""")

# ── Hotels ────────────────────────────────────────────────

write("client/web/src/components/hotels/HotelCard.tsx", """\
import { useNavigate } from "react-router-dom";
import { GetHotelsQuery } from "@modules/graphql/generated";
import { Button } from "../ui/Button";

type Hotel = GetHotelsQuery["hotels"][number];

interface Props {
  hotel: Hotel;
}

export function HotelCard({ hotel }: Props) {
  const navigate = useNavigate();
  return (
    <div className="flex items-center justify-between rounded-lg border border-gray-200 p-4">
      <div>
        <h3 className="font-semibold text-gray-900">{hotel.name}</h3>
        <p className="mt-0.5 text-sm text-gray-500">{hotel.city}</p>
      </div>
      <Button onClick={() => navigate(`/hotels/${hotel.id}`)}>View Rooms →</Button>
    </div>
  );
}
""")

write("client/web/src/components/hotels/HotelList.tsx", """\
import { useGetHotelsQuery } from "@modules/graphql/generated";
import { HotelCard } from "./HotelCard";

export function HotelList() {
  const { data, loading, error } = useGetHotelsQuery();
  if (loading) return <p className="text-gray-500">Loading hotels…</p>;
  if (error) return <p className="text-red-600">Error: {error.message}</p>;
  if (!data?.hotels.length) return <p className="text-gray-500">No hotels found.</p>;
  return (
    <div className="flex flex-col gap-3">
      {data.hotels.map((hotel) => <HotelCard key={hotel.id} hotel={hotel} />)}
    </div>
  );
}
""")

# ── Rooms ─────────────────────────────────────────────────

write("client/web/src/components/rooms/RoomCard.tsx", """\
import { useNavigate } from "react-router-dom";
import { GetRoomsQuery } from "@modules/graphql/generated";
import { Button } from "../ui/Button";

type Room = GetRoomsQuery["rooms"][number];

interface Props {
  room: Room;
  hotelId: string;
}

export function RoomCard({ room, hotelId }: Props) {
  const navigate = useNavigate();
  return (
    <div className="flex items-center justify-between rounded-lg border border-gray-200 p-4">
      <div>
        <h4 className="font-semibold text-gray-900">Room {room.number}</h4>
        {room.title && <p className="mt-0.5 text-sm text-gray-500">{room.title}</p>}
        <p className="mt-1 text-xs text-gray-400">
          Capacity: {room.capacity} · €{room.priceEur}/night
        </p>
      </div>
      <Button onClick={() => navigate(`/hotels/${hotelId}/rooms/${room.id}`)}>
        View →
      </Button>
    </div>
  );
}
""")

write("client/web/src/components/rooms/RoomList.tsx", """\
import { useParams } from "react-router-dom";
import { useGetRoomsQuery } from "@modules/graphql/generated";
import { RoomCard } from "./RoomCard";

export function RoomList() {
  const { hotelId } = useParams<{ hotelId: string }>();
  const { data, loading, error } = useGetRoomsQuery({
    variables: { hotelId: hotelId! },
  });
  if (loading) return <p className="text-gray-500">Loading rooms…</p>;
  if (error) return <p className="text-red-600">Error: {error.message}</p>;
  if (!data?.rooms.length) return <p className="text-gray-500">No rooms found.</p>;
  return (
    <div className="flex flex-col gap-3">
      {data.rooms.map((room) => (
        <RoomCard key={room.id} room={room} hotelId={hotelId!} />
      ))}
    </div>
  );
}
""")

# ── Bookings ──────────────────────────────────────────────

write("client/web/src/components/bookings/BookingPanel.tsx", """\
import { useState, useEffect } from "react";
import {
  useGetAvailabilityLazyQuery,
  useCreateBookingMutation,
  GetRoomDocument,
} from "@modules/graphql/generated";
import { Input } from "../ui/Input";
import { Button } from "../ui/Button";
import { Modal } from "../ui/Modal";

interface Props {
  roomId: string;
}

interface DateRange {
  startDate: string;
  endDate: string;
}

type AvailabilityStatus = "idle" | "checking" | "available" | "unavailable";

// Combined flow:
// 1. User picks dates → availability check fires automatically
// 2. Available → guest name field appears + Book button activates
// 3. CONFLICT from server (race condition) → modal, dates reset
export function BookingPanel({ roomId }: Props) {
  const [range, setRange] = useState<DateRange>({ startDate: "", endDate: "" });
  const [guestName, setGuestName] = useState("");
  const [guestNameError, setGuestNameError] = useState<string | null>(null);
  const [status, setStatus] = useState<AvailabilityStatus>("idle");
  const [raceModalOpen, setRaceModalOpen] = useState(false);

  const [checkAvailability, { data: availData, loading: availLoading }] =
    useGetAvailabilityLazyQuery({ fetchPolicy: "network-only" });

  const [createBooking, { loading: bookingLoading, error: bookingError }] =
    useCreateBookingMutation({
      refetchQueries: [GetRoomDocument],
      awaitRefetchQueries: true,
    });

  useEffect(() => {
    const { startDate, endDate } = range;
    if (!startDate || !endDate || startDate >= endDate) {
      setStatus("idle");
      return;
    }
    setStatus("checking");
    checkAvailability({
      variables: {
        roomId,
        startDate: new Date(startDate).toISOString(),
        endDate: new Date(endDate).toISOString(),
      },
    });
  }, [range.startDate, range.endDate]);

  useEffect(() => {
    if (availLoading || !availData) return;
    setStatus(availData.availability.isAvailable ? "available" : "unavailable");
  }, [availData, availLoading]);

  function handleDateChange(field: keyof DateRange, value: string) {
    setRange((prev) => ({ ...prev, [field]: value }));
    setStatus("idle");
  }

  function resetDates() {
    setRange({ startDate: "", endDate: "" });
    setGuestName("");
    setStatus("idle");
    setRaceModalOpen(false);
  }

  async function handleBook() {
    if (!guestName.trim()) {
      setGuestNameError("Guest name is required");
      return;
    }
    setGuestNameError(null);

    try {
      await createBooking({
        variables: {
          roomId,
          guestName: guestName.trim(),
          startDate: new Date(range.startDate).toISOString(),
          endDate: new Date(range.endDate).toISOString(),
        },
      });
      resetDates();
    } catch (e: unknown) {
      const isConflict = (e as { graphQLErrors?: { extensions?: { code?: string } }[] })
        ?.graphQLErrors?.some((err) => err.extensions?.code === "CONFLICT");
      if (isConflict) {
        setRaceModalOpen(true);
      }
    }
  }

  const conflicts = availData?.availability.conflicts ?? [];
  const isDateRangeValid = range.startDate && range.endDate && range.startDate < range.endDate;
  const canBook = status === "available" && isDateRangeValid;
  const today = new Date().toISOString().split("T")[0];

  return (
    <>
      <div className="flex max-w-sm flex-col gap-4">
        <Input
          label="Check-in date"
          type="date"
          value={range.startDate}
          min={today}
          onChange={(e) => handleDateChange("startDate", e.target.value)}
        />
        <Input
          label="Check-out date"
          type="date"
          value={range.endDate}
          min={range.startDate || today}
          onChange={(e) => handleDateChange("endDate", e.target.value)}
        />

        {status === "checking" && (
          <p className="text-sm text-gray-500">Checking availability…</p>
        )}

        {status === "unavailable" && (
          <div className="rounded-lg border border-red-200 bg-red-50 p-3">
            <p className="text-sm font-medium text-red-700">✗ Not available</p>
            {conflicts.length > 0 && (
              <ul className="mt-1 space-y-0.5">
                {conflicts.map((c) => (
                  <li key={c.id} className="text-xs text-red-500">
                    {c.guestName}: {new Date(c.startDate).toLocaleDateString()} –{" "}
                    {new Date(c.endDate).toLocaleDateString()}
                  </li>
                ))}
              </ul>
            )}
          </div>
        )}

        {status === "available" && (
          <div className="rounded-lg border border-green-200 bg-green-50 p-3">
            <p className="text-sm font-medium text-green-700">
              ✓ Available — fill in your name to book
            </p>
          </div>
        )}

        {status === "available" && (
          <Input
            label="Guest name"
            value={guestName}
            onChange={(e) => {
              setGuestName(e.target.value);
              if (guestNameError) setGuestNameError(null);
            }}
            error={guestNameError ?? undefined}
            placeholder="John Smith"
          />
        )}

        {bookingError && !raceModalOpen && (
          <p className="text-sm text-red-600">
            {bookingError.graphQLErrors[0]?.message ?? bookingError.message}
          </p>
        )}

        <Button onClick={handleBook} loading={bookingLoading} disabled={!canBook}>
          Book Room
        </Button>
      </div>

      <Modal open={raceModalOpen} title="Dates no longer available" onClose={resetDates}>
        <p>
          Someone else just booked this room for the selected dates.
          Please choose different dates.
        </p>
      </Modal>
    </>
  );
}
""")

write("client/web/src/components/bookings/BookingList.tsx", """\
import { GetRoomQuery } from "@modules/graphql/generated";
import { CancelBookingButton } from "./CancelBookingButton";

type Booking = GetRoomQuery["room"]["bookings"][number];

interface Props {
  bookings: Booking[];
  loading?: boolean;
  error?: string;
}

export function BookingList({ bookings, loading, error }: Props) {
  if (loading) return <p className="text-gray-500">Loading bookings…</p>;
  if (error) return <p className="text-red-600">Error: {error}</p>;
  if (bookings.length === 0) return <p className="text-gray-500">No active bookings.</p>;

  return (
    <div className="flex flex-col gap-3">
      {bookings.map((booking) => (
        <div
          key={booking.id}
          className="flex items-center justify-between rounded-lg border border-gray-200 p-3"
        >
          <div>
            <p className="font-medium text-gray-900">{booking.guestName}</p>
            <p className="mt-0.5 text-xs text-gray-500">
              {new Date(booking.startDate).toLocaleDateString()} →{" "}
              {new Date(booking.endDate).toLocaleDateString()}
            </p>
          </div>
          <CancelBookingButton bookingId={booking.id} />
        </div>
      ))}
    </div>
  );
}
""")

write("client/web/src/components/bookings/CancelBookingButton.tsx", """\
import { useCancelBookingMutation, GetRoomDocument } from "@modules/graphql/generated";
import { Button } from "../ui/Button";

interface Props {
  bookingId: string;
}

export function CancelBookingButton({ bookingId }: Props) {
  const [cancelBooking, { loading }] = useCancelBookingMutation({
    variables: { bookingId },
    refetchQueries: [GetRoomDocument],
    awaitRefetchQueries: true,
  });

  return (
    <Button
      variant="danger"
      loading={loading}
      onClick={() => {
        if (window.confirm("Cancel this booking?")) cancelBooking();
      }}
    >
      Cancel
    </Button>
  );
}
""")

print("All source files written successfully.")
PYEOF

ok "All source files written"

# ── Docker and infra files ────────────────────────────────────────────────
log "Writing infra files..."

cat > .dockerignore << 'EOF'
**/node_modules
client/web/dist
client/modules/graphql/generated
.git
.gitignore
**/.DS_Store
backend/
coverage/
EOF

cat > docker-compose.yml << 'EOF'
services:
  db:
    image: postgres:16-alpine
    container_name: myapp_db
    restart: unless-stopped
    environment:
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
      POSTGRES_DB: ${POSTGRES_DB}
    ports:
      - "${POSTGRES_PORT:-5432}:5432"
    volumes:
      - pgdata:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U $$POSTGRES_USER -d $$POSTGRES_DB"]
      interval: 3s
      timeout: 3s
      retries: 20

  api:
    build:
      context: ./backend/api
      dockerfile: Dockerfile
    container_name: myapp_api
    restart: unless-stopped
    environment:
      NODE_ENV: development
      PORT: 4000
      DATABASE_URL: ${DATABASE_URL}
    depends_on:
      db:
        condition: service_healthy
    ports:
      - "${API_PORT:-4000}:4000"
    volumes:
      - ./backend/api:/app
      - /app/node_modules
      - ./graphql:/app/graphql:ro
    command: sh -c "npm install && npx prisma migrate deploy && npm run dev"
    healthcheck:
      test:
        - "CMD-SHELL"
        - |
          node -e "
            const http = require('http');
            const req = http.request(
              { host: 'localhost', port: 4000, path: '/graphql', method: 'POST',
                headers: { 'Content-Type': 'application/json' } },
              (res) => process.exit(res.statusCode < 500 ? 0 : 1)
            );
            req.on('error', () => process.exit(1));
            req.end(JSON.stringify({ query: '{__typename}' }));
          "
      interval: 5s
      timeout: 5s
      retries: 20
      start_period: 30s

  web:
    build:
      context: .
      dockerfile: client/web/Dockerfile
      target: prod
    container_name: myapp_web
    restart: unless-stopped
    depends_on:
      api:
        condition: service_healthy

volumes:
  pgdata:
EOF

cat > docker-compose.override.yml << 'EOF'
# Applied automatically by `docker compose up` (dev).
# For prod: docker compose -f docker-compose.yml -f docker-compose.prod.yml up --build
services:
  web:
    build:
      target: dev
    ports:
      - "127.0.0.1:${WEB_PORT:-8888}:3000"
    volumes:
      - ./client/web:/app/client/web
      - ./client/modules:/app/client/modules
      - ./graphql:/app/graphql:ro
      - /app/client/web/node_modules
    environment:
      - NODE_ENV=development
EOF

cat > docker-compose.prod.yml << 'EOF'
# Production: docker compose -f docker-compose.yml -f docker-compose.prod.yml up --build
services:
  web:
    build:
      target: prod
    ports:
      - "127.0.0.1:${WEB_PORT:-8888}:80"
EOF

ok "Infra files written"

# ── .env — add WEB_PORT if missing ───────────────────────────────────────
if [[ -f ".env" ]]; then
  if ! grep -q "WEB_PORT" .env; then
    echo "" >> .env
    echo "WEB_PORT=8888" >> .env
    ok ".env updated with WEB_PORT=8888"
  else
    warn ".env already has WEB_PORT — skipping"
  fi
else
  warn ".env not found — create it with your POSTGRES_* and DATABASE_URL values"
fi

# ── .gitignore additions ──────────────────────────────────────────────────
if [[ -f ".gitignore" ]]; then
  if ! grep -q "graphql/generated" .gitignore; then
    cat >> .gitignore << 'EOF'

# Client generated files
client/web/node_modules/
client/web/dist/
client/modules/graphql/generated/
EOF
    ok ".gitignore updated"
  else
    warn ".gitignore already has generated entries — skipping"
  fi
fi

# ── Reminder: package-lock.json ──────────────────────────────────────────
echo ""
echo -e "${YELLOW}════════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}  IMPORTANT: package-lock.json required before build    ${NC}"
echo -e "${YELLOW}════════════════════════════════════════════════════════${NC}"
echo ""
echo "  If client/web/package-lock.json does not exist yet:"
echo ""
echo "    cd client/web && npm install && cd ../.."
echo "    git add client/web/package-lock.json"
echo ""
echo -e "${GREEN}════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  Then start:                                           ${NC}"
echo -e "${GREEN}════════════════════════════════════════════════════════${NC}"
echo ""
echo "  DEV (hot-reload):"
echo "    docker compose down -v && docker compose up --build"
echo "    open http://localhost:\${WEB_PORT:-8888}"
echo ""
echo "  PROD:"
echo "    docker compose -f docker-compose.yml -f docker-compose.prod.yml up --build"
echo ""
