import { useParams } from "react-router-dom";
import { useGetRoomQuery } from "@modules/graphql/generated";
import { BookingPanel } from "../components/bookings/BookingPanel";
import { BookingList } from "../components/bookings/BookingList";

export function RoomDetailPage() {
  const { roomId } = useParams<{ roomId: string }>();
  const { data, loading, error } = useGetRoomQuery({
    variables: { id: roomId! },
  });

  if (loading) return <p className="text-gray-500">Loading room…</p>;
  if (error) return <p className="text-red-600">Error: {error.message}</p>;

  const room = data!.room;

  return (
    <div className="flex flex-col gap-8">
      <div className="rounded-lg border border-gray-200 bg-gray-50 p-4">
        <h3 className="font-semibold text-gray-900">
          Room {room.number}{room.title ? ` — ${room.title}` : ""}
        </h3>
        <p className="mt-1 text-sm text-gray-500">
          Capacity: {room.capacity} · €{room.priceEur}/night
        </p>
      </div>

      <section>
        <h2 className="mb-4 text-lg font-semibold text-gray-900">Book this room</h2>
        <BookingPanel roomId={roomId!} />
      </section>

      <section>
        <h2 className="mb-4 text-lg font-semibold text-gray-900">Active Bookings</h2>
        <BookingList bookings={room.bookings} />
      </section>
    </div>
  );
}
