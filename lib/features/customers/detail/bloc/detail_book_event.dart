abstract class DetailBookEvent {}

class FetchBookDetail extends DetailBookEvent {
  final String bookId;
  FetchBookDetail({required this.bookId});
}