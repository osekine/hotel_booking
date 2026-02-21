import { useGetRoomQuery } from "@modules/graphql/generated";
import { BookingList } from "../bookings/BookingList";
import { BookingForm } from "../bookings/BookingForm";
import { AvailabilityChecker } from "../availability/AvailabilityChecker";

interface Props {
  roomId: string;
}

export function RoomDetail({ roomId }: Props) {
  const { data, loading, error } = useGetRoomQuery({
    variables: { id: roomId },
  });

  if (loading) return <p className="text-gray-500">Loading room…</p>;
  if (error) return <p className="text-red-600">Error: {error.message}</p>;

  const room = data!.room;

  return (
    <div className="flex flex-col gap-8">
      {/* Room summary */}
      <div className="rounded-lg border border-gray-200 bg-gray-50 p-4">
        <h3 className="font-semibold text-gray-900">
          Room {room.number}{room.title ? ` — ${room.title}` : ""}
        </h3>
        <p className="mt-1 text-sm text-gray-500">
          Capacity: {room.capacity} · €{room.priceEur}/night
        </p>
      </div>

      <section>
        <h2 className="mb-4 text-lg font-semibold text-gray-900">Check Availability</h2>
        <AvailabilityChecker roomId={roomId} />
      </section>

      <section>
        <h2 className="mb-4 text-lg font-semibold text-gray-900">New Booking</h2>
        <BookingForm roomId={roomId} />
      </section>

      <section>
        <h2 className="mb-4 text-lg font-semibold text-gray-900">Active Bookings</h2>
        {/* Bookings come from this query — BookingList is purely presentational */}
        <BookingList bookings={room.bookings} />
      </section>
    </div>
  );
}