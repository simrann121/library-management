// Books Use Cases for Vidyalankar Library Management System

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/book.dart';
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
