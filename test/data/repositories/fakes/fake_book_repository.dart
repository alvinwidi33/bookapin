import 'package:bookapin/data/models/books.dart';
import 'package:bookapin/data/repositories/book_repository/book_repository.dart';

class FakeBookRepository implements BookRepository {
  final bool shouldThrow;

  FakeBookRepository({this.shouldThrow = false});

  @override
  Future<BooksResponse> getBooks({
    String? sort,
    int page = 1,
    String? year,
    String? genre,
    String? keyword,
  }) async {
    if (shouldThrow) {
      throw Exception('Failed to fetch books');
    }

    return BooksResponse(
      books: [
        Book(
          id: 'book-1',
          title: 'Clean Architecture',
          coverImage: null,
          author: 'Robert C. Martin',
          category: 'Technology',
          price: '120000',
          pages: 350,
        ),
        Book(
          id: 'book-2',
          title: 'Flutter in Action',
          coverImage: null,
          author: 'Eric Windmill',
          category: 'Technology',
          price: '150000',
          pages: 320,
        ),
      ],
      pagination: Pagination(
        currentPage: page,
        totalPages: 1,
        totalItems: 2,
        itemsPerPage: 10,
        hasNextPage: false,
        hasPrevPage: false,
      ),
    );
  }

  @override
  Future<BookDetails> getBookById(String id) async {
    if (shouldThrow) {
      throw Exception('Book not found');
    }

    return BookDetails(
      id: id,
      title: 'Clean Architecture',
      coverImage: null,
      author: 'Robert C. Martin',
      totalPages: '350',
      category: 'Technology',
      summary: 'A handbook of agile software craftsmanship.',
      publishedDate: '2017-09-20',
      isbn: '9780134494166',
      publisher: 'Prentice Hall',
    );
  }

  @override
  Future<List<GenreStatistic>> getGenreStatistics() async {
    if (shouldThrow) {
      throw Exception('Failed to load statistics');
    }

    return [
      GenreStatistic(
        genre: 'Technology',
        count: 5,
      ),
      GenreStatistic(
        genre: 'Novel',
        count: 3,
      ),
    ];
  }
}
