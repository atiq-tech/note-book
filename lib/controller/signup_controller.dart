import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quickalert/quickalert.dart';

class SignUpController extends GetxController {
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  Future<void> handleSignUp({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
  }) async {
    // Check required fields
    if (name.trim().isEmpty ||
        email.trim().isEmpty ||
        password.trim().isEmpty) {
      _showErrorAlert(context, 'All fields are required.');
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Firebase Auth
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = userCredential.user;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'user-not-created',
          message: 'User account could not be created',
        );
      }

      // Update name
      await user.updateDisplayName(name.trim());

      // Save to Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': name.trim(),
        'email': email.trim(),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: 'Success!',
        text: 'Account Created Successfully!',
        showConfirmBtn: false,
        showCancelBtn: false,
        barrierDismissible: true,
        autoCloseDuration: const Duration(seconds: 3),
      );

      context.go('/login');
    } on FirebaseAuthException catch (e) {
      _handleFirebaseError(context, e);
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred. Please try again.';
      _showErrorAlert(context, errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  void _handleFirebaseError(BuildContext context, FirebaseAuthException e) {
    String msg;
    switch (e.code) {
      case 'invalid-email':
        msg = 'The email address is badly formatted.';
        break;
      case 'email-already-in-use':
        msg = 'An account already exists for that email.';
        break;
      case 'weak-password':
        msg = 'The password provided is too weak.';
        break;
      case 'operation-not-allowed':
        msg = 'Email/password accounts are not enabled.';
        break;
      case 'user-not-created':
        msg = 'User account could not be created.';
        break;
      default:
        msg = 'An error occurred during sign up: ${e.message}';
    }

    errorMessage.value = msg;
    _showErrorAlert(context, msg);
  }

  void _showErrorAlert(BuildContext context, String message) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Error!',
      text: message,
      showConfirmBtn: false,
      showCancelBtn: false,
      barrierDismissible: true,
      autoCloseDuration: const Duration(seconds: 2),
    );
  }
}
