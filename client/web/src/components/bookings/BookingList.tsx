import { GetRoomQuery } from "@modules/graphql/generated";
import { CancelBookingButton } from "./CancelBookingButton";

type Booking = GetRoomQuery["room"]["bookings"][number];

interface Props {
  bookings: Booking[];
  loading?: boolean;
  error?: string;
}

export function BookingList({ bookings, loading, error }: Props) {
  if (loading) return <p className="text-gray-500">Loading bookings…</p>;
  if (error) return <p className="text-red-600">Error: {error}</p>;
  if (bookings.length === 0) return <p className="text-gray-500">No active bookings.</p>;

  return (
    <div className="flex flex-col gap-3">
      {bookings.map((booking) => (
        <div
          key={booking.id}
          className="flex items-center justify-between rounded-lg border border-gray-200 p-3"
        >
          <div>
            <p className="font-medium text-gray-900">{booking.guestName}</p>
            <p className="mt-0.5 text-xs text-gray-500">
              {new Date(booking.startDate).toLocaleDateString()} →{" "}
              {new Date(booking.endDate).toLocaleDateString()}
            </p>
          </div>
          <CancelBookingButton bookingId={booking.id} />
        </div>
      ))}
    </div>
  );
}
