import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:gympt/core/service/auth_service.dart';
import 'package:gympt/core/service/validation_service.dart';
import 'package:flutter/material.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignUpBloc extends Bloc<SignupEvent, SignUpState> {
  
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isButtonEnabled = false;

  SignUpBloc() : super(SignupInitial()) {
    // Handle OnTextChangedEvent
    on<OnTextChangedEvent>((event, emit) {
      if (isButtonEnabled != checkIfSignUpButtonEnabled()) {
        isButtonEnabled =
 checkIfSignUpButtonEnabled();
        emit(SignUpButtonEnableChangedState(isEnabled: isButtonEnabled));
      }
    });
    // Handle SignUpTappedEvent
    on<SignUpTappedEvent>((event, emit) async {
      if (checkValidatorsOfTextField()) {
        try {
          emit(LoadingState());
          await AuthService.signUp(
              emailController.text, passwordController.text, userNameController.text);
          emit(NextTabBarPageState());
          if (kDebugMode) {
            print("Go to the next page");
          }
        } catch
 (e) {
          emit(ErrorState(message: e.toString()));
        }
      } else {
        emit(ShowErrorState());
      }
    });
    // Handle SignInTappedEvent
    on<SignInTappedEvent>((event, emit) {
      emit(NextSignInPageState());
    });
  }

  bool checkIfSignUpButtonEnabled() {
    return userNameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty;
  }

  bool checkValidatorsOfTextField() {
    return ValidationService.username(userNameController.text) &&
        ValidationService.email(emailController.text) &&
        ValidationService.password(passwordController.text) &&
        ValidationService.confirmPassword(passwordController.text, confirmPasswordController.text);
  }
}
