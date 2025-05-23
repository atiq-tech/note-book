import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../controller/login_controller.dart';
import 'package:note_app/widgets/coming_soon_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LoginController loginController = Get.put(LoginController());

  bool _passwordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6A5ADF),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(16.0.r),
                    child: FadeInUp(
                      duration: const Duration(milliseconds: 1300),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 20.h),
                          Lottie.asset(
                            'assets/animations/login.json',
                            width: 200.w,
                            height: 200.h,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(height: 30.h),
                          Text(
                            "Sign in with your email",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  hintText: 'Email Address',
                                  hintStyle: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.white.withOpacity(0.7)),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.15),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 24.w, vertical: 14.h),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(50.r),
                                  ),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(
                                    fontSize: 16.sp, color: Colors.white),
                              ),
                              SizedBox(height: 16.h),
                              TextField(
                                controller: _passwordController,
                                obscureText: !_passwordVisible,
                                style: TextStyle(
                                    fontSize: 16.sp, color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  hintStyle: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.white.withOpacity(0.7)),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.15),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 24.w, vertical: 14.h),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(50.r),
                                  ),
                                  suffixIcon: Padding(
                                    padding: EdgeInsets.only(right: 12.w),
                                    child: IconButton(
                                      icon: Icon(
                                        _passwordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        size: 24.sp,
                                        color: Colors.white70,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _passwordVisible = !_passwordVisible;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const ComingSoonView(),
                                        ));
                                  },
                                  child: Text(
                                    'Need help signing in?',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 18.h),
                              Obx(() => ElevatedButton(
                                    onPressed: loginController.isLoading.value
                                        ? null
                                        : () {
                                            loginController.handleLogin(
                                              context: context,
                                              email:
                                                  _emailController.text.trim(),
                                              password: _passwordController.text
                                                  .trim(),
                                            );
                                          },
                                    style: ElevatedButton.styleFrom(
                                      elevation: 5,
                                      backgroundColor: Colors.white,
                                      foregroundColor: const Color(0xFF6A5ADF),
                                      minimumSize: Size(double.infinity, 48.h),
                                      shape: const StadiumBorder(),
                                      padding:
                                          EdgeInsets.symmetric(vertical: 12.h),
                                    ),
                                    child: loginController.isLoading.value
                                        ? SizedBox(
                                            height: 20.h,
                                            width: 20.h,
                                            child:
                                                const CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Color(0xFF6A5ADF),
                                            ),
                                          )
                                        : Text(
                                            "Continue",
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
                                    context.push('/signup');
                                  },
                                  child: Text(
                                    'Don’t have an account? Sign Up',
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
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
