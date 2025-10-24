// Book Entities for Vidyalankar Library Management System

import 'package:equatable/equatable.dart';

class Book extends Equatable {
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

  @override
  List<Object?> get props => [
        id,
        title,
        author,
        isbn,
        category,
        description,
        publisher,
        publishedYear,
        pages,
        language,
        totalCopies,
        availableCopies,
        rating,
        reviewCount,
        coverImageUrl,
        addedDate,
      ];
}

class BorrowedBook extends Equatable {
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

  @override
  List<Object?> get props => [
        id,
        bookId,
        bookTitle,
        bookAuthor,
        borrowDate,
        dueDate,
        isOverdue,
        renewalCount,
        coverImageUrl,
      ];
}
