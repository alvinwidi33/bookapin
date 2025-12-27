import 'package:bookapin/components/navbar.dart';
import 'package:bookapin/components/theme_data.dart';
import 'package:bookapin/data/models/rents.dart';
import 'package:bookapin/features/customers/history/bloc/rent_history_bloc.dart';
import 'package:bookapin/features/customers/history/bloc/rent_history_event.dart';
import 'package:bookapin/features/customers/history/bloc/rent_history_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    final userId = FirebaseAuth.instance.currentUser!.uid;
    context.read<RentHistoryBloc>().add(FetchRentHistory(userId));
  }

  @override
  Widget build(BuildContext context) {
    return const HistoryUI(currentIndex: 1);
  }
}


class HistoryUI extends StatelessWidget {
  const HistoryUI({
    super.key,
    required int currentIndex,
  }) : _currentIndex = currentIndex;

  final int _currentIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<RentHistoryBloc, RentHistoryState>(
          builder: (context, state) {
            if (state is RentHistoryLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is RentHistoryError) {
              return Center(child: Text(state.message));
            }

            if (state is RentHistoryLoaded) {
              if (state.rents.isEmpty) {
                return Center(
                  child: Text("No rent history yet 📭", style:AppTheme.subtitleDetail),
                );
              }

              return ListView(
                padding: const EdgeInsets.symmetric(vertical: 12),
                children: [
                  const SizedBox(height: 12),
                  Text(
                    "My Rents",
                    style: AppTheme.headingStyle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  ...state.rents.map(
                    (rent) => RentCard(rent: rent),
                  ),
                ],
              );
            }

            return const SizedBox();
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        child:CurvedBottomNavBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            if (index == _currentIndex) return;
            if (index == 0) {
              Navigator.pushReplacementNamed(context, '/home');
            } else if (index == 1) {
              Navigator.pushReplacementNamed(context, '/history');
            } else if (index == 2) {
              Navigator.pushReplacementNamed(context, '/profile');
            }
          },
        ),
      )
    );
  }
}

class RentCard extends StatelessWidget {
  final Rents rent;

  const RentCard({super.key, required this.rent});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: InkWell(
        onTap: () => Navigator.pushNamed(
          context,
          '/detail-rent',
          arguments: rent.id,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.92,
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.24),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    rent.bookDetails?.coverImage ?? '',
                    width: 54,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      width: 54,
                      height: 80,
                      color: Colors.grey[300],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    Text(
                      rent.bookDetails?.title ?? "Unknown Book",                      
                      style: AppTheme.cardTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      rent.bookDetails?.category ?? "-",
                      style: AppTheme.cardBody,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.access_time_filled, size: 16, color:AppTheme.googleBlue),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('MMM dd yyyy hh:mm:ss')
                              .format(rent.borrowedAt),
                          style: AppTheme.cardBody,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.monetization_on, size: 16, color:AppTheme.primaryPurple),
                        const SizedBox(width: 4),
                        Text(
                          'Rp. ${NumberFormat('#,###').format(rent.price)}',
                          style: AppTheme.cardBody.copyWith(color: AppTheme.primaryPurple, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12, left:8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: rent.isReturn
                        ? Colors.lightGreenAccent
                        : AppTheme.iconColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    rent.isReturn ? "Returned" : "Not Return",
                    style: AppTheme.cardBody,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
