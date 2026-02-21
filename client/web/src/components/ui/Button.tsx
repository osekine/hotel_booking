import { ButtonHTMLAttributes } from "react";

type Variant = "primary" | "secondary" | "danger";

interface Props extends ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: Variant;
  loading?: boolean;
}

const variantClasses: Record<Variant, string> = {
  primary:   "bg-blue-600 text-white hover:bg-blue-700",
  secondary: "bg-gray-100 text-gray-900 hover:bg-gray-200",
  danger:    "bg-red-600 text-white hover:bg-red-700",
};

export function Button({
  variant = "primary",
  loading = false,
  disabled,
  children,
  className = "",
  ...rest
}: Props) {
  const isDisabled = disabled ?? loading;
  return (
    <button
      disabled={isDisabled}
      className={[
        "rounded-md px-4 py-2 text-sm font-medium transition-colors",
        "focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500",
        variantClasses[variant],
        isDisabled ? "cursor-not-allowed opacity-60" : "cursor-pointer",
        className,
      ].join(" ")}
      {...rest}
    >
      {loading ? "Loading…" : children}
    </button>
  );
}
