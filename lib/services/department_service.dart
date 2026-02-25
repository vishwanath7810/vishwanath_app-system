import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/department_model.dart';

class DepartmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add Department (Admin only)
  Future<void> addDepartment({
    required String name,
    required String hod,
    required String description,
  }) async {
    await _firestore.collection('Departments').add({
      'name': name,
      'hod': hod,
      'description': description,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Get Departments (for students registration dropdown)
  Stream<List<DepartmentModel>> getDepartments() {
    return _firestore
        .collection('Departments')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) =>
        DepartmentModel.fromMap(doc.id, doc.data()))
        .toList());
  }
}