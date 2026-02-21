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
