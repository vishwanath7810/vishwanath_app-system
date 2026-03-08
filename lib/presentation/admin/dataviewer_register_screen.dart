import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataViewerRegisterScreen extends StatefulWidget {
  const DataViewerRegisterScreen({super.key});

  @override
  State<DataViewerRegisterScreen> createState() =>
      _DataViewerRegisterScreenState();
}

class _DataViewerRegisterScreenState
    extends State<DataViewerRegisterScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  Future<void> _register() async {

    final existing = await FirebaseFirestore.instance
        .collection("Users")
        .where("role",
        isEqualTo: "dataviewer")
        .get();

    if (existing.docs.isNotEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(
          content:
          Text("DataViewer already exists")));
      return;
    }

    final cred = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password:
        passwordController.text.trim());

    await FirebaseFirestore.instance
        .collection("Users")
        .doc(cred.user!.uid)
        .set({
      "email": emailController.text.trim(),
      "name": nameController.text.trim(),
      "role": "dataviewer",
      "createdAt":
      FieldValue.serverTimestamp(),
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      AppBar(title: const Text("Register DataViewer")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration:
              const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: emailController,
              decoration:
              const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration:
              const InputDecoration(labelText: "Password"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: _register,
                child:
                const Text("Create DataViewer"))
          ],
        ),
      ),
    );
  }
}