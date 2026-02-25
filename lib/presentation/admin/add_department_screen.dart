import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../services/department_service.dart';

class AddDepartmentScreen extends StatefulWidget {
  const AddDepartmentScreen({super.key});

  @override
  State<AddDepartmentScreen> createState() => _AddDepartmentScreenState();
}

class _AddDepartmentScreenState extends State<AddDepartmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _hodController = TextEditingController();
  final _descriptionController = TextEditingController();

  final DepartmentService _departmentService = DepartmentService();

  bool _isLoading = false;

  Future<void> _addDepartment() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() => _isLoading = true);

      await _departmentService.addDepartment(
        name: _nameController.text.trim(),
        hod: _hodController.text.trim(),
        description: _descriptionController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Department Added Successfully")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
    print("Logged in UID: ${FirebaseAuth.instance.currentUser?.uid}");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Department")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Department Name",
                ),
                validator: (value) =>
                value!.isEmpty ? "Enter department name" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _hodController,
                decoration: const InputDecoration(
                  labelText: "HOD Name",
                ),
                validator: (value) =>
                value!.isEmpty ? "Enter HOD name" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: "Description",
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _addDepartment,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Add Department"),
              )
            ],
          ),
        ),
      ),
    );
  }
}