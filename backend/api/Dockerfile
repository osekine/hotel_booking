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
      context: ./api
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
      - ./api:/app
      - /app/node_modules
    command: sh -c "npm install && npx prisma migrate deploy && npm run dev"

volumes:
  pgdata:
