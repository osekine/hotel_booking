class Room {
  final String id;
  final String hotelId;
  final String number;
  final String? title;
  final int capacity;
  final int priceEur;

  const Room({
    required this.id,
    required this.hotelId,
    required this.number,
    required this.title,
    required this.capacity,
    required this.priceEur,
  });
}
