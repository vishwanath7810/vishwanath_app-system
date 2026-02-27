import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/department_model.dart';

class DepartmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🔥 GET ONLY ACTIVE (NOT DELETED) DEPARTMENTS
  Stream<List<DepartmentModel>> getActiveDepartments() {
    return _firestore
        .collection("Departments")
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) =>
          DepartmentModel.fromMap(doc.id, doc.data()))
          .where((dept) => dept.deletedStatus != true)
          .toList();
    });
  }

  /// Optional: Get ALL departments (for admin)
  Stream<List<DepartmentModel>> getAllDepartments() {
    return _firestore
        .collection("Departments")
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) =>
        DepartmentModel.fromMap(doc.id, doc.data()))
        .toList());
  }

  /// 🔥 ADD DEPARTMENT
  Future<void> addDepartment({
    required String name,
    required String hod,
    required String description,
  }) async {
    await _firestore.collection("Departments").add({
      "name": name,
      "hod": hod,
      "description": description,
      "deletedStatus": false,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  /// 🔥 SOFT DELETE
  Future<void> softDeleteDepartment(String id) async {
    await _firestore.collection("Departments").doc(id).update({
      "deletedStatus": true,
      "deletedAt": FieldValue.serverTimestamp(),
    });
  }

  /// 🔥 UPDATE
  Future<void> updateDepartment({
    required String id,
    required String name,
    required String hod,
    required String description,
  }) async {
    await _firestore.collection("Departments").doc(id).update({
      "name": name,
      "hod": hod,
      "description": description,
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }
}