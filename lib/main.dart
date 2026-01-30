import 'package:bookapin/app.dart';
import 'package:bookapin/data/network/dio_client_api.dart';
import 'package:bookapin/data/repositories/book_repository/book_repository_impl.dart';
import 'package:bookapin/data/repositories/rent_repository/rent_repository_impl.dart';
import 'package:bookapin/data/repositories/user_repository/user_repository_impl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:bookapin/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp(
    auth: FirebaseAuth.instance,
    bookRepository: BookRepositoryImpl(DioApiClient().dio),
    rentRepository: RentRepositoryImpl(
      bookApi: BookRepositoryImpl(DioApiClient().dio),
    ),
    userRepository: UserRepositoryImpl(),
  ));
}
