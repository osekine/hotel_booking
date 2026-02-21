import { useGetRoomsQuery } from "@modules/graphql/generated";
import { RoomCard } from "./RoomCard";

interface Props {
  hotelId: string;
  onSelectRoom: (id: string, number: string) => void;
}

export function RoomList({ hotelId, onSelectRoom }: Props) {
  const { data, loading, error } = useGetRoomsQuery({ variables: { hotelId } });

  if (loading) return <p className="text-gray-500">Loading rooms…</p>;
  if (error) return <p className="text-red-600">Error: {error.message}</p>;
  if (!data?.rooms.length) return <p className="text-gray-500">No rooms found.</p>;

  return (
    <div className="flex flex-col gap-3">
      {data.rooms.map((room) => (
        <RoomCard key={room.id} room={room} onSelect={onSelectRoom} />
      ))}
    </div>
  );
}