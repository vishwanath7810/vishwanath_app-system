import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubTeacherRegisterScreen extends StatefulWidget {
  const SubTeacherRegisterScreen({super.key});

  @override
  State<SubTeacherRegisterScreen> createState() =>
      _SubTeacherRegisterScreenState();
}

class _SubTeacherRegisterScreenState
    extends State<SubTeacherRegisterScreen> {

  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final designationController = TextEditingController();
  final subjectController = TextEditingController();
  final qualificationController = TextEditingController();

  bool isLoading = false;

  Future<void> _registerSubTeacher() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() => isLoading = true);

      final currentTeacher =
      FirebaseAuth.instance.currentUser!;

      final teacherDoc = await FirebaseFirestore.instance
          .collection("Users")
          .doc(currentTeacher.uid)
          .get();

      final departmentId =
      teacherDoc["departmentId"];
      final departmentName =
      teacherDoc["departmentName"];

      // Create Auth account
      final cred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await FirebaseFirestore.instance
          .collection("Users")
          .doc(cred.user!.uid)
          .set({
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "role": "sub_teacher",
        "departmentId": departmentId,
        "departmentName": departmentName,
        "designation": designationController.text.trim(),
        "subject": subjectController.text.trim(),
        "qualification": qualificationController.text.trim(),
        "createdBy": currentTeacher.uid,
        "createdAt": FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Sub Teacher Registered Successfully")),
      );

      Navigator.pop(context);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    designationController.dispose();
    subjectController.dispose();
    qualificationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Sub Teacher"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [

              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                    labelText: "Teacher Name"),
                validator: (v) =>
                v!.isEmpty ? "Enter name" : null,
              ),

              TextFormField(
                controller: emailController,
                decoration:
                const InputDecoration(labelText: "Email"),
                validator: (v) =>
                v!.isEmpty ? "Enter email" : null,
              ),

              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration:
                const InputDecoration(labelText: "Password"),
                validator: (v) =>
                v!.length < 6
                    ? "Minimum 6 characters"
                    : null,
              ),

              TextFormField(
                controller: designationController,
                decoration:
                const InputDecoration(labelText: "Designation"),
              ),

              TextFormField(
                controller: subjectController,
                decoration:
                const InputDecoration(labelText: "Subject"),
              ),

              TextFormField(
                controller: qualificationController,
                decoration:
                const InputDecoration(labelText: "Qualification"),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed:
                isLoading ? null : _registerSubTeacher,
                child: isLoading
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : const Text("Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}