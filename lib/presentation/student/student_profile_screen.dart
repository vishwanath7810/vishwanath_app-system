import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() =>
      _StudentProfileScreenState();
}

class _StudentProfileScreenState
    extends State<StudentProfileScreen> {

  final uid = FirebaseAuth.instance.currentUser!.uid;
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final dobController = TextEditingController();
  final addressController = TextEditingController();
  final genderController = TextEditingController();
  final bloodGroupController = TextEditingController();
  final emergencyController = TextEditingController();

  String? imageUrl;
  String email = "";
  String department = "";
  String profileStatus = "not_submitted";
  String? rejectionReason;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final doc = await FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .get();

    final data = doc.data();
    final profile = data?["profile"] ?? {};

    setState(() {
      nameController.text = profile["fullName"] ?? "";
      phoneController.text = profile["phone"] ?? "";
      dobController.text = profile["dob"] ?? "";
      addressController.text = profile["address"] ?? "";
      genderController.text = profile["gender"] ?? "";
      bloodGroupController.text = profile["bloodGroup"] ?? "";
      emergencyController.text = profile["emergencyContact"] ?? "";
      imageUrl = profile["profileImageUrl"];
      email = data?["email"] ?? "";
      department = data?["departmentName"] ?? "";
      profileStatus = data?["profileStatus"] ?? "not_submitted";
      rejectionReason = data?["profileReview"]?["reason"];
    });
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    await FirebaseFirestore.instance.collection("Users").doc(uid).update({
      "profile.fullName": nameController.text.trim(),
      "profile.phone": phoneController.text.trim(),
      "profile.dob": dobController.text.trim(),
      "profile.address": addressController.text.trim(),
      "profile.gender": genderController.text.trim(),
      "profile.bloodGroup": bloodGroupController.text.trim(),
      "profile.emergencyContact": emergencyController.text.trim(),
      "profile.profileImageUrl": imageUrl,

      "profileStatus": "pending",
      "profileReview": {
        "reason": null,
        "reviewedBy": null,
        "reviewedAt": null,
      }
    });

    setState(() => isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile Submitted For Review")),
    );
  }

  Widget _statusWidget() {
    if (profileStatus == "pending") {
      return const Text("⏳ Profile Under Review",
          style: TextStyle(color: Colors.orange));
    }
    if (profileStatus == "approved") {
      return const Text("✅ Profile Approved",
          style: TextStyle(color: Colors.green));
    }
    if (profileStatus == "rejected") {
      return Text("❌ Rejected: ${rejectionReason ?? ""}",
          style: const TextStyle(color: Colors.red));
    }
    return const SizedBox();
  }

  Widget _editableField(String label, TextEditingController controller,
      {TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Enter $label";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _readOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        initialValue: value,
        enabled: false,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              _statusWidget(),
              const SizedBox(height: 20),

              _editableField("Full Name", nameController),
              _readOnlyField("Email", email),
              _readOnlyField("Department", department),
              _editableField("Phone", phoneController,
                  type: TextInputType.phone),
              _editableField("Date of Birth", dobController),
              _editableField("Address", addressController),
              _editableField("Gender", genderController),
              _editableField("Blood Group", bloodGroupController),
              _editableField("Emergency Contact", emergencyController),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: isLoading ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                    color: Colors.white)
                    : const Text("Submit Profile"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}