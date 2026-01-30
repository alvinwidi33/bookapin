import 'package:bloc_test/bloc_test.dart';
import 'package:bookapin/features/authentication/signin/bloc/signin_bloc.dart';
import 'package:bookapin/features/authentication/signin/bloc/signin_event.dart';
import 'package:bookapin/features/authentication/signin/bloc/signin_state.dart';
import 'package:flutter_test/flutter_test.dart';

class MockSignInBloc extends MockBloc<SignInEvent, SignInState> implements SignInBloc {}
class FakeSignInEvent extends Fake implements SignInEvent {}
