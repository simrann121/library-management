// Books Bloc for Vidyalankar Library Management System

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecases/search_books_usecase.dart';

// Events
abstract class BooksEvent extends Equatable {
  const BooksEvent();

  @override
  List<Object?> get props => [];
}

class LoadBooks extends BooksEvent {}

class SearchBooks extends BooksEvent {
  final String query;

  const SearchBooks({required this.query});

  @override
  List<Object?> get props => [query];
}

class FilterBooksByCategory extends BooksEvent {
  final String category;

  const FilterBooksByCategory({required this.category});

  @override
  List<Object?> get props => [category];
}

class SortBooks extends BooksEvent {
  final String sortBy;

  const SortBooks({required this.sortBy});

  @override
  List<Object?> get props => [sortBy];
}

class BorrowBook extends BooksEvent {
  final String bookId;

  const BorrowBook({required this.bookId});

  @override
  List<Object?> get props => [bookId];
}

class ReturnBook extends BooksEvent {
  final String bookId;

  const ReturnBook({required this.bookId});

  @override
  List<Object?> get props => [bookId];
}

class LoadBorrowedBooks extends BooksEvent {}

class RefreshBooks extends BooksEvent {}

// States
abstract class BooksState extends Equatable {
  const BooksState();

  @override
  List<Object?> get props => [];
}

class BooksInitial extends BooksState {}

class BooksLoading extends BooksState {}

class BooksLoaded extends BooksState {
  final List<Book> books;
  final String? searchQuery;
  final String? categoryFilter;
  final String? sortBy;

  const BooksLoaded({
    required this.books,
    this.searchQuery,
    this.categoryFilter,
    this.sortBy,
  });

  @override
  List<Object?> get props => [books, searchQuery, categoryFilter, sortBy];
}

class BooksError extends BooksState {
  final String message;

  const BooksError({required this.message});

  @override
  List<Object?> get props => [message];
}

class BookBorrowed extends BooksState {
  final String bookTitle;

  const BookBorrowed({required this.bookTitle});

  @override
  List<Object?> get props => [bookTitle];
}

class BookReturned extends BooksState {
  final String bookTitle;

  const BookReturned({required this.bookTitle});

  @override
  List<Object?> get props => [bookTitle];
}

class BorrowedBooksLoaded extends BooksState {
  final List<BorrowedBook> borrowedBooks;

  const BorrowedBooksLoaded({required this.borrowedBooks});

  @override
  List<Object?> get props => [borrowedBooks];
}

// Models
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

// Bloc
class BooksBloc extends Bloc<BooksEvent, BooksState> {
  final SearchBooksUsecase searchBooksUsecase;

  BooksBloc({
    required this.searchBooksUsecase,
  }) : super(BooksInitial()) {
    on<LoadBooks>(_onLoadBooks);
    on<SearchBooks>(_onSearchBooks);
    on<FilterBooksByCategory>(_onFilterBooksByCategory);
    on<SortBooks>(_onSortBooks);
    on<BorrowBook>(_onBorrowBook);
    on<ReturnBook>(_onReturnBook);
    on<LoadBorrowedBooks>(_onLoadBorrowedBooks);
    on<RefreshBooks>(_onRefreshBooks);
  }

