import { useState } from "react";
import { HotelList } from "./components/hotels/HotelList";
import { RoomList } from "./components/rooms/RoomList";
import { RoomDetail } from "./components/rooms/RoomDetail";
import { ErrorBoundary } from "./components/ui/ErrorBoundary";

type View = "hotels" | "rooms" | "room-detail";

export function App() {
  const [view, setView] = useState<View>("hotels");
  const [selectedHotelId, setSelectedHotelId] = useState<string | null>(null);
  const [selectedHotelName, setSelectedHotelName] = useState<string | null>(null);
  const [selectedRoomId, setSelectedRoomId] = useState<string | null>(null);
  const [selectedRoomNumber, setSelectedRoomNumber] = useState<string | null>(null);

  function handleSelectHotel(id: string, name: string) {
    setSelectedHotelId(id);
    setSelectedHotelName(name);
    setView("rooms");
  }

  function handleSelectRoom(id: string, number: string) {
    setSelectedRoomId(id);
    setSelectedRoomNumber(number);
    setView("room-detail");
  }

  function handleBack() {
    if (view === "room-detail") {
      setSelectedRoomId(null);
      setSelectedRoomNumber(null);
      setView("rooms");
    } else if (view === "rooms") {
      setSelectedHotelId(null);
      setSelectedHotelName(null);
      setView("hotels");
    }
  }

  const breadcrumb = [
    { label: "Hotels", active: view === "hotels" },
    ...(selectedHotelName
      ? [{ label: selectedHotelName, active: view === "rooms" }]
      : []),
    ...(selectedRoomNumber
      ? [{ label: `Room ${selectedRoomNumber}`, active: view === "room-detail" }]
      : []),
  ];

  return (
    <div className="mx-auto max-w-3xl px-4 py-8 font-sans">
      <header className="mb-6">
        <h1 className="text-2xl font-bold text-gray-900">🏨 Hotel Booking</h1>

        {/* Breadcrumb */}
        <nav className="mt-2 flex items-center gap-1 text-sm text-gray-500">
          {breadcrumb.map((crumb, i) => (
            <span key={crumb.label} className="flex items-center gap-1">
              {i > 0 && <span>/</span>}
              <span className={crumb.active ? "font-medium text-gray-900" : ""}>
                {crumb.label}
              </span>
            </span>
          ))}
        </nav>

        {view !== "hotels" && (
          <button
            onClick={handleBack}
            className="mt-3 text-sm text-blue-600 hover:underline"
          >
            ← Back
          </button>
        )}
      </header>

      <main>
        {/* Each view gets its own ErrorBoundary so one failing section
            doesn't take down the entire app */}
        <ErrorBoundary key={view}>
          {view === "hotels" && (
            <HotelList onSelectHotel={handleSelectHotel} />
          )}
          {view === "rooms" && selectedHotelId && (
            <RoomList hotelId={selectedHotelId} onSelectRoom={handleSelectRoom} />
          )}
          {view === "room-detail" && selectedRoomId && (
            <RoomDetail roomId={selectedRoomId} />
          )}
        </ErrorBoundary>
      </main>
    </div>
  );
}