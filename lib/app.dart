import 'package:bookapin/app_routes.dart';
import 'package:bookapin/components/theme_data.dart';
import 'package:bookapin/data/repositories/book_repository/book_repository.dart';
import 'package:bookapin/data/repositories/rent_repository/rent_repository.dart';
import 'package:bookapin/data/repositories/user_repository/user_repository.dart';
import 'package:bookapin/features/admin/dashboard/bloc/dashboard_bloc.dart';
import 'package:bookapin/features/admin/rents-user/bloc/rent_users_bloc.dart';
import 'package:bookapin/features/admin/users/bloc/users_bloc.dart';
import 'package:bookapin/features/authentication/auth_helper.dart';
import 'package:bookapin/features/authentication/signin/bloc/signin_bloc.dart';
import 'package:bookapin/features/authentication/signup/bloc/signup_bloc.dart';
import 'package:bookapin/features/customers/detail-rents/bloc/return_book_bloc.dart';
import 'package:bookapin/features/customers/history/bloc/rent_history_bloc.dart';
import 'package:bookapin/features/customers/home/bloc/home_bloc.dart';
import 'package:bookapin/features/customers/home/bloc/home_event.dart';
import 'package:bookapin/features/profile/bloc/profile_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  final FirebaseAuth auth;
  final BookRepository bookRepository;
  final RentRepository rentRepository;
  final UserRepository userRepository;

  const MyApp({
    super.key,
    required this.auth,
    required this.bookRepository,
    required this.rentRepository,
    required this.userRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<FirebaseAuth>.value(value: auth),
        RepositoryProvider.value(value: bookRepository),
        RepositoryProvider.value(value: rentRepository),
        RepositoryProvider.value(value: userRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => SignInBloc(AuthHelper(auth))),
          BlocProvider(create: (_) => SignUpBloc(AuthHelper(auth))),
          BlocProvider(create: (ctx) =>
            HomeBloc(ctx.read<BookRepository>())
              ..add(FetchAllBooks(isRefresh: true))
          ),
          BlocProvider(
            create: (ctx) => RentHistoryBloc(
              ctx.read<RentRepository>(), 
            ),
          ),
          BlocProvider(
            create: (ctx) => ReturnBookBloc(
              ctx.read<RentRepository>(), 
            ),
          ),
          BlocProvider(
            create: (ctx) => DashboardBloc(
              ctx.read<BookRepository>(), 
            ),
          ),
          BlocProvider(
            create: (ctx) => UsersBloc(
              ctx.read<UserRepository>(), 
            ),
          ),
          BlocProvider(
            create: (ctx) => RentUsersBloc(
              ctx.read<RentRepository>(), 
            ),
          ),
          BlocProvider(
            create: (ctx) => ProfileBloc(
              AuthHelper(auth), 
            ),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          initialRoute: '/signin',
          onGenerateRoute: AppRoutes(auth).onGenerateRoute,
        )

      ),
    );
  }
}
