# Build context: project root (.)
# Referenced in docker-compose as: context: .  dockerfile: client/web/Dockerfile
#
# Path layout inside build stages (mirrors project structure under /app):
#   /app/graphql/                    ← schema + operations
#   /app/client/modules/graphql/     ← codegen.yml, generated/
#   /app/client/web/                 ← source, package.json, vite.config.ts

# ── Stage 1: deps ──────────────────────────────────────────────────────────
# Install node_modules once, reused by dev/build stages.
FROM node:20-alpine AS deps
WORKDIR /app/client/web
COPY client/web/package.json ./
COPY client/web/package-lock.json ./
RUN npm ci

# ── Stage 2: dev ───────────────────────────────────────────────────────────
# Used via docker-compose.override.yml (hot-reload).
# Source and graphql/ are bind-mounted at runtime — no COPY needed here.
# Codegen runs on container start so generated/ is always fresh.
FROM deps AS dev
WORKDIR /app/client/web
EXPOSE 3000
# Runs codegen first so @modules/graphql/generated exists before Vite starts.
CMD ["sh", "-c", "npm run codegen && npm run dev -- --host"]

# ── Stage 3: build ─────────────────────────────────────────────────────────
# Full production build. Copies everything needed, runs codegen, then Vite.
FROM deps AS build
WORKDIR /app

# Copy shared schema and operations (needed by codegen)
COPY graphql/ ./graphql/

# Copy modules (codegen.yml lives here; generated/ will be written here)
COPY client/modules/ ./client/modules/

# Copy web source
COPY client/web/ ./client/web/

WORKDIR /app/client/web

# Generate TypeScript types from schema + operations
RUN npm run codegen

# Type-check and bundle
RUN npm run build
# Output: /app/client/web/dist/

# ── Stage 4: prod ──────────────────────────────────────────────────────────
# Minimal nginx image serving the static build.
FROM nginx:alpine AS prod
COPY --from=build /app/client/web/dist /usr/share/nginx/html
COPY client/web/nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]