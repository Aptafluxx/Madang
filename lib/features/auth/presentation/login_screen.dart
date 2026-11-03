import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madang/app/routes/app_routes.dart';
import 'package:madang/app/theme/app_colors.dart';
import 'package:madang/app/theme/app_text_theme.dart';
import 'package:madang/core/widgets/custom_button.dart';
import 'package:madang/core/widgets/custom_text_field.dart';
import 'package:madang/core/widgets/custom_top_navigation.dart';
import 'package:madang/features/auth/presentation/controller/login_controller.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: CustomTopNavigation(title: "Login"),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: .symmetric(horizontal: 15, vertical: 10),
            child: Form(
              key: controller.loginFormKey,
              child: Column(
                crossAxisAlignment: .center,
                children: [
                  const SizedBox(height: 100),
                  CustomTextField(
                    hintText: "Email",
                    label: "Email",
                    textInputAction: .next,
                    keyboardType: .emailAddress,
                    controller: controller.emailController,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    hintText: "Password",
                    label: "Password",
                    isPassword: true,
                    keyboardType: .visiblePassword,
                    controller: controller.passwordController,
                  ),
                  const SizedBox(height: 40),
                  CustomButton(
                    label: "Login",
                    onPressed: controller.login,
                    isLoading: controller.isLoading.value,
                  ),
                  const SizedBox(height: 25),
                  RichText(
                    text: TextSpan(
                      style: AppTextStyles.subtitle2.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      children: [
                        const TextSpan(text: "Doesn’t have an account? "),
                        TextSpan(
                          text: "Sign Up",
                          style: AppTextStyles.subtitle2.copyWith(
                            decoration: .underline,
                            color: AppColors.primary30,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Get.offAllNamed(AppRoutes.signup),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
