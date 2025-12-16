import 'package:bookapin/features/authentication/signin/bloc/signin_bloc.dart';
import 'package:bookapin/features/authentication/signin/pages/signin_page.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SignInBloc(AuthHelper()),
        ),
      ],
      child: MaterialApp(
        title: 'BookApin',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lime),
        ),
        home: SigninPage(),
      ),
    );
  }
}
