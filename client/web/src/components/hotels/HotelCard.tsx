import { GetHotelsQuery } from "@modules/graphql/generated";
import { Button } from "../ui/Button";

// Type comes directly from codegen — no manual interface needed.
type Hotel = GetHotelsQuery["hotels"][number];

interface Props {
  hotel: Hotel;
  onSelect: (id: string, name: string) => void;
}

export function HotelCard({ hotel, onSelect }: Props) {
  return (
    <div className="flex items-center justify-between rounded-lg border border-gray-200 p-4">
      <div>
        <h3 className="font-semibold text-gray-900">{hotel.name}</h3>
        <p className="mt-0.5 text-sm text-gray-500">{hotel.city}</p>
      </div>
      <Button onClick={() => onSelect(hotel.id, hotel.name)}>View Rooms →</Button>
    </div>
  );
}