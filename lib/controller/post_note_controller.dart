import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_app/controller/note_list_controller.dart';

class PostNoteController extends GetxController {
  RxBool isLoading = false.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addNote(String title, String content) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      Get.snackbar('Error', 'User not logged in');
      return;
    }

    isLoading.value = true;

    try {
      await _firestore.collection('users').doc(userId).collection('notes').add({
        'title': title,
        'content': content,
        'date': DateTime.now().toIso8601String(),
      });

      // Reload notes after adding
      Get.find<NoteListController>().fetchNotes();
    } catch (e) {
      Get.snackbar('Error', 'Failed to add note: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
