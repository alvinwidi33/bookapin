import 'package:bloc/bloc.dart';
import 'package:bookapin/data/models/users.dart';
import 'package:bookapin/data/repositories/user_repository.dart';
import 'package:bookapin/features/authentication/auth_helper.dart';
import 'package:bookapin/features/profile/bloc/profile_event.dart';
import 'package:bookapin/features/profile/bloc/profile_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthHelper authHelper;

  ProfileBloc(this.authHelper) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<LogoutProfile>(_onLogoutProfile);
    on<RefreshProfile>(_onRefreshProfile);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    try {
      final docSnapshot = await _firestore
          .collection('users')
          .doc(event.userId)
          .get();

      if (!docSnapshot.exists) {
        emit(ProfileError(message: 'User not found'));
        return;
      }

      final user = Users.fromFirestore(docSnapshot);
      emit(ProfileLoaded(user: user));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> _onRefreshProfile(
    RefreshProfile event,
    Emitter<ProfileState> emit,
  ) async {
    // Tidak emit loading agar tidak mengganggu UI
    try {
      final docSnapshot = await _firestore
          .collection('users')
          .doc(event.userId)
          .get();

      if (!docSnapshot.exists) {
        emit(ProfileError(message: 'User not found'));
        return;
      }

      final user = Users.fromFirestore(docSnapshot);
      emit(ProfileLoaded(user: user));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> _onLogoutProfile(
    LogoutProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLogoutLoading());

    try {
      await authHelper.signOut();
      emit(ProfileLogoutSuccess());
    } catch (e) {
      emit(ProfileError(message: 'Logout failed: ${e.toString()}'));
    }
  }
}