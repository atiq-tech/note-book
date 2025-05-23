import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:quickalert/quickalert.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<void> handleLogin({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error!',
        text: 'Email and Password are required.',
        showConfirmBtn: false,
        showCancelBtn: false,
        barrierDismissible: true,
        autoCloseDuration: const Duration(seconds: 1),
      );
      return;
    }

    isLoading.value = true;
    errorMessage.value = "";

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: 'Success!',
        text: 'Login Successfully!',
        showConfirmBtn: false,
        showCancelBtn: false,
        barrierDismissible: true,
        autoCloseDuration: const Duration(seconds: 3),
      );

      Future.delayed(const Duration(seconds: 3), () {
        context.go('/home');
      });
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          errorMessage.value = 'The email address is badly formatted.';
          break;
        case 'user-disabled':
          errorMessage.value = 'This user has been disabled.';
          break;
        case 'user-not-found':
          errorMessage.value = 'No user found with this email.';
          break;
        case 'wrong-password':
          errorMessage.value = 'Wrong password provided for that user.';
          break;
        default:
          errorMessage.value = 'An error occurred during login.';
      }

      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error!',
        text: errorMessage.value,
        showConfirmBtn: false,
        showCancelBtn: false,
        barrierDismissible: true,
        autoCloseDuration: const Duration(seconds: 2),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
