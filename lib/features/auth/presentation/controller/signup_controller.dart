import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madang/app/routes/app_routes.dart';
import 'package:madang/core/errors/auth_exceptions.dart';
import 'package:madang/core/widgets/app_snackbar.dart';
import 'package:madang/features/auth/data/repositories/auth_repository.dart';

class SignupController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final signupFormKey = GlobalKey<FormState>();

  final isLoading = false.obs;

  Future<void> signup() async {
    if (signupFormKey.currentState!.validate()) {
      if (isLoading.value) return;

      try {
        isLoading.value = true;

        await AuthRepository.instance.signUpWithEmail(
          emailController.text.trim(),
          passwordController.text.trim(),
          nameController.text.trim(),
        );

        AppSnackBar.success(Get.context!, "Account Created Successfully");

        Get.offAllNamed(AppRoutes.home);
      } on AuthException catch (e) {
        AppSnackBar.error(Get.context!, e.message);
      } finally {
        isLoading.value = false;
      }
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
