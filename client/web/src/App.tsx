import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom";
import { Layout } from "./components/ui/Layout";
import { HotelListPage } from "./pages/HotelListPage";
import { RoomListPage } from "./pages/RoomListPage";
import { RoomDetailPage } from "./pages/RoomDetailPage";
import { ErrorBoundary } from "./components/ui/ErrorBoundary";

export function App() {
  return (
    <BrowserRouter>
      <Layout>
        <ErrorBoundary>
          <Routes>
            <Route path="/" element={<HotelListPage />} />
            <Route path="/hotels/:hotelId" element={<RoomListPage />} />
            <Route path="/hotels/:hotelId/rooms/:roomId" element={<RoomDetailPage />} />
            <Route path="*" element={<Navigate to="/" replace />} />
          </Routes>
        </ErrorBoundary>
      </Layout>
    </BrowserRouter>
  );
}
