import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/department_model.dart';
import '../../services/department_service.dart';
import 'add_department_screen.dart';

class DepartmentScreen extends StatelessWidget {
  const DepartmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DepartmentService departmentService = DepartmentService();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Departments"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddDepartmentScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<DepartmentModel>>(
        stream: departmentService.getDepartments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No Departments Found"),
            );
          }

          final departments = snapshot.data!;

          return ListView.builder(
            itemCount: departments.length,
            itemBuilder: (context, index) {
              final dept = departments[index];

              return Card(
                margin: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                child: ListTile(
                  title: Text(dept.name),
                  subtitle: Text("HOD: ${dept.hod}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _showEditDialog(context, dept);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection("Departments")
                              .doc(dept.id)
                              .delete();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showEditDialog(BuildContext context, DepartmentModel dept) {
    final nameController = TextEditingController(text: dept.name);
    final hodController = TextEditingController(text: dept.hod);
    final descController = TextEditingController(text: dept.description);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Department"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: hodController,
                decoration: const InputDecoration(labelText: "HOD"),
              ),
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: "Description"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Update"),
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection("Departments")
                  .doc(dept.id)
                  .update({
                "name": nameController.text.trim(),
                "hod": hodController.text.trim(),
                "description": descController.text.trim(),
              });

              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}