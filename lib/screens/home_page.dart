import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:note_app/controller/note_list_controller.dart';
import 'package:note_app/controller/post_note_controller.dart';
import 'package:quickalert/quickalert.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NoteListController noteListController = Get.put(NoteListController());
  final PostNoteController postNoteController = Get.put(PostNoteController());

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  @override
  void initState() {
    super.initState();

    // If new user login shwo new user data
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        noteListController.fetchNotes();
      }
    });
  }

  void _showAddNoteDialog() {
    titleController.clear();
    contentController.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Center(
            child: Text(
              'Add New Note',
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'Title',
                  hintStyle: TextStyle(fontSize: 16.sp, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 0.5.w),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 0.5.w),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              TextField(
                controller: contentController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Content',
                  hintStyle: TextStyle(fontSize: 16.sp, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 0.5.w),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 0.5.w),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.grey[700]),
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            Obx(() => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  ),
                  onPressed: postNoteController.isLoading.value
                      ? null
                      : () async {
                          final title = titleController.text.trim();
                          final content = contentController.text.trim();
                          if (title.isEmpty || content.isEmpty) return;

                          await postNoteController.addNote(title, content);
                          Navigator.pop(context);
                        },
                  child: Text(
                    'Add',
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                )),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.teal.shade800,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        leadingWidth: 60.w,
        backgroundColor: const Color(0xFF126172),
        titleSpacing: 0.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/icons/logo.png", height: 35.h, width: 40.w),
            SizedBox(width: 8.w),
            Text(
              "Note Book",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              QuickAlert.show(
                context: context,
                type: QuickAlertType.confirm,
                title: 'Logout Confirmation',
                text: 'Are you sure you want to log out?',
                confirmBtnText: 'Yes',
                cancelBtnText: 'No',
                onConfirmBtnTap: () async {
                  await FirebaseAuth.instance.signOut();
                  context.go('/login');
                },
              );
            },
            child: Icon(Icons.logout, size: 28.sp, color: Colors.white),
          ),
          SizedBox(width: 10.w),
        ],
      ),
      body: Obx(() {
        final notes = noteListController.notes;

        if (postNoteController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (notes.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset('assets/animations/write_note_two.json',
                    width: 200.w, height: 200.h),
                SizedBox(height: 20.h),
                Text.rich(
                  TextSpan(
                    text: 'No notes found.\n',
                    style: TextStyle(
                        fontSize: 18.sp,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w500),
                    children: [
                      TextSpan(
                        text: 'Press the ',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      TextSpan(
                        text: '+',
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp),
                      ),
                      TextSpan(
                        text: ' icon to get started!',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final note = notes[index].data() as Map<String, dynamic>;
            final title = note['title'] ?? '';
            final content = note['content'] ?? '';
            final date =
                DateTime.tryParse(note['date'] ?? '') ?? DateTime.now();

            return Container(
              width: double.infinity,
              margin: EdgeInsets.only(left: 12.w, right: 12.w, top: 12.h),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4)),
                ],
                border:
                    Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 16.r,
                  backgroundColor: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.blue, width: 1.5.w),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                title: Text(title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18.sp)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5.h),
                    Text(content),
                    SizedBox(height: 5.sp),
                    Text(
                      DateFormat('MMM dd, yyyy - hh:mm a').format(date),
                      style:
                          TextStyle(color: Colors.grey[600], fontSize: 12.sp),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: Container(
        width: 60.w,
        height: 60.h,
        decoration:
            const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
        child: Center(
          child: IconButton(
            icon: Icon(Icons.add, color: Colors.white, size: 26.sp),
            onPressed: _showAddNoteDialog,
          ),
        ),
      ),
    );
  }
}
