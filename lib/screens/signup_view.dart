import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:note_app/controller/signup_controller.dart';
import 'package:quickalert/quickalert.dart';

class SignUpView extends StatelessWidget {
  SignUpView({super.key});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final SignUpController _signUpController = Get.put(SignUpController());

  final RxBool _passwordVisible = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6A5ADF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20.h),
                Lottie.asset(
                  'assets/animations/signup.json',
                  width: 200.w,
                  height: 200.h,
                ),
                SizedBox(height: 30.h),
                Text(
                  "Create your account",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20.h),
                _buildTextField(
                  controller: _nameController,
                  hint: 'Full Name',
                ),
                SizedBox(height: 16.h),
                _buildTextField(
                  controller: _emailController,
                  hint: 'Email Address',
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 16.h),
                Obx(() => _buildTextField(
                      controller: _passwordController,
                      hint: 'Password',
                      obscureText: !_passwordVisible.value,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white70,
                        ),
                        onPressed: () {
                          _passwordVisible.value = !_passwordVisible.value;
                        },
                      ),
                    )),
                SizedBox(height: 24.h),
                Obx(() => ElevatedButton(
                      onPressed: _signUpController.isLoading.value
                          ? null
                          : () {
                              final name = _nameController.text.trim();
                              final email = _emailController.text.trim();
                              final password = _passwordController.text.trim();

                              // Manual validations
                              if (name.isEmpty || name.length < 3) {
                                _showError(context, 'Please enter your name');
                                return;
                              }
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                  .hasMatch(email)) {
                                _showError(context, 'Please enter your email');
                                return;
                              }
                              if (password.length < 6) {
                                _showError(context,
                                    'Password must be at least 6 characters');
                                return;
                              }

                              _signUpController.handleSignUp(
                                context: context,
                                name: name,
                                email: email,
                                password: password,
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF6A5ADF),
                        shape: const StadiumBorder(),
                        minimumSize: Size(double.infinity, 48.h),
                      ),
                      child: _signUpController.isLoading.value
                          ? SizedBox(
                              height: 20.h,
                              width: 20.h,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF6A5ADF),
                              ),
                            )
                          : Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    )),
                SizedBox(height: 12.h),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: Text(
                      'Already have an account? Sign In',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: TextStyle(fontSize: 16.sp, color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            TextStyle(fontSize: 16.sp, color: Colors.white.withOpacity(0.7)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.15),
        contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.r),
          borderSide: BorderSide.none,
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }

  void _showError(BuildContext context, String message) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Error!',
      text: message,
      barrierDismissible: true,
      autoCloseDuration: const Duration(seconds: 2),
      showConfirmBtn: false,
    );
  }
}
