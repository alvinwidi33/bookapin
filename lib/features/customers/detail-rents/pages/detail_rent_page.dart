import 'package:bookapin/components/theme_data.dart';
import 'package:bookapin/data/models/rents.dart';
import 'package:bookapin/data/repositories/rent_repository.dart';
import 'package:bookapin/features/customers/detail-rents/bloc/detail_rent_bloc.dart';
import 'package:bookapin/features/customers/detail-rents/bloc/detail_rent_event.dart';
import 'package:bookapin/features/customers/detail-rents/bloc/detail_rent_state.dart';
import 'package:bookapin/features/customers/detail-rents/bloc/return_book_bloc.dart';
import 'package:bookapin/features/customers/detail-rents/bloc/return_book_event.dart';
import 'package:bookapin/features/customers/detail-rents/bloc/return_book_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DetailRent extends StatefulWidget {
  const DetailRent({super.key});

  @override
  State<DetailRent> createState() => _DetailRentState();
}

class _DetailRentState extends State<DetailRent> {

  void showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void hideLoading(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args == null) {
      return const Scaffold(
        body: Center(child: Text("Rent ID not found")),
      );
    }

    final String rentId = args.toString();
    
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DetailRentBloc(
            context.read<RentRepository>(),
          )..add(FetchRentDetail(rentId)),
        ),
        BlocProvider(
          create: (context) => ReturnBookBloc(
            context.read<RentRepository>(),
          ),
        )
      ],
      child: BlocListener<ReturnBookBloc, ReturnBookState>(
        listener: (context, state) {
          if (state is ReturnBookLoading) {
            showLoading(context);
          }

          if (state is ReturnBookSuccess) {
            hideLoading(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Return book successful 📚")),
            );
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/history',
              (route) => route.isFirst,
            );
          }

          if (state is ReturnBookFailure) {
            hideLoading(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: BlocBuilder<DetailRentBloc, DetailRentState>(
              builder: (context, state) {
                if (state is DetailRentLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is DetailRentError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          'Error: ${state.message}',
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context
                                .read<DetailRentBloc>()
                                .add(FetchRentDetail(rentId));
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                if (state is DetailRentLoaded) {
                  final rent = state.rent;
                  return _buildBody(rent: rent);
                }
                return const SizedBox.shrink();
              }
            )
          ),
          // Bottom bar sekarang bisa akses state
          bottomNavigationBar: BlocBuilder<DetailRentBloc, DetailRentState>(
            builder: (context, state) {
              // Hanya tampilkan bottom bar ketika data sudah loaded
              if (state is! DetailRentLoaded) {
                return const SizedBox.shrink();
              }

              final rent = state.rent;
              final shouldReturnBefore = rent.borrowedAt.add(Duration(days: rent.duration));
              
              final now = DateTime.now();
              final isLate = now.isAfter(shouldReturnBefore);
              final daysLate = isLate ? now.difference(shouldReturnBefore).inDays : 0;
              final fine = daysLate * 5000; // Rp 5000 per hari keterlambatan

              return Container(
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
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Should return before: ",
                              style: AppTheme.subtitleDetail,
                            ),
                            Text(
                              DateFormat('MMM dd yyyy').format(shouldReturnBefore),
                              style: AppTheme.titleDetail,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Your fine: ",
                              style: AppTheme.subtitleDetail,
                            ),
                            Text(
                              "Rp. ${NumberFormat('#,###').format(fine)}",
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: fine > 0 ? Colors.red : AppTheme.primaryPurple
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    GestureDetector(
                      onTap: rent.isReturn == true
                          ? null
                          : () {
                              context.read<ReturnBookBloc>().add(
                                SubmitReturnBook(rentId: rent.id, fine: fine),
                              );
                            },
                      child: Container(
                        height: 56,
                        decoration: rent.isReturn == true
                            ? AppTheme.buttonDecorationDisabled
                            : AppTheme.buttonDecorationPrimary,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            const SizedBox(width: 32),
                            Expanded(
                              child: Center(
                                child: Text(
                                  "Book Returned",
                                  style: TextStyle(
                                    color: rent.isReturn == true ? Colors.grey.shade600 : Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_right,
                              size: 32,
                              color: rent.isReturn == true ? Colors.grey.shade600 : Colors.white,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        )
      )
    );
  }
}

class _buildBody extends StatelessWidget {
  const _buildBody({
    required this.rent,
  });

  final Rents rent;

  @override
  Widget build(BuildContext context) {
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
                            color: AppTheme.googleBlue.withValues(alpha: 0.24),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
        
                  Expanded(
                    child: Center(
                      child: Text(
                        "Rent Detail",
                        style: AppTheme.headingStyle,
                      ),
                    ),
                  ),
        
                  const SizedBox(width: 40),
                ],
              ),
        
              const SizedBox(height: 12),
        
              Container(
                height: 340,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.24),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  ]
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      rent.bookDetails?.title ?? "Unknown Book",  
                      style: AppTheme.titleDetail,
                    ),
                    Container(
                      width: 160,
                      height: 240,
                      padding: const EdgeInsets.all(12),
                      child: Image.network(
                        rent.bookDetails?.coverImage ?? '',
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _InfoBadge(
                          color: AppTheme.primaryPurple,
                          icon: Icons.person,
                          text: rent.bookDetails?.author ?? "Unknown Author",
                        ),
                        _InfoBadge(
                          color: AppTheme.googleBlue,
                          icon: Icons.category,
                          text: rent.bookDetails?.category ?? "Unknown",
                        ),
                        _InfoBadge(
                          color: AppTheme.iconColor,
                          icon: Icons.pages,
                          text: "${rent.bookDetails?.totalPages ?? 0} pages",
                        ),
                      ],
                    ),
                  ],
                )
              ),
              const SizedBox(height: 28),
              Text("Preview Rent Informations", style: AppTheme.headingStyle),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    _infoRow("Borrowed At", DateFormat('MMM dd yyyy').format(rent.borrowedAt)),
                    const Divider(height: 24),
                    _infoRow("Duration", rent.duration > 1 ? '${rent.duration} days' : '${rent.duration} day'),
                    const Divider(height: 24),
                    _infoRow("Price", 'Rp. ${NumberFormat('#,###').format(rent.price)}', isPrice: true),
                  ],
                ),
              ),
              const SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }
}

Widget _infoRow(String label, String value, {bool isPrice = false}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: AppTheme.subtitleDetail),
      Text(
        value,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isPrice ? AppTheme.primaryPurple : Colors.black,
        ),
      ),
    ],
  );
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
      height: 36,
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