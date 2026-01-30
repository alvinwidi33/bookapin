import 'package:bookapin/features/authentication/signin/bloc/signin_bloc.dart';
import 'package:bookapin/features/authentication/auth_helper.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bookapin/features/authentication/signin/pages/signin_page.dart';

void main() {
  testWidgets(
    'Jika belum login maka menampilkan Sign In Page',
    (tester) async {
      final mockAuth = MockFirebaseAuth(signedIn: false);

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => SignInBloc(
              AuthHelper(mockAuth),
            ),
            child: const SigninPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(const Key('email_text_field')), findsOneWidget);
    },
  );
}
