import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;

  void signup() async {
    isLoading.value = true;
    try {
      // await _authRepository.signup(
      //   email: emailController.text,
      //   password: passwordController.text,
      // );
      // Handle successful signup, e.g., navigate to the home screen
    } catch (e) {
      // Handle signup error, e.g., show a snackbar with the error message
    } finally {
      isLoading.value = false;
    }
  }
}
