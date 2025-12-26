import 'package:bookapin/features/authentication/signin/pages/signin_page.dart';
import 'package:bookapin/features/customers/home/pages/home_page.dart';
import 'package:bookapin/features/profile/bloc/profile_bloc.dart';
import 'package:bookapin/features/profile/bloc/profile_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminGuard extends StatelessWidget {
  final Widget child;

  const AdminGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (FirebaseAuth.instance.currentUser == null) {
          return const SigninPage();
        }

        if (state is ProfileInitial || state is ProfileLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is ProfileError) {
          return const HomePage();
        }

        if (state is ProfileLoaded) {
          final role = state.user.role.toLowerCase();
          if (role != 'admin') {
            return const HomePage(); 
          }
        }
        return child;
      },
    );
  }
}
