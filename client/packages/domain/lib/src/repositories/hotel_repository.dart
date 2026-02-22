import '../entities/hotel.dart';

abstract interface class HotelRepository {
  Future<List<Hotel>> getHotels();
}
