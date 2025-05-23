import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NoteListController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxList<QueryDocumentSnapshot> notes = <QueryDocumentSnapshot>[].obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    fetchNotes();
    super.onInit();
  }

  Future<void> fetchNotes() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    isLoading.value = true;

    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('notes')
          .orderBy('date', descending: true)
          .get();

      notes.value = querySnapshot.docs;
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch notes: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // For real-time updates (alternative approach)
  Stream<QuerySnapshot> get notesStream {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return const Stream.empty();

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .orderBy('date', descending: true)
        .snapshots();
  }
}
