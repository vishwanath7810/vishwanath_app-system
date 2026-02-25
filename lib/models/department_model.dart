import 'package:cloud_firestore/cloud_firestore.dart';

class DepartmentModel {
  final String id;
  final String name;
  final String hod;
  final String description;
  final Timestamp createdAt;

  DepartmentModel({
    required this.id,
    required this.name,
    required this.hod,
    required this.description,
    required this.createdAt,
  });

  factory DepartmentModel.fromMap(String id, Map<String, dynamic> data) {
    return DepartmentModel(
      id: id,
      name: data['name'] ?? '',
      hod: data['hod'] ?? '',
      description: data['description'] ?? '',
      createdAt: data['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'hod': hod,
      'description': description,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}