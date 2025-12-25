abstract class DetailBookEvent {}

class FetchBookDetail extends DetailBookEvent {
  final String bookId;
  FetchBookDetail(this.bookId);
}