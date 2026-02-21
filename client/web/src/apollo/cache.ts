import { InMemoryCache } from "@apollo/client";

export const cache = new InMemoryCache({
  typePolicies: {
    Room: {
      fields: {
        // bookings field varies by `status` argument —
        // cache them separately so ACTIVE and CANCELED lists don't collide.
        bookings: {
          keyArgs: ["status"],
        },
      },
    },
  },
});
