abstract class ReturnBookEvent {}

class SubmitReturnBook extends ReturnBookEvent {
  final String rentId;
  final int fine;

  SubmitReturnBook({
    required this.rentId,
    required this.fine,
  });
}
