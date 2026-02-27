import 'package:flutter/material.dart';
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
        centerTitle: true,
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
        stream: departmentService.getActiveDepartments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No Departments Found",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final departments = snapshot.data!;

          return ListView.builder(
            itemCount: departments.length,
            itemBuilder: (context, index) {
              final dept = departments[index];

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(
                    dept.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("HOD: ${dept.hod}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit,
                            color: Colors.blue),
                        onPressed: () {
                          _showEditDialog(
                              context, dept, departmentService);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete,
                            color: Colors.red),
                        onPressed: () {
                          _showDeleteDialog(
                              context, dept.id, departmentService);
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

  /// 🔥 SUCCESS DIALOG
  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle,
                color: Colors.green, size: 60),
            const SizedBox(height: 15),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  /// 🔥 DELETE
  void _showDeleteDialog(BuildContext context, String id,
      DepartmentService service) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text(
            "Are you sure you want to delete this department?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () async {
              Navigator.pop(context);
              await service.softDeleteDepartment(id);
              _showSuccessDialog(
                  context, "Department Deleted Successfully 🗑️");
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  /// 🔥 EDIT
  void _showEditDialog(BuildContext context, DepartmentModel dept,
      DepartmentService service) {
    final nameController =
    TextEditingController(text: dept.name);
    final hodController =
    TextEditingController(text: dept.hod);
    final descController =
    TextEditingController(text: dept.description);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Department"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration:
                const InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: hodController,
                decoration:
                const InputDecoration(labelText: "HOD"),
              ),
              TextField(
                controller: descController,
                decoration:
                const InputDecoration(
                    labelText: "Description"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              await service.updateDepartment(
                id: dept.id,
                name: nameController.text.trim(),
                hod: hodController.text.trim(),
                description:
                descController.text.trim(),
              );

              Navigator.pop(context);

              _showSuccessDialog(
                  context, "Department Updated Successfully ✏️");
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }
}