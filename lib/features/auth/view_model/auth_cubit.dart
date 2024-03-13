// import 'dart:convert';
// import 'dart:developer';
//
// import 'package:dio/dio.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:meta/meta.dart';
// import 'package:otp_pin_field/otp_pin_field.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// part 'auth_state.dart';
//
// class AuthCubit extends Cubit<AuthState> {
//   AuthCubit() : super(AuthInitial()) {
//
//   }
//
//   static get(context) => BlocProvider.of<AuthCubit>(context);
//   // final otpPinFieldController = GlobalKey<OtpPinFieldState>();
//   // TextEditingController phoneController = TextEditingController();
//   // TextEditingController phoneProfileController = TextEditingController();
//   // final loginFormKey = GlobalKey<FormState>();
//   //
//   // TextEditingController nameRegisterController = TextEditingController();
//   // TextEditingController addressRegisterController = TextEditingController();
//   // final registerFormKey = GlobalKey<FormState>();
//   //
//   // UserModel? userModel;
//   // bool isFirstLoginTime = false;
//   //
//   // // Future<void> loginUser(
//   // //     {required String phoneNumber,
//   // //     required BuildContext context,
//   // //     bool isFirstLogin = false}) async {
//   // //   try {
//   // //     emit(AuthLoginLoading());
//   // //     String? deviceId;
//   // //     SharedPreferences sharedPreferences =
//   // //         await SharedPreferences.getInstance();
//   // //     deviceId = sharedPreferences.getString("device_token");
//   // //     Response response = await AuthRepository.loginRepo(
//   // //         data: {'phone': phoneNumber, 'device_id': deviceId});
//   // //
//   // //     if (response.data['status']) {
//   // //       userModel = UserModel.fromJson(response.data);
//   // //       CacheHelper.setSavedString('token', userModel!.data!.token!);
//   // //       CacheHelper.setSavedString('userName', userModel!.data!.name!);
//   // //       CacheHelper.setSavedString('phone', userModel!.data!.phone!);
//   // //
//   // //       userName = userModel!.data!.name!;
//   // //       phoneNumber = phoneController.text;
//   // //       phoneProfileController.text = phoneNumber;
//   // //
//   // //       print('loginphone=-------');
//   // //       print(phoneNumber);
//   // //       isFirstLoginTime = isFirstLogin;
//   // //
//   // //       emit(AuthLoginSuccess());
//   // //
//   // //       if (!isFirstLogin) {
//   // //         Navigator.pop(context);
//   // //         removeUntilNavigator(context: context, screen: const HomeScreen());
//   // //       }
//   // //     } else {
//   // //       emit(
//   // //           AuthLoginError(errorMessage: response.data['message']['phone'][0]));
//   // //     }
//   // //     print(response.data);
//   // //   } catch (ex) {
//   // //     emit(AuthLoginError(errorMessage: AppStrings.pleaseTryAgain.tr()));
//   // //   }
//   // // }
//   //
//   // Future<bool> checkToken({required BuildContext context}) async {
//   //   try {
//   //     Response response = await AuthRepository.getClientProfile();
//   //     return response.data['status'];
//   //   } catch (ex) {
//   //     return false;
//   //   }
//   // }
//   //
//   // Future<void> login(
//   //     {required String phoneNumber,
//   //       required String otpCode,
//   //       required BuildContext context}) async {
//   //   try {
//   //     emit(AuthLoginLoading());
//   //     String? deviceId;
//   //     SharedPreferences sharedPreferences =
//   //     await SharedPreferences.getInstance();
//   //     deviceId = sharedPreferences.getString("device_token");
//   //     Response response = await AuthRepository.loginRepo(data: {
//   //       'phone': phoneNumber,
//   //       "otp_code": otpCode,
//   //       'device_id': deviceId
//   //     });
//   //
//   //     if (response.data['status']) {
//   //       userModel = UserModel.fromJson(response.data);
//   //
//   //       CacheHelper.setSavedString('token', userModel!.data!.token!);
//   //       CacheHelper.setSavedString('userName', userModel!.data!.name!);
//   //       CacheHelper.setSavedString('phone', userModel!.data!.phone!);
//   //
//   //       userName = userModel!.data!.name!;
//   //       phoneNumber = phoneController.text;
//   //       phoneProfileController.text = phoneNumber;
//   //
//   //       print('loginphone=-------');
//   //       print(phoneNumber);
//   //       showToast(
//   //           message: AppStrings.successLogin.getTranslated, context: context);
//   //       emit(AuthLoginSuccess());
//   //
//   //       Navigator.pop(context);
//   //       removeUntilNavigator(context: context, screen: const HomeScreen());
//   //     } else {
//   //       showToast(message: AppStrings.errorOTP.getTranslated, context: context);
//   //       emit(
//   //           AuthLoginError(errorMessage: response.data['message']['phone'][0]));
//   //     }
//   //     print(response.data);
//   //   } catch (ex) {
//   //     emit(AuthLoginError(errorMessage: AppStrings.pleaseTryAgain.tr()));
//   //   }
//   // }
//   //
//   // Future<void> register(
//   //     {required String phoneNumber,
//   //       required String name,
//   //       required String addressDescription,
//   //       required double longitude,
//   //       required double latitude,
//   //       required BuildContext context}) async {
//   //   try {
//   //     emit(AuthRegisterLoading());
//   //
//   //     Response response = await AuthRepository.registerRepo(
//   //       data: {
//   //         'name': name,
//   //         'phone': phoneNumber,
//   //         'description': addressDescription,
//   //         'longitude': longitude,
//   //         'latitude': latitude,
//   //       },
//   //     );
//   //
//   //     if (response.data['status']) {
//   //       emit(AuthRegisterSuccess());
//   //       mainNavigate(
//   //         context: context,
//   //         screen: VerifyScreen(phoneNumber: phoneNumber, fromLogin: false),
//   //       );
//   //     } else {
//   //       emit(AuthRegisterError(errorMessage: response.data['message']));
//   //     }
//   //
//   //     print(response.data);
//   //   } catch (ex) {
//   //     emit(AuthRegisterError(errorMessage: AppStrings.pleaseTryAgain.tr()));
//   //   }
//   // }
//   //
//   // Future<void> registerUser(
//   //     {required String phoneNumber,
//   //       required String name,
//   //       required String addressDescription,
//   //       required double longitude,
//   //       required double latitude,
//   //       required BuildContext context}) async {
//   //   try {
//   //     emit(AuthRegisterLoading());
//   //
//   //     Response response = await AuthRepository.registerRepo(
//   //       data: {
//   //         'name': name,
//   //         'phone': phoneNumber,
//   //         'description': addressDescription,
//   //         'longitude': longitude,
//   //         'latitude': latitude,
//   //       },
//   //     );
//   //
//   //     if (response.data['status']) {
//   //       userModel = UserModel.fromJson(response.data);
//   //       CacheHelper.setSavedString('userName', name);
//   //       CacheHelper.setSavedString('token', userModel!.data!.token!);
//   //       CacheHelper.setSavedString('phone', userModel!.data!.phone!);
//   //
//   //       print(userModel!.data!.token!);
//   //       print('userModel!.data!.token!---------');
//   //       userName = userModel!.data!.name!;
//   //       phoneNumber = userModel!.data!.phone!;
//   //
//   //       emit(AuthRegisterSuccess());
//   //       removeUntilNavigator(context: context, screen: const HomeScreen());
//   //     } else {
//   //       if (response.data['message']['phone'] != null) {
//   //         emit(AuthRegisterError(
//   //             errorMessage: response.data['message']['phone'][0]));
//   //       }
//   //     }
//   //
//   //     print(response.data);
//   //   } catch (ex) {
//   //     emit(AuthRegisterError(errorMessage: AppStrings.pleaseTryAgain.tr()));
//   //   }
//   // }
//
//
// }
//
// import 'package:erp_application/modules/authentication/presentation/cubit/auth_states.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// abstract class AbstractAuthCubit extends Cubit<AuthStates> {
//   AbstractAuthCubit(super.initialState);
//
//   bool rememberMe = false;
//   bool showPassword = false;
//
//   void toggleRememberMe();
//   void toggleShowPassword();
//
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_state.dart';

abstract class AbstractAuthCubit extends Cubit<AuthStates> {
  AbstractAuthCubit(super.initialState);

  bool rememberMe = false;
  bool showPassword = false;

  void toggleRememberMe();
  void toggleShowPassword();

}

class AuthCubit extends AbstractAuthCubit {
  AuthCubit() : super(AuthInitial());

  static AuthCubit get(context) => BlocProvider.of(context);

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void toggleRememberMe() {
    rememberMe = !rememberMe;
    emit(AuthRememberMeToggle());
  }

  @override
  void toggleShowPassword() {
    showPassword = !showPassword;
    emit(AuthShowPasswordToggle());
  }
}