import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'add_department_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
      ),

      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Text(
                "Admin Menu",
                style: TextStyle(fontSize: 18),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () async {
                await AuthService().logout();
              },
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(
              child: Text(
                "Admin Control Panel",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // 🔥 ADD DEPARTMENT BUTTON
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text("Add Department"),
              style: ElevatedButton.styleFrom(
                padding:
                const EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                    const AddDepartmentScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}