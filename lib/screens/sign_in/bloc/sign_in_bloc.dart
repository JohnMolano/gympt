import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:gympt/core/service/auth_service.dart';
import 'package:gympt/core/service/validation_service.dart';
import 'package:flutter/material.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isButtonEnabled = false;

  SignInBloc() : super(SignInInitial()) {
    on<OnTextChangeEvent>((event, emit) {
      if (isButtonEnabled != _checkIfSignInButtonEnabled()) {
        isButtonEnabled = _checkIfSignInButtonEnabled();
        emit(SignInButtonEnableChangedState(isEnabled: isButtonEnabled));
      }
    });
    on<SignInTappedEvent>((event, emit) async {
      if (_checkValidatorsOfTextField()) {
        try {
          emit(LoadingState());
          await AuthService.signIn(emailController.text, passwordController.text);
          emit(NextTabBarPageState());
          if (kDebugMode) {
            print("Go to the next page");
          }
        } catch (e) {
          if (kDebugMode) {
            print('E to tstrng: $e');
          }
          emit(ErrorState(message: e.toString()));
        }
      } else {
         emit(ShowErrorState());
      }
    });
  }

  bool _checkIfSignInButtonEnabled() {
    return emailController.text.isNotEmpty && passwordController.text.isNotEmpty;
  }

  bool _checkValidatorsOfTextField() {
    return ValidationService.email(emailController.text) && ValidationService.password(passwordController.text);
  }
}
