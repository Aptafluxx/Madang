import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;

  void login() async {
    isLoading.value = true;
    try {
      // await _authRepository.login(
      //   email: emailController.text,
      //   password: passwordController.text,
      // );
      // Handle successful login, e.g., navigate to the home screen
    } catch (e) {
      // Handle login error, e.g., show a snackbar with the error message
    } finally {
      isLoading.value = false;
    }
  }
}
