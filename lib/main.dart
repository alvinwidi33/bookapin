import 'package:bookapin/components/theme_data.dart';
import 'package:bookapin/data/network/dio_client_api.dart';
import 'package:bookapin/data/repositories/book_repository.dart';
import 'package:bookapin/data/repositories/rent_repository.dart';
import 'package:bookapin/data/repositories/user_repository.dart';
import 'package:bookapin/features/admin/dashboard/bloc/dashboard_bloc.dart';
import 'package:bookapin/features/admin/dashboard/pages/dashboard_page.dart';
import 'package:bookapin/features/admin/rents-user/bloc/rent_users_bloc.dart';
import 'package:bookapin/features/admin/rents-user/pages/rent_users.dart';
import 'package:bookapin/features/admin/users/bloc/users_bloc.dart';
import 'package:bookapin/features/admin/users/pages/users_page.dart';
import 'package:bookapin/features/authentication/admin_guard.dart';
import 'package:bookapin/features/authentication/signin/bloc/signin_bloc.dart';
import 'package:bookapin/features/authentication/signin/pages/signin_page.dart';
import 'package:bookapin/features/authentication/signup/bloc/signup_bloc.dart';
import 'package:bookapin/features/authentication/signup/pages/signup_page.dart';
import 'package:bookapin/features/customers/detail-rents/bloc/return_book_bloc.dart';
import 'package:bookapin/features/customers/detail-rents/pages/detail_rent_page.dart';
import 'package:bookapin/features/customers/detail/pages/detail_book_page.dart';
import 'package:bookapin/features/customers/history/bloc/rent_history_bloc.dart';
import 'package:bookapin/features/customers/history/pages/history_page.dart';
import 'package:bookapin/features/customers/home/bloc/home_bloc.dart';
import 'package:bookapin/features/customers/home/bloc/home_event.dart';
import 'package:bookapin/features/customers/home/pages/home_page.dart';
import 'package:bookapin/features/profile/bloc/profile_bloc.dart';
import 'package:bookapin/features/profile/pages/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bookapin/features/authentication/auth_helper.dart';
import 'package:bookapin/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp()); 
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
          RepositoryProvider<BookRepository>(
            create: (_) => BookRepository(
              DioApiClient().dio,
            ),
          ),
          RepositoryProvider<RentRepository>(
            create: (context) => RentRepository(
              bookApi: context.read<BookRepository>(),
            ),
          ),
          RepositoryProvider<UserRepository>(
            create: (context) => UserRepository(
            ),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => SignInBloc(AuthHelper()),
            ),
            BlocProvider(
              create: (_) => SignUpBloc(AuthHelper()),
            ),
            BlocProvider(
              create: (context) => HomeBloc(
                context.read<BookRepository>(),
              )..add(FetchAllBooks(isRefresh: true)),
            ),
            BlocProvider(
              create: (context) => RentHistoryBloc(
                context.read<RentRepository>(),
              )
            ),
            BlocProvider(
              create: (context) => ReturnBookBloc(
                context.read<RentRepository>(),
              ),
            ),
            BlocProvider(
              create: (context) => DashboardBloc(
                context.read<BookRepository>(),
              ),
            ),
            BlocProvider(
              create: (context) => UsersBloc(
                context.read<UserRepository>(),
              ),
            ),
            BlocProvider(
              create: (context) => RentUsersBloc(
                context.read<RentRepository>(),
              ),
            ),
            BlocProvider(
              create: (_) => ProfileBloc(
                AuthHelper(),
              ),
            ),
          ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          initialRoute: '/signin',
          onGenerateRoute: (settings) {
            final user = FirebaseAuth.instance.currentUser;
            const publicRoutes = ['/signin', '/signup'];
            if (user == null && !publicRoutes.contains(settings.name)) {
              return MaterialPageRoute(
                builder: (_) => const SigninPage(),
              );
            }

            switch (settings.name) {
              case '/signin':
                return MaterialPageRoute(builder: (_) => const SigninPage());
              case '/signup':
                return MaterialPageRoute(builder: (_) => const SignupPage());
              case '/home':
                return MaterialPageRoute(builder: (_) => const HomePage());
              case '/detail-book':
                return MaterialPageRoute(builder: (_) => const DetailBook(), settings: settings,);
              case '/history':
                return MaterialPageRoute(builder: (_) => const HistoryPage());
              case '/detail-rent':
                return MaterialPageRoute(builder: (_) => const DetailRent(), settings: settings,);
              case '/dashboard':
                return MaterialPageRoute(
                  builder: (_) => const AdminGuard(child: DashboardPage()),
                );
              case '/users':
                return MaterialPageRoute(
                  builder: (_) => const AdminGuard(child: UsersPage()),
                );
              case '/rents-user':
                return MaterialPageRoute(
                  builder: (_) => const AdminGuard(child: RentUsersPage()), settings: settings
                );
              case '/profile':
                return MaterialPageRoute(builder: (_) => const ProfilePage());
              default:
                return null;
            }
          },
        ),
      ),
    );
  }
}
