import 'package:bookapin/components/theme_data.dart';
import 'package:bookapin/data/models/rents.dart';
import 'package:bookapin/features/admin/rents-user/bloc/rent_users_bloc.dart';
import 'package:bookapin/features/admin/rents-user/bloc/rent_users_event.dart';
import 'package:bookapin/features/admin/rents-user/bloc/rent_users_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class RentUsersPage extends StatefulWidget {
  const RentUsersPage({super.key});

  @override
  State<RentUsersPage> createState() => _RentUsersPageState();
}

class _RentUsersPageState extends State<RentUsersPage> {
  bool _loaded = false;
  late String userId;
  late String username;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_loaded) return;

    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    userId = args['userId'] as String;
    username = args['username'] as String;

    context.read<RentUsersBloc>().add(FetchRentUsers(userId));

    _loaded = true;
  }

  @override
  Widget build(BuildContext context) {
    return RentUsersUI(
      currentIndex: 1,
      user: username,
    );
  }
}


class RentUsersUI extends StatelessWidget {
  final int currentIndex;
  final String user;

  const RentUsersUI({
    super.key,
    required this.currentIndex,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<RentUsersBloc, RentUsersState>(
          builder: (context, state) {
            if (state is RentUsersLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is RentUsersError) {
              return Center(child: Text(state.message));
            }

            if (state is RentUsersLoaded) {
              return Stack(
                children: [
                  state.rents.isEmpty
                      ? Center(
                          child: Text(
                            "No rent history yet 📭",
                            style: AppTheme.subtitleDetail,
                          ),
                        )
                      : ListView(
                          padding: const EdgeInsets.only(top: 20),
                          children: [
                            Text(
                              "$user Rents",
                              style: AppTheme.headingStyle,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            ...state.rents.map(
                              (rent) => RentCard(rent: rent),
                            ),
                          ],
                        ),
                  Positioned(
                    top: 12,
                    left: 16,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppTheme.googleBlue,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.googleBlue.withValues(alpha: 0.24),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
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
        child: Container(
          width: MediaQuery.of(context).size.width * 0.92,
          margin: const EdgeInsets.only(bottom: 16),
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
