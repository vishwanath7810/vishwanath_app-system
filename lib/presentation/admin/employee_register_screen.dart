import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/department_model.dart';

class EmployeeRegisterScreen extends StatefulWidget {
  const EmployeeRegisterScreen({super.key});

  @override
  State<EmployeeRegisterScreen> createState() =>
      _EmployeeRegisterScreenState();
}

class _EmployeeRegisterScreenState
    extends State<EmployeeRegisterScreen> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  String _selectedRole = "teacher";
  String? selectedDeptId;
  String? selectedDeptName;

  bool isLoading = false;

  Future<void> _registerEmployee() async {
    if (selectedDeptId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Select Department")),
      );
      return;
    }

    try {
      setState(() => isLoading = true);

      UserCredential userCredential =
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.uid)
          .set({
        "name": _nameController.text.trim(),
        "email": _emailController.text.trim(),
        "role": _selectedRole,
        "departmentId": selectedDeptId,
        "departmentName": selectedDeptName,
        "createdAt": FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Employee Registered")),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register Employee")),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection("Departments")
            .orderBy("createdAt", descending: true)
            .get(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final departments = snapshot.data!.docs
              .map((doc) => DepartmentModel.fromMap(
            doc.id,
            doc.data() as Map<String, dynamic>,
          ))
              .where((dept) => dept.deletedStatus != true)  // 🔥 FILTER HERE
              .toList();

          if (departments.isEmpty) {
            return const Center(child: Text("No Active Departments"));
          }

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [

                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: "Name"),
                ),

                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                ),

                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: "Password"),
                  obscureText: true,
                ),

                const SizedBox(height: 15),

                DropdownButtonFormField(
                  value: _selectedRole,
                  items: const [
                    DropdownMenuItem(value: "teacher", child: Text("Teacher")),
                    DropdownMenuItem(value: "canteen", child: Text("Canteen")),
                    DropdownMenuItem(value: "librarian", child: Text("Librarian")),
                    DropdownMenuItem(value: "staff", child: Text("Staff")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value!;
                    });
                  },
                  decoration: const InputDecoration(labelText: "Select Role"),
                ),

                const SizedBox(height: 15),

                // 🔥 NEW DEPARTMENT DROPDOWN
                DropdownButtonFormField<String>(
                  value: selectedDeptId,
                  items: departments.map((dept) {
                    return DropdownMenuItem<String>(
                      value: dept.id,
                      child: Text(dept.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    final selected = departments
                        .firstWhere((dept) => dept.id == value);

                    setState(() {
                      selectedDeptId = selected.id;
                      selectedDeptName = selected.name;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: "Assign Department",
                  ),
                ),

                const SizedBox(height: 25),

                ElevatedButton(
                  onPressed: isLoading ? null : _registerEmployee,
                  child: const Text("Register"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}