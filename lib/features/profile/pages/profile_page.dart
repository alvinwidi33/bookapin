import 'package:bookapin/components/navbar.dart';
import 'package:bookapin/components/navbar_admin.dart';
import 'package:bookapin/components/theme_data.dart';
import 'package:bookapin/features/profile/bloc/profile_bloc.dart';
import 'package:bookapin/features/profile/bloc/profile_event.dart';
import 'package:bookapin/features/profile/bloc/profile_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final int _currentIndex = 2;

  @override
  void initState() {
    super.initState();
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      context.read<ProfileBloc>().add(LoadProfile(userId: userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width * 0.92;

    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLogoutSuccess) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
            (route) => false,
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SizedBox(
              width: screenWidth,
              child: BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state is ProfileError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline,
                              size: 64, color: Colors.red),
                          const SizedBox(height: 16),
                          Text(
                            'Error: ${state.message}',
                            style: TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              final userId =
                                  FirebaseAuth.instance.currentUser?.uid;
                              if (userId != null) {
                                context.read<ProfileBloc>().add(
                                      LoadProfile(userId: userId),
                                    );
                              }
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is ProfileLoaded) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        final userId = FirebaseAuth.instance.currentUser?.uid;
                        if (userId != null) {
                          context.read<ProfileBloc>().add(
                                RefreshProfile(userId: userId),
                              );
                        }
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            const SizedBox(height: 24),
                            _buildProfileHeader(state),
                            const SizedBox(height: 32),
                            _buildMenuSection(
                              title: "Account",
                              items: [
                                _MenuItem(
                                  icon: Icons.person_outline,
                                  title: "Edit Profile",
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, '/edit-profile');
                                  },
                                ),
                                _MenuItem(
                                  icon: Icons.lock_outline,
                                  title: "Change Password",
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, '/change-password');
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildMenuSection(
                              title: "Rental",
                              items: [
                                _MenuItem(
                                  icon: Icons.history,
                                  title: "Rental History",
                                  onTap: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/history');
                                  },
                                ),
                                _MenuItem(
                                  icon: Icons.favorite_outline,
                                  title: "Wishlist",
                                  onTap: () {
                                    Navigator.pushNamed(context, '/wishlist');
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildMenuSection(
                              title: "Support",
                              items: [
                                _MenuItem(
                                  icon: Icons.help_outline,
                                  title: "Help Center",
                                  onTap: () {},
                                ),
                                _MenuItem(
                                  icon: Icons.info_outline,
                                  title: "About",
                                  onTap: () {
                                    _showAboutDialog();
                                  },
                                ),
                                _MenuItem(
                                  icon: Icons.privacy_tip,
                                  title: "Privacy Policy",
                                  onTap: () {},
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            _buildLogoutButton(state),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    );
                  }

                  // ProfileLogoutLoading
                  if (state is ProfileLogoutLoading) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Logging out...'),
                        ],
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child:BlocBuilder<ProfileBloc, ProfileState>(
  builder: (context, state) {
    if (state is! ProfileLoaded) {
      return const SizedBox.shrink();
    }

    return state.user.role.toLowerCase() == 'customer'
        ? CurvedBottomNavBar(
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
          )
        : CurvedBottomNavBarAdmin(
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
          );
          },
        ),

      ),
      )
    );
  }

  Widget _buildProfileHeader(ProfileLoaded state) {
    final user = state.user;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppTheme.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryPurple.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: _buildInitials(user.username),
          ),
          const SizedBox(height: 16),
          Text(
            user.username,
            style: AppTheme.headingStyle.copyWith(fontSize: 24),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.email_outlined, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  user.email,
                  style: AppTheme.bodyStyle.copyWith(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: user.role.toLowerCase() == 'admin'
                  ? AppTheme.iconColor.withValues(alpha: 0.1)
                  : AppTheme.googleBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  user.role.toLowerCase() == 'admin'
                      ? Icons.admin_panel_settings
                      : Icons.person,
                  size: 16,
                  color: user.role.toLowerCase() == 'admin'
                      ? AppTheme.iconColor
                      : AppTheme.googleBlue,
                ),
                const SizedBox(width: 6),
                Text(
                  user.role.toUpperCase(),
                  style: AppTheme.bodyStyle.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: user.role.toLowerCase() == 'admin'
                        ? AppTheme.iconColor
                        : AppTheme.googleBlue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitials(String username) {
    final initials = username
        .split(' ')
        .map((name) => name.isNotEmpty ? name[0] : '')
        .take(2)
        .join()
        .toUpperCase();

    return Center(
      child: Text(
        initials.isNotEmpty ? initials : 'U',
        style: AppTheme.headingStyle.copyWith(
          fontSize: 36,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildMenuSection({
    required String title,
    required List<_MenuItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: AppTheme.headingStyle.copyWith(fontSize: 16),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: List.generate(
              items.length,
              (index) {
                final item = items[index];
                return Column(
                  children: [
                    InkWell(
                      onTap: item.onTap,
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryPurple
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                item.icon,
                                color: AppTheme.primaryPurple,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                item.title,
                                style: AppTheme.bodyStyle.copyWith(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            item.trailing ??
                                Icon(
                                  Icons.chevron_right,
                                  color: Colors.grey.shade400,
                                ),
                          ],
                        ),
                      ),
                    ),
                    if (index < items.length - 1)
                      Padding(
                        padding: const EdgeInsets.only(left: 72),
                        child: Divider(
                          height: 1,
                          color: Colors.grey.shade200,
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(ProfileLoaded state) {
    return InkWell(
      onTap: () {
        _showLogoutDialog();
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.red.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: Colors.red.shade600),
            const SizedBox(width: 12),
            Text(
              'Logout',
              style: AppTheme.bodyStyle.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Logout',
          style: AppTheme.headingStyle,
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: AppTheme.bodyStyle.copyWith(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTheme.bodyStyle.copyWith(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/signin');
              context.read<ProfileBloc>().add(LogoutProfile());
            },
            child: Text(
              'Logout',
              style: AppTheme.bodyStyle.copyWith(
                color: Colors.red.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.book, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            Text(
              'BookApin',
              style: AppTheme.headingStyle,
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Version 1.0.0',
              style: AppTheme.bodyStyle.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryPurple,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Your favorite book rental application. Discover, rent, and enjoy thousands of books at your fingertips.',
              style: AppTheme.bodyStyle.copyWith(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Text(
              '© 2024 BookaPin. All rights reserved.',
              style: AppTheme.bodyStyle.copyWith(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: AppTheme.linkStyle,
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Widget? trailing;

  _MenuItem({
    required this.icon,
    required this.title,
    this.onTap,
    this.trailing,
  });
}