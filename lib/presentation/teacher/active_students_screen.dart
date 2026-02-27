import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ActiveStudentsScreen extends StatelessWidget {
  const ActiveStudentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Active Students"),
      ),

      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection("Users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get(),
        builder: (context, teacherSnapshot) {

          if (!teacherSnapshot.hasData) {
            return const Center(
                child: CircularProgressIndicator());
          }

          final teacherDeptId =
          teacherSnapshot.data!["departmentId"];

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Users")
                .where("role", isEqualTo: "student")
                .where("departmentId",
                isEqualTo: teacherDeptId)
                .where("isActive", isEqualTo: true)
                .snapshots(),
            builder: (context, snapshot) {

              if (!snapshot.hasData) {
                return const Center(
                    child: CircularProgressIndicator());
              }

              final students = snapshot.data!.docs;

              if (students.isEmpty) {
                return const Center(
                    child: Text("No Active Students"));
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
                          "Active in ${student["departmentName"]}"),
                      trailing: const Icon(
                        Icons.circle,
                        color: Colors.green,
                        size: 12,
                      ),
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