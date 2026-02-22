import 'package:go_router/go_router.dart';
import '../features/hotels/hotels_page.dart';
import '../features/rooms/rooms_page.dart';
import '../features/room/room_page.dart';

GoRouter buildRouter() {
  return GoRouter(
    initialLocation: '/hotels',
    routes: [
      GoRoute(
        path: '/hotels',
        builder: (_, __) => const HotelsPage(),
        routes: [
          GoRoute(
            path: ':hotelId/rooms',
            builder: (_, state) => RoomsPage(hotelId: state.pathParameters['hotelId']!),
          ),
        ],
      ),
      GoRoute(
        path: '/rooms/:roomId',
        builder: (_, state) => RoomPage(roomId: state.pathParameters['roomId']!),
      ),
    ],
  );
}
