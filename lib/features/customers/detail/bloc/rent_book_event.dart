abstract class RentBookEvent {}

class SubmitRentBook extends RentBookEvent {
  final String bookId;
  final String userId;
  final int duration;
  final int price;

  SubmitRentBook({
    required this.bookId,
    required this.userId,
    required this.duration,
    required this.price,
  });
}
