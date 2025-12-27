import 'package:bookapin/components/navbar.dart';
import 'package:bookapin/components/navbar_admin.dart';
import 'package:bookapin/components/theme_data.dart';
import 'package:bookapin/data/models/users.dart';
import 'package:bookapin/features/admin/users/bloc/users_bloc.dart';
import 'package:bookapin/features/admin/users/bloc/users_event.dart';
import 'package:bookapin/features/admin/users/bloc/users_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          UsersBloc(context.read())..add(LoadUsers()),
      child: const HistoryUI(currentIndex: 1),
    );
  }
}


class HistoryUI extends StatelessWidget {
  const HistoryUI({super.key, required int currentIndex})
    : _currentIndex = currentIndex;

  final int _currentIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<UsersBloc, UsersState>(
          builder: (context, state) {
            if (state is UsersLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is UsersError) {
              return Center(child: Text(state.message));
            }

            if (state is UsersLoaded) {
              if (state.users.isEmpty) {
                return Center(
                  child: Text(
                    "No rent history yet 📭",
                    style: AppTheme.subtitleDetail,
                  ),
                );
              }

              return ListView(
                padding: const EdgeInsets.symmetric(vertical: 12),
                children: [
                  const SizedBox(height: 12),
                  Text(
                    "Customers",
                    style: AppTheme.headingStyle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  ...state.users.asMap().entries.map(
                    (entry) => UserCard(users: entry.value, index: entry.key),
                  ),
                ],
              );
            }

            return const SizedBox();
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: CurvedBottomNavBarAdmin(
          currentIndex: _currentIndex,
          onTap: (index) {
            if (index == _currentIndex) return;
            if (index == 0) {
              Navigator.pushReplacementNamed(context, '/dashboard');
            } else if (index == 1) {
              Navigator.pushReplacementNamed(context, '/users');
            } else if (index == 2) {
              Navigator.pushReplacementNamed(context, '/profile');
            }
          },
        ),
      )
    );
  }
}

class UserCard extends StatelessWidget {
  final Users users;
  final int index;

  const UserCard({super.key, required this.users, required this.index});

  @override
  Widget build(BuildContext context) {
    final List<List<Color>> avatarGradients = [
      [AppTheme.gradientStart, AppTheme.gradientEnd], // 0
      [AppTheme.primaryPurple, AppTheme.googleBlue], // 1
      [AppTheme.iconColor, AppTheme.gradientEnd], // 2
      [AppTheme.googleBlue, AppTheme.gradientStart], // 3
      [AppTheme.primaryPurple, AppTheme.iconColor], // 4
    ];

    List<Color> getGradientByIndex(int index) {
      return avatarGradients[index % avatarGradients.length];
    }

    return Align(
      alignment: Alignment.center,
      child: InkWell(
        onTap: () => Navigator.pushNamed(
          context,
          '/rents-user',
          arguments: {'userId': users.id, 'username': users.username},
        ),
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
                padding: const EdgeInsets.all(10.8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 48,
                    height: 72,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: getGradientByIndex(index),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      (users.username).substring(0, 2).toUpperCase(),
                      style: AppTheme.cardTitle.copyWith(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(users.username, style: AppTheme.cardTitle),
                    const SizedBox(height: 4),
                    Text(users.email, style: AppTheme.cardBody),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_filled,
                          size: 16,
                          color: AppTheme.googleBlue,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat(
                            'MMM dd yyyy hh:mm:ss',
                          ).format(users.createdAt),
                          style: AppTheme.cardBody,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text("Confirmation", style:AppTheme.headingStyle),
                        content: Text(
                          users.isActive
                              ? "Inactive this user?"
                              : "Activate this user?", style: AppTheme.subtitleDetail
                        ),
                        actions: [
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(44), 
                                    side: BorderSide(color: AppTheme.iconColor),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () => Navigator.pop(context, false),
                                  child: Text(
                                    "Cancel",
                                    style: AppTheme.cardBody.copyWith(
                                      color: AppTheme.iconColor,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(44), 
                                    padding: EdgeInsets.zero,              
                                    backgroundColor: Colors.lightGreenAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () => Navigator.pop(context, true),
                                  child: Text(
                                    "Yes",
                                    style: AppTheme.cardBody.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      context.read<UsersBloc>().add(
                            ToggleUserActive(
                              userId: users.id!,
                              isActive: !users.isActive, 
                            ),
                          );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: users.isActive
                          ? Colors.lightGreenAccent
                          : AppTheme.iconColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      users.isActive ? "Active" : "Not Active",
                      style: AppTheme.cardBody.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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
