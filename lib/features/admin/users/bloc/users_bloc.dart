import 'package:bookapin/data/repositories/user_repository.dart';
import 'package:bookapin/features/admin/users/bloc/users_event.dart';
import 'package:bookapin/features/admin/users/bloc/users_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final UserRepository repository;

  UsersBloc(this.repository) : super(UsersInitial()) {
    on<LoadUsers>(_onLoadUsers);
    on<ToggleUserActive>(onToggleUserActive);
  }

  Future<void> _onLoadUsers(
    LoadUsers event,
    Emitter<UsersState> emit,
  ) async {
    emit(UsersLoading());

    try {
      final users = await repository.getAllCustomer();
      emit(UsersLoaded(users));
    } catch (e) {
      emit(const UsersError('Gagal memuat data user'));
    }
  }
    Future<void> onToggleUserActive(
      ToggleUserActive event,
      Emitter<UsersState> emit,
    ) async {
      try {
        await repository.updateUserActive(
          event.userId,
          event.isActive,
        );

        final users = await repository.getAllCustomer();
        emit(UsersLoaded(users));
      } catch (e) {
        emit(const UsersError('Gagal update status user'));
      }
    }
}
