import { useNavigate } from "react-router-dom";
import { GetRoomsQuery } from "@modules/graphql/generated";
import { Button } from "../ui/Button";

type Room = GetRoomsQuery["rooms"][number];

interface Props {
  room: Room;
  hotelId: string;
}

export function RoomCard({ room, hotelId }: Props) {
  const navigate = useNavigate();
  return (
    <div className="flex items-center justify-between rounded-lg border border-gray-200 p-4">
      <div>
        <h4 className="font-semibold text-gray-900">Room {room.number}</h4>
        {room.title && <p className="mt-0.5 text-sm text-gray-500">{room.title}</p>}
        <p className="mt-1 text-xs text-gray-400">
          Capacity: {room.capacity} · €{room.priceEur}/night
        </p>
      </div>
      <Button onClick={() => navigate(`/hotels/${hotelId}/rooms/${room.id}`)}>
        View →
      </Button>
    </div>
  );
}
