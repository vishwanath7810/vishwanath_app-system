import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      AppBar(title: const Text("Student Dashboard")),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
                child: Text("Student Menu")),
            ListTile(
              title: const Text("Logout"),
              onTap: () async {
                await AuthService().logout();
              },
            )
          ],
        ),
      ),
      body: const Center(
          child: Text("Welcome Student")),
    );
  }
}