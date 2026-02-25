import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/auth_service.dart';
import '../../models/department_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final AuthService authService = AuthService();

  String? selectedDeptId;
  String? selectedDeptName;

  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedDeptId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a department")),
      );
      return;
    }

    try {
      setState(() => isLoading = true);

      await authService.registerStudent(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        departmentId: selectedDeptId!,
        departmentName: selectedDeptName!,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registration Successful")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student Registration")),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection("Departments")
            .orderBy("createdAt", descending: true)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator());
          }

          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return const Center(
                child: Text("No Departments Available"));
          }

          final departments = snapshot.data!.docs
              .map((doc) => DepartmentModel.fromMap(
            doc.id,
            doc.data() as Map<String, dynamic>,
          ))
              .toList();

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                        labelText: "Email"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter email";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        labelText: "Password"),
                    validator: (value) {
                      if (value == null ||
                          value.length < 6) {
                        return "Password must be 6+ characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),

                  /// 🔥 FIXED DROPDOWN
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
                          .firstWhere(
                              (dept) => dept.id == value);

                      setState(() {
                        selectedDeptId = selected.id;
                        selectedDeptName =
                            selected.name;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: "Select Department",
                    ),
                  ),

                  const SizedBox(height: 25),

                  ElevatedButton(
                    onPressed:
                    isLoading ? null : _register,
                    child: isLoading
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child:
                      CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : const Text("Register"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}