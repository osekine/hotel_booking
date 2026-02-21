import { useGetHotelsQuery } from "@modules/graphql/generated";
import { HotelCard } from "../components/hotels/HotelCard";

export function HotelListPage() {
  const { data, loading, error } = useGetHotelsQuery();

  if (loading) return <p className="text-gray-500">Loading hotels…</p>;
  if (error) return <p className="text-red-600">Error: {error.message}</p>;
  if (!data?.hotels.length) return <p className="text-gray-500">No hotels found.</p>;

  return (
    <div className="flex flex-col gap-3">
      {data.hotels.map((hotel) => (
        <HotelCard key={hotel.id} hotel={hotel} />
      ))}
    </div>
  );
}
