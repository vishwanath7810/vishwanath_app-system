import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/department_service.dart';

class AddDepartmentScreen extends StatefulWidget {
  const AddDepartmentScreen({super.key});

  @override
  State<AddDepartmentScreen> createState() =>
      _AddDepartmentScreenState();
}

class _AddDepartmentScreenState
    extends State<AddDepartmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _hodController = TextEditingController();
  final _descriptionController =
  TextEditingController();

  final DepartmentService _departmentService =
  DepartmentService();

  bool _isLoading = false;

  Future<void> _addDepartment() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() => _isLoading = true);

      await FirebaseFirestore.instance
          .collection("Departments")
          .add({
        "name": _nameController.text.trim(),
        "hod": _hodController.text.trim(),
        "description":
        _descriptionController.text.trim(),
        "deletedStatus": false,
        "createdAt":
        FieldValue.serverTimestamp(),
      });

      if (mounted) {
        Navigator.pop(context);

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(15),
            ),
            content: Column(
              mainAxisSize:
              MainAxisSize.min,
              children: const [
                Icon(Icons.check_circle,
                    color: Colors.green,
                    size: 60),
                SizedBox(height: 15),
                Text(
                  "Department Created Successfully 🎉",
                  textAlign:
                  TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed:
                Navigator.of(context).pop,
                child: const Text("OK"),
              )
            ],
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      AppBar(title: const Text("Add Department")),
      body: Padding(
        padding:
        const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller:
                _nameController,
                decoration:
                const InputDecoration(
                  labelText:
                  "Department Name",
                ),
                validator: (value) =>
                value!.isEmpty
                    ? "Enter department name"
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller:
                _hodController,
                decoration:
                const InputDecoration(
                  labelText: "HOD Name",
                ),
                validator: (value) =>
                value!.isEmpty
                    ? "Enter HOD name"
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller:
                _descriptionController,
                decoration:
                const InputDecoration(
                  labelText:
                  "Description",
                ),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                style: ElevatedButton
                    .styleFrom(
                  padding:
                  const EdgeInsets
                      .symmetric(
                      vertical: 14),
                ),
                onPressed: _isLoading
                    ? null
                    : _addDepartment,
                child: _isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child:
                  CircularProgressIndicator(
                    strokeWidth: 2,
                    color:
                    Colors.white,
                  ),
                )
                    : const Text(
                    "Add Department"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}