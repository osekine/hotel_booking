import { InputHTMLAttributes } from "react";

interface Props extends InputHTMLAttributes<HTMLInputElement> {
  label: string;
  error?: string;
}

export function Input({ label, error, id, ...rest }: Props) {
  const inputId = id ?? label.toLowerCase().replace(/\s+/g, "-");
  return (
    <div className="flex flex-col gap-1">
      <label htmlFor={inputId} className="text-sm font-medium text-gray-700">
        {label}
      </label>
      <input
        id={inputId}
        className={[
          "rounded-md border px-3 py-2 text-sm",
          "focus:outline-none focus:ring-2 focus:ring-blue-500",
          error ? "border-red-400" : "border-gray-300",
        ].join(" ")}
        {...rest}
      />
      {error && <span className="text-xs text-red-600">{error}</span>}
    </div>
  );
}
