// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebook_web/features/auth/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/utils/app_util.dart';
import '../../../core/utils/styles.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';
import '../view_model/auth_cubit.dart';
import '../view_model/auth_state.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    // double mediaHeight = MediaQuery.sizeOf(context).height; //!900

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthRegisterError) {
          AppUtil.showToast(message: state.errorMessage);
        } else if (state is CreateUserSuccessState) {
          AppUtil.showToast(message: 'Register successfully');

          AppUtil.mainNavigator(context, LoginView());
        }
      },
      builder: (context, state) {
        AuthCubit authCubit = AuthCubit.get(context);
        return Scaffold(
          body: SingleChildScrollView(
            child: Form(
              key: authCubit.registerFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppUtil.responsiveWidth(context) * 0.35,
                      vertical: AppUtil.responsiveHeight(context) * 0.1,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome on board!',
                          style: Styles.textStyle24,
                        ),
                        const SizedBox(height: 8),
                        const Text('Register', style: Styles.textStyle16),
                        const SizedBox(height: 24),
                        const Text('Email', style: Styles.textStyle16),
                        const SizedBox(height: 8),
                        CustomTextField(
                          textInputType: TextInputType.emailAddress,
                          controller: authCubit.emailController,
                          hint: 'Enter your Email',
                          validation: true,
                          height: 60,
                        ),

                        const Text('Name', style: Styles.textStyle16),
                        const SizedBox(height: 8),

                        CustomTextField(
                          textInputType: TextInputType.name,
                          controller: authCubit.nameController,
                          hint: 'Enter your name',
                          validation: true,
                          height: 60,
                        ),

                        // const SizedBox(height: 16),
                        const Text('Phone', style: Styles.textStyle16),
                        const SizedBox(height: 8),

                        CustomTextField(
                          textInputType: TextInputType.phone,
                          controller: authCubit.phoneController,
                          hint: 'Enter Your Phone',
                          validation: true,
                          height: 60,
                        ),
                        // const SizedBox(height: 8),

                        const Text('Password', style: Styles.textStyle16),
                        const SizedBox(height: 8),

                        CustomTextField(
                          textInputType: TextInputType.visiblePassword,
                          controller: authCubit.passwordController,
                          hint: 'Enter your password',
                          validation: true,
                          height: 60,
                          obscureText: true,
                        ),
                        // const SizedBox(height: 8),

                        const Text('Confirm Password',
                            style: Styles.textStyle16),
                        const SizedBox(height: 8),

                        CustomTextField(
                          textInputType: TextInputType.visiblePassword,
                          controller: authCubit.confirmPasswordController,
                          hint: 'Enter your password',
                          validation: true,
                          height: 60,
                          obscureText: true,
                        ),
                        // const RememberMe(),
                        const SizedBox(height: 24),

                        if (state is AuthRegisterLoading)
                          CustomButton(
                            hasChild: false,
                            size: 25,
                            text: 'Register',
                            onTap: () {},
                            buttomWidth: .75 * MediaQuery.sizeOf(context).width,
                          ),
                        if (state is! AuthRegisterLoading)
                          CustomButton(
                            hasChild: true,
                            size: 25,
                            text: 'Register',
                            onTap: () {
                              if (authCubit.registerFormKey.currentState!
                                      .validate() &&
                                  authCubit.passwordController.text ==
                                      authCubit
                                          .confirmPasswordController.text) {
                                authCubit.userRegister(
                                  email: authCubit.emailController.text,
                                  password: authCubit.passwordController.text,
                                  name: authCubit.nameController.text,
                                  phone: authCubit.phoneController.text,
                                );
                              }

                              if (authCubit.passwordController.text !=
                                  authCubit.confirmPasswordController.text) {
                                AppUtil.showToast(
                                    message: 'Password doesn\'t match');
                              }
                            },
                            buttomWidth: .75 * MediaQuery.sizeOf(context).width,
                          ),
                        // SizedBox(
                        //   height: mediaHeight > 900
                        //       ? .2 * mediaHeight
                        //       : .07 * mediaHeight,
                        // ),

                        TextButton(
                          onPressed: () {
                            AppUtil.mainNavigator(context, LoginView());
                          },
                          child: const Text(
                            'Login',
                            style: Styles.textStyle12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
