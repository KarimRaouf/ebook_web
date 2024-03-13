import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/utils/app_util.dart';
import '../../../core/utils/styles.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';
import '../view_model/auth_cubit.dart';
import '../view_model/auth_state.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AuthCubit authCubit = AuthCubit.get(context);
        return Scaffold(
          body: SingleChildScrollView(
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
                      // const RememberMe(),
                      const SizedBox(height: 16),
                      CustomButton(
                        text: 'Login',
                        height: 40,
                        onTap: () {},
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
