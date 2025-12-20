import 'package:bookapin/components/theme_data.dart';
import 'package:bookapin/data/network/dio_client_api.dart';
import 'package:bookapin/data/repositories/book_repository.dart';
import 'package:bookapin/features/authentication/signin/bloc/signin_bloc.dart';
import 'package:bookapin/features/authentication/signin/pages/signin_page.dart';
import 'package:bookapin/features/authentication/signup/bloc/signup_bloc.dart';
import 'package:bookapin/features/authentication/signup/pages/signup_page.dart';
import 'package:bookapin/features/customers/detail/pages/detail_book.dart';
import 'package:bookapin/features/customers/history/pages/history_page.dart';
import 'package:bookapin/features/customers/home/bloc/home_bloc.dart';
import 'package:bookapin/features/customers/home/bloc/home_event.dart';
import 'package:bookapin/features/customers/home/pages/home_page.dart';
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
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => SignInBloc(AuthHelper()),
          ),
          BlocProvider(
            create: (_) => SignUpBloc(AuthHelper()),
          ),
          // BlocProvider(
          //   create: (context) => HomeBloc(
          //     context.read<BookRepository>(), 
          //   )..add(FetchAllBooks2024()),
          // ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          initialRoute: '/signin',
          routes: {
            '/signin': (_) => const SigninPage(),
            '/signup': (_) => const SignupPage(),
            '/home': (_) => const HomePage(),
            '/detail-book': (_) => const DetailBook(),
            '/history': (_) => const HistoryPage()
          },
        ),
      ),
    );
  }
}
