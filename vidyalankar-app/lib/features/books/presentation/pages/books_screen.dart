// Books Screen for Vidyalankar Library Management System

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as app_error;
import '../bloc/books_bloc.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _selectedSortBy = 'Title';

  final List<String> _categories = [
    'All',
    'Computer Science',
    'Engineering',
    'Mathematics',
    'Physics',
    'Chemistry',
    'Literature',
    'History',
    'Reference',
  ];

  final List<String> _sortOptions = [
    'Title',
    'Author',
    'Date Added',
    'Popularity',
  ];

  @override
  void initState() {
    super.initState();
    // Load books when screen initializes
    context.read<BooksBloc>().add(LoadBooks());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BooksBloc, BooksState>(
      listener: (context, state) {
        if (state is BooksError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        } else if (state is BookBorrowed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Book "${state.bookTitle}" borrowed successfully!'),
              backgroundColor: AppTheme.successColor,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is BooksLoading) {
          return const LoadingWidget(message: 'Loading books...');
        }

        if (state is BooksError) {
          return app_error.ErrorWidget(
            message: state.message,
            onRetry: () {
              context.read<BooksBloc>().add(LoadBooks());
            },
          );
        }

        if (state is BooksLoaded) {
          return _buildBooksScreen(state);
        }

        return const LoadingWidget();
      },
    );
  }

  Widget _buildBooksScreen(BooksLoaded state) {
    return Column(
      children: [
        // Search and Filter Section
        _buildSearchAndFilter(),

        // Books List
        Expanded(
          child:
              state.books.isEmpty ? _buildEmptyState() : _buildBooksList(state),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        children: [
          // Search Bar
          CustomTextField(
            controller: _searchController,
            hintText: 'Search books, authors, or ISBN...',
            prefixIcon: Icons.search,
            onChanged: (value) {
              context.read<BooksBloc>().add(SearchBooks(query: value));
            },
          ),

          const SizedBox(height: AppConstants.defaultPadding),

          // Filter Row
          Row(
            children: [
              // Category Filter
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                    context
                        .read<BooksBloc>()
                        .add(FilterBooksByCategory(category: value!));
                  },
                ),
              ),

              const SizedBox(width: AppConstants.defaultPadding),

              // Sort Filter
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedSortBy,
                  decoration: const InputDecoration(
                    labelText: 'Sort By',
                    border: OutlineInputBorder(),
                  ),
                  items: _sortOptions.map((option) {
                    return DropdownMenuItem(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSortBy = value!;
                    });
                    context.read<BooksBloc>().add(SortBooks(sortBy: value!));
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.book_outlined,
              size: 80,
              color: AppTheme.lightTextSecondary,
            ),
            const SizedBox(height: AppConstants.largePadding),
            Text(
              'No books found',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppTheme.lightTextSecondary,
                  ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            Text(
              'Try adjusting your search criteria or filters',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTextSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.largePadding),
            CustomButton(
              text: 'Clear Filters',
              onPressed: () {
                setState(() {
                  _selectedCategory = 'All';
                  _selectedSortBy = 'Title';
                });
                _searchController.clear();
                context.read<BooksBloc>().add(LoadBooks());
              },
              variant: ButtonVariant.outlined,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBooksList(BooksLoaded state) {
    return ListView.builder(
      padding:
          const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
      itemCount: state.books.length,
      itemBuilder: (context, index) {
        final book = state.books[index];
        return _buildBookCard(book);
      },
    );
  }

  Widget _buildBookCard(Book book) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
      child: InkWell(
        onTap: () => _showBookDetails(book),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Row(
            children: [
              // Book Cover
              Container(
                width: 80,
                height: 120,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius:
                      BorderRadius.circular(AppConstants.smallBorderRadius),
                  border: Border.all(
                    color: AppTheme.lightBorderColor,
                    width: 1,
                  ),
                ),
                child: book.coverImageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(
                            AppConstants.smallBorderRadius),
                        child: Image.network(
                          book.coverImageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.book,
                              size: 40,
                              color: AppTheme.primaryColor,
                            );
                          },
                        ),
                      )
                    : const Icon(
                        Icons.book,
                        size: 40,
                        color: AppTheme.primaryColor,
                      ),
              ),

              const SizedBox(width: AppConstants.defaultPadding),

              // Book Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppConstants.smallPadding),
                    Text(
                      'by ${book.author}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.lightTextSecondary,
                          ),
                    ),
                    const SizedBox(height: AppConstants.smallPadding),
                    Text(
                      book.category,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: AppConstants.smallPadding),
                    Row(
                      children: [
                        Icon(
                          Icons.library_books,
                          size: 16,
                          color: AppTheme.lightTextSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${book.availableCopies}/${book.totalCopies} available',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.lightTextSecondary,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.smallPadding),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          book.rating.toString(),
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.lightTextSecondary,
                                  ),
                        ),
                        const SizedBox(width: AppConstants.defaultPadding),
                        Icon(
                          Icons.person,
                          size: 16,
                          color: AppTheme.lightTextSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${book.reviewCount} reviews',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.lightTextSecondary,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Action Button
              Column(
                children: [
                  if (book.availableCopies > 0)
                    CustomButton(
                      text: 'Borrow',
                      onPressed: () => _borrowBook(book),
                      size: ButtonSize.small,
                      isFullWidth: false,
                    )
                  else
                    CustomButton(
                      text: 'Reserve',
                      onPressed: () => _reserveBook(book),
                      size: ButtonSize.small,
                      variant: ButtonVariant.outlined,
                      isFullWidth: false,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBookDetails(Book book) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Text(
                    book.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),

            const SizedBox(height: AppConstants.defaultPadding),

            // Book Details
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'by ${book.author}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.lightTextSecondary,
                          ),
                    ),
                    const SizedBox(height: AppConstants.defaultPadding),
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: AppConstants.smallPadding),
                    Text(
                      book.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppConstants.defaultPadding),
                    Text(
                      'Details',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: AppConstants.smallPadding),
                    _buildDetailRow('Category', book.category),
                    _buildDetailRow('ISBN', book.isbn),
                    _buildDetailRow('Publisher', book.publisher),
                    _buildDetailRow(
                        'Published Year', book.publishedYear.toString()),
                    _buildDetailRow('Pages', book.pages.toString()),
                    _buildDetailRow('Language', book.language),
                    _buildDetailRow('Available Copies',
                        '${book.availableCopies}/${book.totalCopies}'),
                  ],
                ),
              ),
            ),

            // Action Buttons
            Row(
              children: [
                if (book.availableCopies > 0)
                  Expanded(
                    child: CustomButton(
                      text: 'Borrow Book',
                      onPressed: () {
                        Navigator.of(context).pop();
                        _borrowBook(book);
                      },
                    ),
                  )
                else
                  Expanded(
                    child: CustomButton(
                      text: 'Reserve Book',
                      onPressed: () {
                        Navigator.of(context).pop();
                        _reserveBook(book);
                      },
                      variant: ButtonVariant.outlined,
                    ),
                  ),
                const SizedBox(width: AppConstants.defaultPadding),
                Expanded(
                  child: CustomButton(
                    text: 'Add to Wishlist',
                    onPressed: () {
                      // Handle wishlist
                    },
                    variant: ButtonVariant.outlined,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.smallPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  void _borrowBook(Book book) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Borrow Book'),
        content: Text('Are you sure you want to borrow "${book.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<BooksBloc>().add(BorrowBook(bookId: book.id));
            },
            child: const Text('Borrow'),
          ),
        ],
      ),
    );
  }

  void _reserveBook(Book book) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reserve Book'),
        content: Text('Are you sure you want to reserve "${book.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Handle reservation
            },
            child: const Text('Reserve'),
          ),
        ],
      ),
    );
  }
}
