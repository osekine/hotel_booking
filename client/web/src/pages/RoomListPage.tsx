import { useParams } from "react-router-dom";
import { useGetRoomsQuery } from "@modules/graphql/generated";
import { RoomCard } from "../components/rooms/RoomCard";

export function RoomListPage() {
  const { hotelId } = useParams<{ hotelId: string }>();
  const { data, loading, error } = useGetRoomsQuery({
    variables: { hotelId: hotelId! },
  });

  if (loading) return <p className="text-gray-500">Loading rooms…</p>;
  if (error) return <p className="text-red-600">Error: {error.message}</p>;
  if (!data?.rooms.length) return <p className="text-gray-500">No rooms found.</p>;

  return (
    <div className="flex flex-col gap-3">
      {data.rooms.map((room) => (
        <RoomCard key={room.id} room={room} hotelId={hotelId!} />
      ))}
    </div>
  );
}
