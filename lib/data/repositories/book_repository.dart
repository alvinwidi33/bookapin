import 'dart:developer';
import 'package:dio/dio.dart';
import '../models/books.dart';

class BookRepository {
  final Dio dio;
  const BookRepository(this.dio);

  Future<BooksResponse> getBooks({
    String? sort,
    int page = 1,
    String? year,
    String? genre,
    String? keyword,
  }) async {
    try {
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

      log('Book response: ${response.data}');

      if (response.statusCode == 200) {
        return BooksResponse.fromJson(response.data);
      }

      throw Exception('Failed to fetch books');
    } catch (e) {
      throw Exception('Failed: $e');
    }
  }
}
