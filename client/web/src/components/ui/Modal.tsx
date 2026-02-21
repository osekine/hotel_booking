import { ReactNode } from "react";
import { Button } from "./Button";

interface Props {
  open: boolean;
  title: string;
  children: ReactNode;
  onClose: () => void;
}

export function Modal({ open, title, children, onClose }: Props) {
  if (!open) return null;
  return (
    <div
      className="fixed inset-0 z-50 flex items-center justify-center bg-black/50"
      onClick={onClose}
    >
      <div
        className="w-full max-w-sm rounded-xl bg-white p-6 shadow-xl"
        onClick={(e) => e.stopPropagation()}
      >
        <h3 className="text-lg font-semibold text-gray-900">{title}</h3>
        <div className="mt-2 text-sm text-gray-600">{children}</div>
        <div className="mt-6 flex justify-end">
          <Button onClick={onClose}>Choose new dates</Button>
        </div>
      </div>
    </div>
  );
}
