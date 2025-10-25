// Books Repository Interface for Vidyalankar Library Management System

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/book.dart';

abstract class BooksRepository {
  Future<Either<Failure, List<Book>>> searchBooks(String query);
  Future<Either<Failure, void>> borrowBook(String bookId, String userId);
  Future<Either<Failure, void>> returnBook(String bookId, String userId);
  Future<Either<Failure, List<BorrowedBook>>> getBorrowedBooks(String userId);
}
