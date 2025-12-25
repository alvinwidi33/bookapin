import 'package:bookapin/components/theme_data.dart';
import 'package:bookapin/data/repositories/book_repository.dart';
import 'package:bookapin/data/repositories/rent_repository.dart';
import 'package:bookapin/features/customers/detail/bloc/detail_book_bloc.dart';
import 'package:bookapin/features/customers/detail/bloc/detail_book_event.dart';
import 'package:bookapin/features/customers/detail/bloc/detail_book_state.dart';
import 'package:bookapin/features/customers/detail/bloc/rent_book_bloc.dart';
import 'package:bookapin/features/customers/detail/bloc/rent_book_event.dart';
import 'package:bookapin/features/customers/detail/bloc/rent_book_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DetailBook extends StatefulWidget {
  const DetailBook({super.key});

  @override
  State<DetailBook> createState() => _DetailBookState();
}

class _DetailBookState extends State<DetailBook> {
  int qty = 1;
  final int pricePerDay = 5000;
  int selectedTab = 0;

  void showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
  }

  void hideLoading(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args == null) {
      return const Scaffold(body: Center(child: Text("Book ID not found")));
    }

    final String bookId = args.toString();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              DetailBookBloc(context.read<BookRepository>())
                ..add(FetchBookDetail(bookId)),
        ),
        BlocProvider(
          create: (context) => RentBookBloc(context.read<RentRepository>()),
        ),
      ],
      child: BlocListener<RentBookBloc, RentBookState>(
        listener: (context, state) {
          if (state is RentBookLoading) {
            showLoading(context);
          }

          if (state is RentBookSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Rent book successful 📚")),
            );
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/history',
              (route) => route.isFirst,
            );
          }

          if (state is RentBookFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: BlocBuilder<DetailBookBloc, DetailBookState>(
              builder: (context, state) {
                if (state is DetailBookLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is DetailBookError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 64, color: Colors.red),
                        SizedBox(height: 16),
                        Text(
                          'Error: ${state.message}',
                          style: TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<DetailBookBloc>().add(
                              FetchBookDetail(bookId),
                            );
                          },
                          child: Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is DetailBookLoaded) {
                  final book = state.book;

                  return SingleChildScrollView(
                    child: Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.92,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),

                            Row(
                              children: [
                                InkWell(
                                  onTap: () => Navigator.pop(context),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppTheme.googleBlue,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppTheme.googleBlue.withValues(
                                            alpha: 0.24,
                                          ),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      "Book Detail",
                                      style: AppTheme.headingStyle,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 40),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // Book Card
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.24),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: Text(
                                      book.title,
                                      style: AppTheme.titleDetail,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    width: 160,
                                    height: 200,
                                    padding: EdgeInsets.all(12),
                                    child:
                                        book.coverImage != null &&
                                            book.coverImage!.isNotEmpty
                                        ? Image.network(
                                            book.coverImage!,
                                            fit: BoxFit.contain,
                                            errorBuilder: (_, _, _) =>
                                                _buildNoCover(),
                                          )
                                        : _buildNoCover(),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _InfoBadge(
                                        icon: Icons.person,
                                        color: AppTheme.primaryPurple,
                                        text: book.author,
                                      ),
                                      _InfoBadge(
                                        icon: Icons.category,
                                        color: AppTheme.googleBlue,
                                        text: book.category,
                                      ),
                                      _InfoBadge(
                                        icon: Icons.pages,
                                        color: AppTheme.iconColor,
                                        text: '${book.totalPages} pages',
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              ),
                            ),

                            const SizedBox(height: 28),
                            Text(
                              "Preview Book Informations",
                              style: AppTheme.headingStyle,
                            ),
                            const SizedBox(height: 8),

                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.24),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () =>
                                              setState(() => selectedTab = 0),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                            decoration: BoxDecoration(
                                              color: selectedTab == 0
                                                  ? AppTheme.primaryPurple
                                                  : Colors.grey.shade200,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                    topLeft: Radius.circular(
                                                      20,
                                                    ),
                                                  ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "Summary",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: selectedTab == 0
                                                      ? Colors.white
                                                      : Colors.grey.shade600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () =>
                                              setState(() => selectedTab = 1),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                            decoration: BoxDecoration(
                                              color: selectedTab == 1
                                                  ? AppTheme.primaryPurple
                                                  : Colors.grey.shade200,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                    topRight: Radius.circular(
                                                      20,
                                                    ),
                                                  ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "Details",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: selectedTab == 1
                                                      ? Colors.white
                                                      : Colors.grey.shade600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: selectedTab == 0
                                          ? _buildSummaryContent(book)
                                          : _buildDetailsContent(book),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return SizedBox.shrink();
              },
            ),
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 12,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Rent books for", style: AppTheme.subtitleDetail),
                    Row(
                      children: [
                        _QtyButton(
                          icon: Icons.remove,
                          onTap: qty > 1 ? () => setState(() => qty--) : null,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text("$qty", style: AppTheme.titleDetail),
                        ),
                        _QtyButton(
                          icon: Icons.add,
                          onTap: qty < 7 ? () => setState(() => qty++) : null,
                        ),
                        Text(
                          qty == 1 ? " Day" : " Days",
                          style: AppTheme.subtitleDetail,
                        ),
                      ],
                    ),
                    Text(
                      'Rp. ${NumberFormat('#,###').format((qty * pricePerDay))}',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryPurple,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                BlocBuilder<RentBookBloc, RentBookState>(
                  builder: (context, state) {
                    final isLoading = state is RentBookLoading;

                    return GestureDetector(
                      onTap: isLoading
                          ? null
                          : () {
                              final userId =
                                  FirebaseAuth.instance.currentUser!.uid;

                              context.read<RentBookBloc>().add(
                                SubmitRentBook(
                                  bookId: bookId,
                                  userId: userId,
                                  duration: qty,
                                  price: qty * pricePerDay,
                                ),
                              );
                            },
                      child: Container(
                        height: 56,
                        decoration: AppTheme.buttonDecorationPrimary,
                        child: Center(
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "Rent Now",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoCover() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.image_not_supported_outlined, size: 64, color: Colors.grey),
        SizedBox(height: 8),
        Text('No Cover', style: TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildSummaryContent(book) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Summary", style: AppTheme.titleDetail),
        const SizedBox(height: 8),
        Text(
          book.summary ??
              "No description available for this book at the moment.",
          style: AppTheme.cardBody,
        ),
      ],
    );
  }

  Widget _buildDetailsContent(book) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildDetailRow("Author", book.author ?? "Unknown"),
        const SizedBox(height: 12),
        _buildDetailRow("Category", book.category ?? "N/A"),
        const SizedBox(height: 12),
        _buildDetailRow("Published Date", book.publishedDate?.toString() ?? "N/A"),
        const SizedBox(height: 12),
        _buildDetailRow("Book ID", book.id ?? "N/A"),
        const SizedBox(height: 12),
        if (book.publisher != null) ...[
          _buildDetailRow("Publisher", book.publisher!),
          const SizedBox(height: 12),
        ],
        if (book.isbn != null) ...[
          _buildDetailRow("ISBN", book.isbn!),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTheme.titleDetail),
        const SizedBox(height: 4),
        Text(value, style: AppTheme.cardBody),
      ],
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _QtyButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 18,
          color: onTap == null ? Colors.grey : Colors.black,
        ),
      ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;

  const _InfoBadge({
    required this.icon,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36, // bikin gepeng
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: AppTheme.cardBody,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

