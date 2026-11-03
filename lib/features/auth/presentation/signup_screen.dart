import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:madang/app/routes/app_routes.dart';
import 'package:madang/app/theme/app_colors.dart';
import 'package:madang/app/theme/app_text_theme.dart';
import 'package:madang/core/widgets/custom_button.dart';
import 'package:madang/core/widgets/custom_text_field.dart';
import 'package:madang/core/widgets/custom_top_navigation.dart';
import 'package:madang/features/auth/presentation/controller/signup_controller.dart';

class SignupScreen extends GetView<SignupController> {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: CustomTopNavigation(
          title: "Sign Up",
          onBack: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              Get.offAllNamed(AppRoutes.onboarding);
            }
          },
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: .symmetric(horizontal: 15, vertical: 10),
            child: Form(
              key: controller.signupFormKey,
              child: Column(
                crossAxisAlignment: .center,
                children: [
                  const SizedBox(height: 100),
                  CustomTextField(
                    hintText: "Name",
                    label: "Name",
                    textInputAction: .next,
                    keyboardType: .name,
                    controller: controller.nameController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if ((value ?? '').trim().isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    hintText: "Email",
                    label: "Email",
                    textInputAction: .next,
                    keyboardType: .emailAddress,
                    controller: controller.emailController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      final email = value?.trim() ?? '';
                      if (email.isEmpty) return 'Email is required';
                      if (!GetUtils.isEmail(email)) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    hintText: "Password",
                    label: "Password",
                    isPassword: true,
                    keyboardType: .visiblePassword,
                    controller: controller.passwordController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      final password = value ?? '';
                      if (password.isEmpty) return 'Password is required';
                      if (password.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),
                  CustomButton(
                    label: "Sign Up",
                    onPressed: controller.signup,
                    isLoading: controller.isLoading.value,
                  ),
                  const SizedBox(height: 25),
                  RichText(
                    text: TextSpan(
                      style: AppTextStyles.subtitle2.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      children: [
                        const TextSpan(text: "Already have an account? "),
                        TextSpan(
                          text: "Login",
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Get.toNamed(AppRoutes.login),
                          style: AppTextStyles.subtitle2.copyWith(
                            decoration: .underline,
                            color: AppColors.primary30,
                          ),
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
