import { useState, useEffect, useRef } from "react";
import {
  useGetAvailabilityLazyQuery,
  useCreateBookingMutation,
  GetRoomDocument,
} from "@modules/graphql/generated";
import { Input } from "../ui/Input";
import { Button } from "../ui/Button";
import { Modal } from "../ui/Modal";

interface Props {
  roomId: string;
  // Changes whenever the room's active bookings list changes (booking created or canceled).
  // BookingPanel watches this to re-check availability without needing access to the
  // bookings data itself — keeps the component focused on its own concern.
  bookingsKey: string;
}

interface DateRange {
  startDate: string;
  endDate: string;
}

type AvailabilityStatus = "idle" | "checking" | "available" | "unavailable";

export function BookingPanel({ roomId, bookingsKey }: Props) {
  const [range, setRange] = useState<DateRange>({ startDate: "", endDate: "" });
  const [guestName, setGuestName] = useState("");
  const [guestNameError, setGuestNameError] = useState<string | null>(null);
  const [status, setStatus] = useState<AvailabilityStatus>("idle");
  const [raceModalOpen, setRaceModalOpen] = useState(false);

  const [checkAvailability, { data: availData, loading: availLoading }] =
    useGetAvailabilityLazyQuery({ fetchPolicy: "network-only" });

  const [createBooking, { loading: bookingLoading, error: bookingError }] =
    useCreateBookingMutation({
      refetchQueries: [GetRoomDocument],
      awaitRefetchQueries: true,
    });

  // Runs the availability check for the currently selected date range.
  // Extracted so it can be called both from the date-change effect
  // and from the bookingsKey-change effect.
  function runAvailabilityCheck(startDate: string, endDate: string) {
    setStatus("checking");
    checkAvailability({
      variables: {
        roomId,
        startDate: new Date(startDate).toISOString(),
        endDate: new Date(endDate).toISOString(),
      },
    });
  }

  // Re-check when either date changes.
  useEffect(() => {
    const { startDate, endDate } = range;
    if (!startDate || !endDate || startDate >= endDate) {
      setStatus("idle");
      return;
    }
    runAvailabilityCheck(startDate, endDate);
  }, [range.startDate, range.endDate]);

  // Re-check when bookings change (e.g. a cancellation happened).
  // Skip the initial render — we only want to react to actual changes.
  const isFirstRender = useRef(true);
  useEffect(() => {
    if (isFirstRender.current) {
      isFirstRender.current = false;
      return;
    }
    const { startDate, endDate } = range;
    if (!startDate || !endDate || startDate >= endDate) return;
    runAvailabilityCheck(startDate, endDate);
  }, [bookingsKey]);

  // Sync availability query result → local status.
  useEffect(() => {
    if (availLoading || !availData) return;
    setStatus(availData.availability.isAvailable ? "available" : "unavailable");
  }, [availData, availLoading]);

  function handleDateChange(field: keyof DateRange, value: string) {
    setRange((prev) => ({ ...prev, [field]: value }));
    setStatus("idle");
  }

  function resetDates() {
    setRange({ startDate: "", endDate: "" });
    setGuestName("");
    setStatus("idle");
    setRaceModalOpen(false);
  }

  async function handleBook() {
    if (!guestName.trim()) {
      setGuestNameError("Guest name is required");
      return;
    }
    setGuestNameError(null);

    try {
      await createBooking({
        variables: {
          roomId,
          guestName: guestName.trim(),
          startDate: new Date(range.startDate).toISOString(),
          endDate: new Date(range.endDate).toISOString(),
        },
      });
      resetDates();
    } catch (e: unknown) {
      const isConflict = (e as { graphQLErrors?: { extensions?: { code?: string } }[] })
        ?.graphQLErrors?.some((err) => err.extensions?.code === "CONFLICT");
      if (isConflict) {
        setRaceModalOpen(true);
      }
    }
  }

  const conflicts = availData?.availability.conflicts ?? [];
  const isDateRangeValid = range.startDate && range.endDate && range.startDate < range.endDate;
  const canBook = status === "available" && isDateRangeValid;
  const today = new Date().toISOString().split("T")[0];

  return (
    <>
      <div className="flex max-w-sm flex-col gap-4">
        <Input
          label="Check-in date"
          type="date"
          value={range.startDate}
          min={today}
          onChange={(e) => handleDateChange("startDate", e.target.value)}
        />
        <Input
          label="Check-out date"
          type="date"
          value={range.endDate}
          min={range.startDate || today}
          onChange={(e) => handleDateChange("endDate", e.target.value)}
        />

        {status === "checking" && (
          <p className="text-sm text-gray-500">Checking availability…</p>
        )}

        {status === "unavailable" && (
          <div className="rounded-lg border border-red-200 bg-red-50 p-3">
            <p className="text-sm font-medium text-red-700">✗ Not available</p>
            {conflicts.length > 0 && (
              <ul className="mt-1 space-y-0.5">
                {conflicts.map((c) => (
                  <li key={c.id} className="text-xs text-red-500">
                    {c.guestName}: {new Date(c.startDate).toLocaleDateString()} –{" "}
                    {new Date(c.endDate).toLocaleDateString()}
                  </li>
                ))}
              </ul>
            )}
          </div>
        )}

        {status === "available" && (
          <div className="rounded-lg border border-green-200 bg-green-50 p-3">
            <p className="text-sm font-medium text-green-700">
              ✓ Available — fill in your name to book
            </p>
          </div>
        )}

        {status === "available" && (
          <Input
            label="Guest name"
            value={guestName}
            onChange={(e) => {
              setGuestName(e.target.value);
              if (guestNameError) setGuestNameError(null);
            }}
            error={guestNameError ?? undefined}
            placeholder="John Smith"
          />
        )}

        {bookingError && !raceModalOpen && (
          <p className="text-sm text-red-600">
            {bookingError.graphQLErrors[0]?.message ?? bookingError.message}
          </p>
        )}

        <Button onClick={handleBook} loading={bookingLoading} disabled={!canBook}>
          Book Room
        </Button>
      </div>

      <Modal open={raceModalOpen} title="Dates no longer available" onClose={resetDates}>
        <p>
          Someone else just booked this room for the selected dates.
          Please choose different dates.
        </p>
      </Modal>
    </>
  );
}