  Future<void> _onLoadBooks(
    LoadBooks event,
    Emitter<BooksState> emit,
  ) async {
    emit(BooksLoading());

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock data - replace with actual API calls
      final books = _getMockBooks();
      emit(BooksLoaded(books: books));
    } catch (e) {
      emit(BooksError(message: 'Failed to load books: ${e.toString()}'));
    }
  }

  Future<void> _onSearchBooks(
    SearchBooks event,
    Emitter<BooksState> emit,
  ) async {
    if (state is BooksLoaded) {
      final currentState = state as BooksLoaded;

      if (event.query.isEmpty) {
        emit(currentState.copyWith(searchQuery: null));
        return;
      }

      try {
        // Simulate search
        await Future.delayed(const Duration(milliseconds: 500));

        final allBooks = _getMockBooks();
        final filteredBooks = allBooks.where((book) {
          return book.title.toLowerCase().contains(event.query.toLowerCase()) ||
              book.author.toLowerCase().contains(event.query.toLowerCase()) ||
              book.isbn.contains(event.query);
        }).toList();

        emit(currentState.copyWith(
          books: filteredBooks,
          searchQuery: event.query,
        ));
      } catch (e) {
        emit(BooksError(message: 'Search failed: ${e.toString()}'));
      }
    }
  }

  Future<void> _onFilterBooksByCategory(
    FilterBooksByCategory event,
    Emitter<BooksState> emit,
  ) async {
    if (state is BooksLoaded) {
      final currentState = state as BooksLoaded;

      try {
        final allBooks = _getMockBooks();
        final filteredBooks = event.category == 'All'
            ? allBooks
            : allBooks
                .where((book) => book.category == event.category)
                .toList();

        emit(currentState.copyWith(
          books: filteredBooks,
          categoryFilter: event.category,
        ));
      } catch (e) {
        emit(BooksError(message: 'Filter failed: ${e.toString()}'));
      }
    }
  }

  Future<void> _onSortBooks(
    SortBooks event,
    Emitter<BooksState> emit,
  ) async {
    if (state is BooksLoaded) {
      final currentState = state as BooksLoaded;

      try {
        final sortedBooks = List<Book>.from(currentState.books);

        switch (event.sortBy) {
          case 'Title':
            sortedBooks.sort((a, b) => a.title.compareTo(b.title));
            break;
          case 'Author':
            sortedBooks.sort((a, b) => a.author.compareTo(b.author));
            break;
          case 'Date Added':
            sortedBooks.sort((a, b) => b.addedDate.compareTo(a.addedDate));
            break;
          case 'Popularity':
            sortedBooks.sort((a, b) => b.rating.compareTo(a.rating));
            break;
        }

        emit(currentState.copyWith(
          books: sortedBooks,
          sortBy: event.sortBy,
        ));
      } catch (e) {
        emit(BooksError(message: 'Sort failed: ${e.toString()}'));
      }
    }
  }

  Future<void> _onBorrowBook(
    BorrowBook event,
    Emitter<BooksState> emit,
  ) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Find the book
      final allBooks = _getMockBooks();
      final book = allBooks.firstWhere((book) => book.id == event.bookId);

      emit(BookBorrowed(bookTitle: book.title));

      // Refresh the books list
      add(LoadBooks());
    } catch (e) {
      emit(BooksError(message: 'Failed to borrow book: ${e.toString()}'));
    }
  }

  Future<void> _onReturnBook(
    ReturnBook event,
    Emitter<BooksState> emit,
  ) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      emit(const BookReturned(bookTitle: 'Book'));

      // Refresh the books list
      add(LoadBooks());
    } catch (e) {
      emit(BooksError(message: 'Failed to return book: ${e.toString()}'));
    }
  }

  Future<void> _onLoadBorrowedBooks(
    LoadBorrowedBooks event,
    Emitter<BooksState> emit,
  ) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      final borrowedBooks = _getMockBorrowedBooks();
      emit(BorrowedBooksLoaded(borrowedBooks: borrowedBooks));
    } catch (e) {
      emit(BooksError(
          message: 'Failed to load borrowed books: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshBooks(
    RefreshBooks event,
    Emitter<BooksState> emit,
  ) async {
    add(LoadBooks());
  }

  List<Book> _getMockBooks() {
    return [
      const Book(
        id: '1',
        title: 'Introduction to Algorithms',
        author: 'Thomas H. Cormen',
        isbn: '9780262033848',
        category: 'Computer Science',
        description:
            'A comprehensive introduction to algorithms and data structures.',
        publisher: 'MIT Press',
        publishedYear: 2009,
        pages: 1312,
        language: 'English',
        totalCopies: 5,
        availableCopies: 3,
        rating: 4.5,
        reviewCount: 120,
        addedDate: DateTime(2023, 1, 15),
      ),
      const Book(
        id: '2',
        title: 'Clean Code',
        author: 'Robert C. Martin',
        isbn: '9780132350884',
        category: 'Computer Science',
        description: 'A handbook of agile software craftsmanship.',
        publisher: 'Prentice Hall',
        publishedYear: 2008,
        pages: 464,
        language: 'English',
        totalCopies: 3,
        availableCopies: 1,
        rating: 4.7,
        reviewCount: 89,
        addedDate: DateTime(2023, 2, 10),
      ),
      const Book(
        id: '3',
        title: 'The Design of Everyday Things',
        author: 'Don Norman',
        isbn: '9780465050659',
        category: 'Design',
        description:
            'The psychology of everyday things and how design affects our lives.',
        publisher: 'Basic Books',
        publishedYear: 2013,
        pages: 368,
        language: 'English',
        totalCopies: 2,
        availableCopies: 2,
        rating: 4.3,
        reviewCount: 67,
        addedDate: DateTime(2023, 3, 5),
      ),
    ];
  }

  List<BorrowedBook> _getMockBorrowedBooks() {
    return [
      BorrowedBook(
        id: '1',
        bookId: '1',
        bookTitle: 'Introduction to Algorithms',
        bookAuthor: 'Thomas H. Cormen',
        borrowDate: DateTime.now().subtract(const Duration(days: 5)),
        dueDate: DateTime.now().add(const Duration(days: 9)),
        isOverdue: false,
        renewalCount: 0,
      ),
      BorrowedBook(
        id: '2',
        bookId: '2',
        bookTitle: 'Clean Code',
        bookAuthor: 'Robert C. Martin',
        borrowDate: DateTime.now().subtract(const Duration(days: 10)),
        dueDate: DateTime.now().subtract(const Duration(days: 4)),
        isOverdue: true,
        renewalCount: 1,
      ),
    ];
  }
}

// Extension for BooksLoaded
extension BooksLoadedExtension on BooksLoaded {
  BooksLoaded copyWith({
    List<Book>? books,
    String? searchQuery,
    String? categoryFilter,
    String? sortBy,
  }) {
    return BooksLoaded(
      books: books ?? this.books,
      searchQuery: searchQuery ?? this.searchQuery,
      categoryFilter: categoryFilter ?? this.categoryFilter,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}
