part of 'signup_bloc.dart';

@immutable
abstract class SignupEvent {}

class OnTextChangedEvent extends SignupEvent {}

class TerminosCondicionesChangedEvent extends SignupEvent {
  TerminosCondicionesChangedEvent(bool bool);
}

class SignUpTappedEvent extends SignupEvent {}

class SignInTappedEvent extends SignupEvent {}
