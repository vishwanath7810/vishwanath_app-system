import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';

class SubTeacherDashboard extends StatelessWidget {
  const SubTeacherDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sub Teacher Dashboard"),
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [

            Container(
              padding: const EdgeInsets.symmetric(vertical: 30),
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.school, size: 60),
                  const SizedBox(height: 10),
                  const Text(
                    "Sub Teacher Panel",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const Divider(),

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

      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection("Users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get(),
        builder: (context, subTeacherSnapshot) {

          if (!subTeacherSnapshot.hasData) {
            return const Center(
                child: CircularProgressIndicator());
          }

          final departmentId =
          subTeacherSnapshot.data!["departmentId"];
          final subject =
          subTeacherSnapshot.data!["subject"];

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Users")
                .where("role", isEqualTo: "student")
                .where("departmentId",
                isEqualTo: departmentId)
                .snapshots(),
            builder: (context, snapshot) {

              if (!snapshot.hasData) {
                return const Center(
                    child: CircularProgressIndicator());
              }

              final students = snapshot.data!.docs;

              if (students.isEmpty) {
                return const Center(
                    child: Text("No Students Found"));
              }

              return ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {

                  final student = students[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    child: ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(student["email"]),
                      subtitle: Text(
                          "Department: ${student["departmentName"]}\nSubject: $subject"),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}