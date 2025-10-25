// Books Use Cases for Vidyalankar Library Management System

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/books_repository.dart';

class SearchBooksUsecase {
  final BooksRepository repository;

  SearchBooksUsecase(this.repository);

  Future<Either<Failure, List<Book>>> call(String query) async {
    return await repository.searchBooks(query);
  }
}

class BorrowBookUsecase {
  final BooksRepository repository;

  BorrowBookUsecase(this.repository);

  Future<Either<Failure, void>> call(String bookId, String userId) async {
    return await repository.borrowBook(bookId, userId);
  }
}

class ReturnBookUsecase {
  final BooksRepository repository;

  ReturnBookUsecase(this.repository);

  Future<Either<Failure, void>> call(String bookId, String userId) async {
    return await repository.returnBook(bookId, userId);
  }
}

class GetBorrowedBooksUsecase {
  final BooksRepository repository;

  GetBorrowedBooksUsecase(this.repository);

  Future<Either<Failure, List<BorrowedBook>>> call(String userId) async {
    return await repository.getBorrowedBooks(userId);
  }
}

// Models
class Book {
  final String id;
  final String title;
  final String author;
  final String isbn;
  final String category;
  final String description;
  final String publisher;
  final int publishedYear;
  final int pages;
  final String language;
  final int totalCopies;
  final int availableCopies;
  final double rating;
  final int reviewCount;
  final String? coverImageUrl;
  final DateTime addedDate;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.isbn,
    required this.category,
    required this.description,
    required this.publisher,
    required this.publishedYear,
    required this.pages,
    required this.language,
    required this.totalCopies,
    required this.availableCopies,
    required this.rating,
    required this.reviewCount,
    this.coverImageUrl,
    required this.addedDate,
  });
}

class BorrowedBook {
  final String id;
  final String bookId;
  final String bookTitle;
  final String bookAuthor;
  final DateTime borrowDate;
  final DateTime dueDate;
  final bool isOverdue;
  final int renewalCount;
  final String? coverImageUrl;

  const BorrowedBook({
    required this.id,
    required this.bookId,
    required this.bookTitle,
    required this.bookAuthor,
    required this.borrowDate,
    required this.dueDate,
    required this.isOverdue,
    required this.renewalCount,
    this.coverImageUrl,
  });
}
