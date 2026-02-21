import { useState } from "react";
import { useGetAvailabilityLazyQuery } from "@modules/graphql/generated";
import { Input } from "../ui/Input";
import { Button } from "../ui/Button";

interface Props {
  roomId: string;
}

interface DateRange {
  startDate: string;
  endDate: string;
}

interface DateRangeErrors {
  startDate?: string;
  endDate?: string;
  dateRange?: string;
}

function validateDateRange(range: DateRange): DateRangeErrors {
  const errors: DateRangeErrors = {};
  if (!range.startDate) errors.startDate = "Required";
  if (!range.endDate) errors.endDate = "Required";
  if (range.startDate && range.endDate && range.startDate >= range.endDate) {
    errors.dateRange = "Start date must be before end date";
  }
  return errors;
}

export function AvailabilityChecker({ roomId }: Props) {
  const [range, setRange] = useState<DateRange>({ startDate: "", endDate: "" });
  const [errors, setErrors] = useState<DateRangeErrors>({});

  const [checkAvailability, { data, loading, error }] = useGetAvailabilityLazyQuery({
    // Always hit the server — never serve stale availability from cache.
    fetchPolicy: "network-only",
  });

  function handleChange(field: keyof DateRange, value: string) {
    setRange((prev) => ({ ...prev, [field]: value }));
    if (errors[field]) setErrors((prev) => ({ ...prev, [field]: undefined }));
    if (errors.dateRange) setErrors((prev) => ({ ...prev, dateRange: undefined }));
  }

  function handleCheck() {
    const validationErrors = validateDateRange(range);
    if (Object.keys(validationErrors).length > 0) {
      setErrors(validationErrors);
      return;
    }
    checkAvailability({
      variables: {
        roomId,
        startDate: new Date(range.startDate).toISOString(),
        endDate: new Date(range.endDate).toISOString(),
      },
    });
  }

  const availability = data?.availability;

  return (
    <div className="max-w-sm">
      <div className="flex flex-col gap-4">
        <Input
          label="Start Date"
          type="date"
          value={range.startDate}
          onChange={(e) => handleChange("startDate", e.target.value)}
          error={errors.startDate}
        />
        <Input
          label="End Date"
          type="date"
          value={range.endDate}
          onChange={(e) => handleChange("endDate", e.target.value)}
          error={errors.endDate}
        />
        {errors.dateRange && (
          <p className="text-sm text-red-600">{errors.dateRange}</p>
        )}
        <Button onClick={handleCheck} loading={loading}>
          Check Availability
        </Button>
      </div>

      {error && (
        <p className="mt-4 text-sm text-red-600">Error: {error.message}</p>
      )}

      {availability && (
        <div
          className={[
            "mt-4 rounded-lg border p-4",
            availability.isAvailable
              ? "border-green-300 bg-green-50"
              : "border-red-300 bg-red-50",
          ].join(" ")}
        >
          <p
            className={[
              "font-semibold",
              availability.isAvailable ? "text-green-700" : "text-red-700",
            ].join(" ")}
          >
            {availability.isAvailable ? "✓ Available" : "✗ Not Available"}
          </p>

          {!availability.isAvailable && availability.conflicts.length > 0 && (
            <div className="mt-3">
              <p className="text-sm font-medium text-gray-700">Conflicting bookings:</p>
              {availability.conflicts.map((c) => (
                <p key={c.id} className="mt-1 text-xs text-gray-500">
                  {c.guestName}: {new Date(c.startDate).toLocaleDateString()} –{" "}
                  {new Date(c.endDate).toLocaleDateString()}
                </p>
              ))}
            </div>
          )}
        </div>
      )}
    </div>
  );
}