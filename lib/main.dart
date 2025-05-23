import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:note_app/app/router_manager.dart';
import 'package:note_app/controller/login_controller.dart';
import 'package:note_app/controller/note_list_controller.dart';
import 'package:note_app/controller/post_note_controller.dart';
import 'package:note_app/controller/signup_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //GETx ডিপেনডেন্সি ইনজেকশন
  Get.put(LoginController());
  Get.put(PostNoteController());
  Get.put(NoteListController());
  Get.put(SignUpController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, child) => MaterialApp.router(
        title: 'Note Book',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routerConfig: RouteManager.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
