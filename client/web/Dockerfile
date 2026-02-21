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
