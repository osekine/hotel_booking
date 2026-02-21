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
