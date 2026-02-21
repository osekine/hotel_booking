FROM node:22-bookworm-slim

WORKDIR /app

# OpenSSL и сертификаты (нужны Prisma и нормальной работе https)
RUN apt-get update \
  && apt-get install -y --no-install-recommends openssl ca-certificates \
  && rm -rf /var/lib/apt/lists/*

COPY package*.json ./
RUN npm install

COPY . .

# Prisma Client
RUN npx prisma generate

EXPOSE 4000
CMD ["npm", "run", "dev"]
