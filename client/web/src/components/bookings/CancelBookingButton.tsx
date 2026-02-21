import { useCancelBookingMutation, GetRoomDocument } from "@modules/graphql/generated";
import { Button } from "../ui/Button";

const REFETCH_AFTER_CANCEL = [GetRoomDocument];

interface Props {
  bookingId: string;
}

export function CancelBookingButton({ bookingId }: Props) {
  const [cancelBooking, { loading }] = useCancelBookingMutation({
    variables: { bookingId },
    refetchQueries: REFETCH_AFTER_CANCEL,
    awaitRefetchQueries: true,
  });

  return (
    <Button
      variant="danger"
      loading={loading}
      onClick={() => {
        if (window.confirm("Cancel this booking?")) {
          cancelBooking();
        }
      }}
    >
      Cancel
    </Button>
  );
}