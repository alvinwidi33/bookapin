class Book {
  final String id;
  final String title;
  final String? coverImage;
  final String author;
  final String category;
  final String? price;
  final int pages;

  Book({
    required this.id,
    required this.title,
    this.coverImage,
    required this.author,
    required this.category,
    this.price,
    required this.pages,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['_id'],
      title: json['title'],
      coverImage: json['cover_image'],
      author: json['author']?['name'] ?? 'Unknown Author',
      category: json['category']?['name'] ?? 'N/A',
      price: json['details']?['price'],
      pages: int.tryParse(
        json['details']?['total_pages']
                ?.toString()
                .split(' ')
                .first ??
            '0',
      ) ?? 0,
    );
  }
}

class BookDetails {
  final Book book;
  final String noGm;
  final String isbn;
  final String price;
  final String totalPages;
  final String size;
  final String publishedDate;
  final String format;

  BookDetails({
    required this.book,
    required this.noGm,
    required this.isbn,
    required this.price,
    required this.totalPages,
    required this.size,
    required this.publishedDate,
    required this.format,
  });

  factory BookDetails.fromJson(Map<String, dynamic> json) {
    return BookDetails(
      book:json['book'],
      noGm: json['no_gm'],
      isbn: json['isbn'],
      price: json['price'],
      totalPages: json['total_pages'],
      size: json['size'],
      publishedDate: json['published_date'],
      format: json['format'],
    );
  }
}

class Author {
  final String name;
  final String url;

  Author({required this.name, required this.url});

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      name: json['name'],
      url: json['url'],
    );
  }
}

class Category {
  final String name;
  final String url;

  Category({required this.name, required this.url});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'],
      url: json['url'],
    );
  }
}

class BooksResponse {
  final List<Book> books;
  final Pagination pagination;

  BooksResponse({
    required this.books,
    required this.pagination,
  });

  factory BooksResponse.fromJson(Map<String, dynamic> json) {
    return BooksResponse(
      books: (json['books'] as List)
          .map((e) {
            try {
              return Book.fromJson(e);
            } catch (_) {
              return null;
            }
          })
          .whereType<Book>()
          .toList(),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }
}

class Tag {
  final String name;
  final String url;

  Tag({required this.name, required this.url});

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      name: json['name'],
      url: json['url'],
    );
  }
}

class BuyLink {
  final String store;
  final String url;

  BuyLink({required this.store, required this.url});

  factory BuyLink.fromJson(Map<String, dynamic> json) {
    return BuyLink(
      store: json['store'],
      url: json['url'],
    );
  }
}

class Pagination {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final bool hasNextPage;
  final bool hasPrevPage;

  Pagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
      totalItems: json['totalItems'],
      itemsPerPage: json['itemsPerPage'],
      hasNextPage: json['hasNextPage'],
      hasPrevPage: json['hasPrevPage'],
    );
  }
}
