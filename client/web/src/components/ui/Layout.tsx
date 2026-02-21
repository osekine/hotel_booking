import { ReactNode } from "react";
import { Link, useLocation, useNavigate } from "react-router-dom";

interface Props {
  children: ReactNode;
}

function useBreadcrumbs() {
  const { pathname } = useLocation();
  const segments = pathname.split("/").filter(Boolean);
  const crumbs: { label: string; to: string }[] = [{ label: "Hotels", to: "/" }];
  if (segments[0] === "hotels" && segments[1]) {
    crumbs.push({ label: "Rooms", to: `/hotels/${segments[1]}` });
  }
  if (segments[2] === "rooms" && segments[3]) {
    crumbs.push({ label: "Room detail", to: pathname });
  }
  return crumbs;
}

export function Layout({ children }: Props) {
  const navigate = useNavigate();
  const crumbs = useBreadcrumbs();
  const isRoot = crumbs.length === 1;

  return (
    <div className="mx-auto max-w-3xl px-4 py-8 font-sans">
      <header className="mb-6">
        <h1 className="text-2xl font-bold text-gray-900">🏨 Hotel Booking</h1>
        <nav className="mt-2 flex items-center gap-1 text-sm text-gray-500">
          {crumbs.map((crumb, i) => {
            const isLast = i === crumbs.length - 1;
            return (
              <span key={crumb.to} className="flex items-center gap-1">
                {i > 0 && <span className="text-gray-300">/</span>}
                {isLast ? (
                  <span className="font-medium text-gray-900">{crumb.label}</span>
                ) : (
                  <Link to={crumb.to} className="hover:underline">{crumb.label}</Link>
                )}
              </span>
            );
          })}
        </nav>
        {!isRoot && (
          <button
            onClick={() => navigate(-1)}
            className="mt-3 text-sm text-blue-600 hover:underline"
          >
            ← Back
          </button>
        )}
      </header>
      <main>{children}</main>
    </div>
  );
}
