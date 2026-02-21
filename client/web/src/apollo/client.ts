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
  // In dev: Vite proxy forwards /graphql → http://api:4000/graphql
  // In prod: nginx routes /graphql → http://api:4000/graphql
  uri: "/graphql",
});

export const client = new ApolloClient({
  link: from([errorLink, httpLink]),
  cache,
  defaultOptions: {
    watchQuery: {
      // Always validate cache against network on first load.
      // Keeps UI consistent after mutations with refetchQueries.
      fetchPolicy: "cache-and-network",
    },
  },
});
