import { ApolloServer } from "@apollo/server";
import { startStandaloneServer } from "@apollo/server/standalone";
import { PrismaClient } from "@prisma/client";
import { resolvers, typeDefs, Context } from "./schema";
import { seedIfNeeded } from "../prisma/seed";

const port = Number(process.env.PORT ?? 4000);

async function main() {
  const prisma = new PrismaClient();

  const log: Context["log"] = (msg, extra) => {
    const payload = { msg, ...extra, ts: new Date().toISOString() };
    // минималистично: console.log JSON
    console.log(JSON.stringify(payload));
  };

  // Seed при старте (только если БД пустая)
  await seedIfNeeded();

  const server = new ApolloServer<Context>({
    typeDefs,
    resolvers,
  });

  const { url } = await startStandaloneServer(server, {
    listen: { port },
    context: async () => ({ prisma, log }),
  });

  console.log(`🚀 GraphQL ready at ${url}`);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
