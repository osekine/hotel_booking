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
