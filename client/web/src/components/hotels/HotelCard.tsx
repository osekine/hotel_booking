import { useNavigate } from "react-router-dom";
import { GetHotelsQuery } from "@modules/graphql/generated";
import { Button } from "../ui/Button";

type Hotel = GetHotelsQuery["hotels"][number];

interface Props {
  hotel: Hotel;
}

export function HotelCard({ hotel }: Props) {
  const navigate = useNavigate();
  return (
    <div className="flex items-center justify-between rounded-lg border border-gray-200 p-4">
      <div>
        <h3 className="font-semibold text-gray-900">{hotel.name}</h3>
        <p className="mt-0.5 text-sm text-gray-500">{hotel.city}</p>
      </div>
      <Button onClick={() => navigate(`/hotels/${hotel.id}`)}>View Rooms →</Button>
    </div>
  );
}
