import { useState } from "react";
import { useCreateBookingMutation, GetRoomDocument } from "@modules/graphql/generated";
import { Input } from "../ui/Input";
import { Button } from "../ui/Button";

// GetRoomDocument (typed DocumentNode) replaces the fragile string "GetRoom".
// If the query is renamed in .graphql files, codegen will catch the mismatch at build time.
const REFETCH_AFTER_CREATE = [GetRoomDocument];

interface Props {
  roomId: string;
}

interface FormState {
  guestName: string;
  startDate: string;
  endDate: string;
}

interface FormErrors {
  guestName?: string;
  startDate?: string;
  endDate?: string;
  dateRange?: string;
}

function validateForm(form: FormState): FormErrors {
  const errors: FormErrors = {};
  if (!form.guestName.trim()) errors.guestName = "Guest name is required";
  if (!form.startDate) errors.startDate = "Start date is required";
  if (!form.endDate) errors.endDate = "End date is required";
  if (form.startDate && form.endDate && form.startDate >= form.endDate) {
    errors.dateRange = "Start date must be before end date";
  }
  return errors;
}

export function BookingForm({ roomId }: Props) {
  const [form, setForm] = useState<FormState>({ guestName: "", startDate: "", endDate: "" });
  const [errors, setErrors] = useState<FormErrors>({});
  const [successMsg, setSuccessMsg] = useState<string | null>(null);

  const [createBooking, { loading, error: mutationError }] = useCreateBookingMutation({
    refetchQueries: REFETCH_AFTER_CREATE,
    awaitRefetchQueries: true,
    onCompleted: (data) => {
      const b = data.createBooking;
      setSuccessMsg(
        `Booked for ${b.guestName}: ${new Date(b.startDate).toLocaleDateString()} – ${new Date(b.endDate).toLocaleDateString()}`
      );
      setForm({ guestName: "", startDate: "", endDate: "" });
      setErrors({});
    },
  });

  function handleChange(field: keyof FormState, value: string) {
    setForm((prev) => ({ ...prev, [field]: value }));
    if (errors[field]) setErrors((prev) => ({ ...prev, [field]: undefined }));
    if (errors.dateRange) setErrors((prev) => ({ ...prev, dateRange: undefined }));
    setSuccessMsg(null);
  }

  async function handleSubmit() {
    const validationErrors = validateForm(form);
    if (Object.keys(validationErrors).length > 0) {
      setErrors(validationErrors);
      return;
    }
    await createBooking({
      variables: {
        roomId,
        guestName: form.guestName.trim(),
        startDate: new Date(form.startDate).toISOString(),
        endDate: new Date(form.endDate).toISOString(),
      },
    });
  }

  return (
    <div className="flex max-w-sm flex-col gap-4">
      <Input
        label="Guest Name"
        value={form.guestName}
        onChange={(e) => handleChange("guestName", e.target.value)}
        error={errors.guestName}
        placeholder="John Smith"
      />
      <Input
        label="Start Date"
        type="date"
        value={form.startDate}
        onChange={(e) => handleChange("startDate", e.target.value)}
        error={errors.startDate}
      />
      <Input
        label="End Date"
        type="date"
        value={form.endDate}
        onChange={(e) => handleChange("endDate", e.target.value)}
        error={errors.endDate}
      />
      {errors.dateRange && (
        <p className="text-sm text-red-600">{errors.dateRange}</p>
      )}
      {mutationError && (
        <p className="text-sm text-red-600">
          {mutationError.graphQLErrors[0]?.message ?? mutationError.message}
        </p>
      )}
      {successMsg && (
        <p className="text-sm text-green-600">✓ {successMsg}</p>
      )}
      <Button onClick={handleSubmit} loading={loading}>
        Book Room
      </Button>
    </div>
  );
}