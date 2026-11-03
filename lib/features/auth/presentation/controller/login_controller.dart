import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:madang/app/routes/app_routes.dart';
import 'package:madang/core/errors/auth_exceptions.dart';
import 'package:madang/core/widgets/app_snackbar.dart';
import 'package:madang/features/auth/data/repositories/auth_repository.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();
  final forgotEmailController = TextEditingController();

  final isLoading = false.obs;

  Future<void> login() async {
    if (loginFormKey.currentState!.validate()) {
      if (isLoading.value) return;

      try {
        isLoading.value = true;

        await AuthRepository.instance.signInWithEmail(
          emailController.text.trim(),
          passwordController.text.trim(),
        );

        AppSnackBar.success(Get.context!, "Login Successful");

        if (FirebaseAuth.instance.currentUser != null) {
          Get.offAllNamed(AppRoutes.home);
        } else {
          Get.offAllNamed(AppRoutes.login);
        }
      } on AuthException catch (e) {
        AppSnackBar.error(Get.context!, e.message);
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> sendPasswordReset() async {
    if (GetUtils.isEmail(forgotEmailController.text.trim())) {
      try {
        isLoading.value = true;

        await AuthRepository.instance.sendPasswordResetEmail(
          forgotEmailController.text.trim(),
        );

        Get.back();

        AppSnackBar.show(
          Get.context!,
          message: "Check your inbox for a link to reset your password.",
        );
      } on AuthException catch (e) {
        AppSnackBar.error(Get.context!, e.message);
      } finally {
        isLoading.value = false;
      }
    } else {
      AppSnackBar.error(Get.context!, "Enter a valid email");
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    forgotEmailController.dispose();
    super.onClose();
  }
}
