import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeEditScreen extends StatefulWidget {
  final DocumentSnapshot employee;

  const EmployeeEditScreen({super.key, required this.employee});

  @override
  State<EmployeeEditScreen> createState() =>
      _EmployeeEditScreenState();
}

class _EmployeeEditScreenState extends State<EmployeeEditScreen> {

  late TextEditingController nameController;
  late TextEditingController emailController;
  late String role;

  @override
  void initState() {
    super.initState();

    nameController =
        TextEditingController(text: widget.employee["name"]);
    emailController =
        TextEditingController(text: widget.employee["email"]);
    role = widget.employee["role"];
  }

  Future<void> _updateEmployee() async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.employee.id)
        .update({
      "name": nameController.text.trim(),
      "email": emailController.text.trim(),
      "role": role,
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Employee")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),

            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField(
              value: role,
              items: const [
                DropdownMenuItem(value: "teacher", child: Text("Teacher")),
                DropdownMenuItem(value: "canteen", child: Text("Canteen")),
                DropdownMenuItem(value: "librarian", child: Text("Librarian")),
                DropdownMenuItem(value: "staff", child: Text("Staff")),
              ],
              onChanged: (value) {
                setState(() {
                  role = value!;
                });
              },
              decoration: const InputDecoration(labelText: "Role"),
            ),

            const SizedBox(height: 25),

            ElevatedButton(
              onPressed: _updateEmployee,
              child: const Text("Update"),
            ),
          ],
        ),
      ),
    );
  }
}