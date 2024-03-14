import 'package:ebook_web/features/auth/view_model/auth_cubit.dart';

import 'package:ebook_web/features/auth/view_model/auth_cubit.dart';

import 'package:ebook_web/features/auth/view_model/auth_cubit.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoginLoading extends AuthState {}

class AuthLoginSuccess extends AuthState {}

class AuthLoginError extends AuthState {
  final String errorMessage;

  AuthLoginError({required this.errorMessage});
}

class AuthRegisterLoading extends AuthState {}

class AuthRegisterSuccess extends AuthState {}

class AuthRegisterError extends AuthState {
  final String errorMessage;

  AuthRegisterError({required this.errorMessage});
}

class GetCurrentAddressSuccess extends AuthState {}

class OTPLoading extends AuthState {}

class ClientNotExist extends AuthState {}

class ClientExist extends AuthState {}

class OTPSuccess extends AuthState {}

class OTPError extends AuthState {}

class CheckBoxState extends AuthState {}

class ChangeLanguageState extends AuthState {}



class CreateUserSuccessState extends AuthState {
  final uId;
  CreateUserSuccessState(this.uId);

}

class CreateUserErrorState extends AuthState {
  final String errorMessage;

  CreateUserErrorState(this.errorMessage);
}



class LoginLoadingState extends AuthState {}

class LoginSuccessState extends AuthState {
  final String uId;
  LoginSuccessState(this.uId);
}

class LoginErrorState extends AuthState {
  final error;

  LoginErrorState(this.error);
}

