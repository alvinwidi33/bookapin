import 'package:bookapin/features/admin/dashboard/pages/dashboard_page.dart';
import 'package:bookapin/features/admin/rents-user/pages/rent_users.dart';
import 'package:bookapin/features/admin/users/pages/users_page.dart';
import 'package:bookapin/features/authentication/admin_guard.dart';
import 'package:bookapin/features/authentication/signin/pages/signin_page.dart';
import 'package:bookapin/features/authentication/signup/pages/signup_page.dart';
import 'package:bookapin/features/customers/detail-rents/pages/detail_rent_page.dart';
import 'package:bookapin/features/customers/detail/pages/detail_book_page.dart';
import 'package:bookapin/features/customers/history/pages/history_page.dart';
import 'package:bookapin/features/customers/home/pages/home_page.dart';
import 'package:bookapin/features/profile/pages/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppRoutes {
    final FirebaseAuth auth;

  AppRoutes(this.auth);

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final user = auth.currentUser;

    const publicRoutes = [
      '/signin',
      '/signup',
    ];

    if (user == null && !publicRoutes.contains(settings.name)) {
      return MaterialPageRoute(
        builder: (_) => const SigninPage(),
      );
    }

    switch (settings.name) {
      case '/signin':
        return MaterialPageRoute(
          builder: (_) => const SigninPage(),
        );

      case '/signup':
        return MaterialPageRoute(
          builder: (_) => const SignupPage(),
        );

      case '/home':
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
        );

      case '/detail-book':
        return MaterialPageRoute(
          builder: (_) => const DetailBook(),
          settings: settings,
        );

      case '/history':
        return MaterialPageRoute(
          builder: (_) => const HistoryPage(),
        );

      case '/detail-rent':
        return MaterialPageRoute(
          builder: (_) => const DetailRent(),
          settings: settings,
        );

      case '/profile':
        return MaterialPageRoute(
          builder: (_) => const ProfilePage(),
        );

      case '/dashboard':
        return MaterialPageRoute(
          builder: (_) => AdminGuard(
            auth: auth,
            child: DashboardPage(),
          ),
        );

      case '/users':
        return MaterialPageRoute(
          builder: (_) => AdminGuard(
            auth: auth,
            child: UsersPage(),
          ),
        );

      case '/rents-user':
        return MaterialPageRoute(
          builder: (_) => AdminGuard(
            auth: auth,
            child: RentUsersPage(),
          ),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Page not found'),
            ),
          ),
        );
    }
  }
}
