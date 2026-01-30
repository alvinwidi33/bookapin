import 'package:bookapin/features/authentication/signup/bloc/signup_bloc.dart';
import 'package:bookapin/features/authentication/signup/bloc/signup_event.dart';
import 'package:bookapin/features/authentication/signup/bloc/signup_state.dart';
import 'package:mocktail/mocktail.dart';

class MockSignUpBloc extends Mock implements SignUpBloc {}
class FakeSignUpEvent extends Fake implements SignUpEvent {}
class FakeSignUpState extends Fake implements SignUpState {}
