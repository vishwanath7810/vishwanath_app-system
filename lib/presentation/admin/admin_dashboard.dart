import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'department_screen.dart';
import 'employee_management_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
      ),

      // 🔥 DRAWER
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [

            // 🔥 CUSTOM LOGO HEADER
            // 🔥 CUSTOM LOGO HEADER FIXED
            Container(
              padding: const EdgeInsets.symmetric(vertical: 30),
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 140, // increased properly
                    child: Image.asset(
                      "assets/images/logo VT.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Admin Panel",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // ✅ Department
            ListTile(
              leading: const Icon(Icons.apartment),
              title: const Text("Department"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DepartmentScreen(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.badge),
              title: const Text("Employee Management"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EmployeeManagementScreen(),
                  ),
                );
              },
            ),

            const Divider(),

            // ✅ Logout
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () async {
                Navigator.pop(context);
                await AuthService().logout();
              },
            ),
          ],
        ),
      ),

      // 🔥 BODY
      // 🔥 BODY
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

            // ✅ Department Button
            ElevatedButton.icon(
              icon: const Icon(Icons.apartment),
              label: const Text("Department"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DepartmentScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // 🔥 NEW EMPLOYEE SECTION
            ElevatedButton.icon(
              icon: const Icon(Icons.badge),
              label: const Text("Employee Management"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EmployeeManagementScreen(),
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