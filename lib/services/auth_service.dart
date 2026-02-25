import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  Future<void> registerStudent({
    required String email,
    required String password,
    required String departmentId,
    required String departmentName,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    await _db.collection("Users").doc(cred.user!.uid).set({
      "email": email,
      "role": "student",
      "departmentId": departmentId,
      "departmentName": departmentName,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  Future<String> login(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    final doc =
    await _db.collection("Users").doc(cred.user!.uid).get();

    return doc['role'];
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}