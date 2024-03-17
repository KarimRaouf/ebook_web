import 'package:ebook_web/core/utils/strings.dart';
import 'package:ebook_web/features/admin_panel/view_model/panel_cubit.dart';
import 'package:ebook_web/features/admin_panel/view_model/panel_state.dart';
import 'package:ebook_web/features/admin_panel/views/books_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/utils/app_util.dart';
import '../../../core/utils/styles.dart';
import '../../../shared/cache_helper.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';
import '../../admin_panel/views/panel_view.dart';
import '../view_model/auth_cubit.dart';
import '../view_model/auth_state.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    double mediaHeight = MediaQuery
        .sizeOf(context)
        .height; //!900
    double mediaWidth = MediaQuery
        .sizeOf(context)
        .width; //!400
    const border = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 1),
      borderRadius: BorderRadius.all(Radius.circular(10)),
    );
    return BlocConsumer<PanelCubit, PanelState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        PanelCubit panelCubit = PanelCubit.get(context);
        return BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is LoginErrorState) {
              AppUtil.showToast(message: state.error);
            }

            if (state is LoginSuccessState) {
              CacheHelper.saveUserToken(
                state.uId,
              ).then((value) {
                panelCubit.updateUserStatus(userId: state.uId , status: 'Inactive');
                AppUtil.removeUntilNavigator(context, BooksView());
                AppUtil.showToast(message: 'Login Successfully');
              });
            }
          },
          builder: (context, state) {
            AuthCubit authCubit = AuthCubit.get(context);
            return Scaffold(
              body: SingleChildScrollView(
                child: Form(
                  key: authCubit.loginFormKey,
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
                            const Text('Sign in to your account',
                                style: Styles.textStyle14),
                            const SizedBox(height: 24),
                            const Text('Email', style: Styles.textStyle16),
                            const SizedBox(height: 8),
                            CustomTextField(
                              textInputType: TextInputType.emailAddress,
                              controller: authCubit.emailLoginController,
                              hint: 'Enter your Email',
                              validation: true,
                              height: 80,
                            ),
                            // const SizedBox(height: 16),
                            const Text('Password', style: Styles.textStyle16),
                            const SizedBox(height: 8),
                            CustomTextField(
                              textInputType: TextInputType.visiblePassword,
                              controller: authCubit.passwordLoginController,
                              hint: 'Enter your password',
                              validation: true,
                              height: 80,
                              obscureText: true,
                            ),
                            const SizedBox(height: 8),
                            // const RememberMe(),
                            const SizedBox(height: 8),
                            state is LoginLoadingState
                                ? CustomButton(
                              size: 25,
                              hasChild: false,
                              text: 'Login',
                              onTap: () {},
                              buttomWidth: mediaWidth > 400
                                  ? .85 * mediaWidth
                                  : .75 * mediaWidth,
                            )
                                : CustomButton(
                              size: 25,
                              text: 'Login',
                              onTap: () {
                                if (authCubit.loginFormKey.currentState!
                                    .validate()) {
                                  authCubit.userLogin(
                                    email:
                                    authCubit.emailLoginController.text,
                                    password: authCubit
                                        .passwordLoginController.text,
                                  );
                                }
                              },
                              buttomWidth: mediaWidth > 400
                                  ? .85 * mediaWidth
                                  : .75 * mediaWidth,
                            ),

                            TextButton(
                              onPressed: () {
                                AppUtil.mainNavigator(context, LoginView());
                              },
                              child: const Text(
                                'Register',
                                style: Styles.textStyle12,
                              ),
                            ),

                            const SizedBox(height: 16),
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
      },
    );
  }
}
