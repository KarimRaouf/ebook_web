import 'package:erp_application/modules/authentication/presentation/cubit/auth_cubit.dart';
import 'package:erp_application/modules/authentication/presentation/cubit/auth_state.dart';
import 'package:erp_application/modules/authentication/presentation/views/change_password_view.dart';
import 'package:erp_application/shared/widgets/custom_button.dart';
import 'package:erp_application/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../generated/assets.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../utils/app_ui.dart';
import '../../../../utils/styles.dart';
import '../../../core/utils/styles.dart';
import '../view_model/auth_cubit.dart';
import 'widgets/erp_title.dart';
import 'widgets/remember_me.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {},
      builder: (context, state) {
        AuthCubit authCubit = AuthCubit.get(context);
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
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
                        controller: authCubit.emailController,
                        hint: 'Enter your Email',
                      ),
                      const SizedBox(height: 16),
                      const Text('Password', style: Styles.textStyle16),
                      const SizedBox(height: 8),
                      CustomTextField(
                        textInputType: TextInputType.visiblePassword,
                        controller: authCubit.passwordController,
                        hint: 'Enter your password',
                      ),
                      const SizedBox(height: 8),
                      const RememberMe(),
                      const SizedBox(height: 16),
                      CustomButton(
                        text: 'Login',
                        height: 40,
                        onTap: () {
                          AppUtil.mainNavigator(
                              context, const ChangePasswordView());
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}