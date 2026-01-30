import 'package:bookapin/data/models/books.dart';
import 'package:bookapin/data/repositories/book_repository/book_repository.dart';
import 'package:dio/dio.dart';

class BookRepositoryImpl implements BookRepository {
  final Dio dio;

  BookRepositoryImpl(this.dio);

  @override
  Future<BooksResponse> getBooks({
    String? sort,
    int page = 1,
    String? year,
    String? genre,
    String? keyword,
  }) async {
    final response = await dio.get(
      '/api/v1/book',
      queryParameters: {
        if (sort != null) 'sort': sort,
        'page': page,
        if (year != null) 'year': year,
        if (genre != null) 'genre': genre,
        if (keyword != null) 'keyword': keyword,
      },
    );

    return BooksResponse.fromJson(response.data);
  }


  @override
  Future<BookDetails> getBookById(String id) async {
    final response = await dio.get('/api/v1/book/$id');
    return BookDetails.fromJson(response.data);
  }

  @override
  Future<List<GenreStatistic>> getGenreStatistics() async {
    final response = await dio.get('/api/v1/stats/genre');
    final List list = response.data['genre_statistics'];
    return list.map((e) => GenreStatistic.fromJson(e)).toList();
  }
}
