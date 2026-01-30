import 'package:bookapin/data/models/books.dart';

abstract class BookRepository {
  Future<BooksResponse> getBooks({
    String? sort,
    int page = 1,
    String? year,
    String? genre,
    String? keyword,
  });

  Future<BookDetails> getBookById(String id);

  Future<List<GenreStatistic>> getGenreStatistics();
}
