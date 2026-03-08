import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/auth_service.dart';
import 'student_review_screen.dart';


class DataViewerDashboard extends StatelessWidget {
  const DataViewerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DataViewer Dashboard"),
      ),

      // 🔥 ADD THIS DRAWER HERE
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [

            // 🔥 LOGO HEADER
            Container(
              padding: const EdgeInsets.symmetric(vertical: 30),
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 140,
                    child: Image.asset(
                      "assets/images/logo VT.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Data Viewer Panel",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const Divider(),

            // ✅ PROFILE
            /*ListTile(
              leading: const Icon(Icons.person),
              title: const Text("My Profile"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const StudentProfileScreen(),
                  ),
                );
              },
            ),*/

            const Divider(),

            // ✅ LOGOUT
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

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .where("role", isEqualTo: "student")
            .snapshots(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No students found"));
          }

          final students = snapshot.data!.docs;

          final submitted = students.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final status = data["profileStatus"] ?? "not_submitted";
            return status == "pending";
          }).toList();

          final notSubmitted = students.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final status = data["profileStatus"] ?? "not_submitted";
            return status == "not_submitted";
          }).toList();

          return ListView(
            children: [

              const Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  "📤 Submitted Profiles",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              if (submitted.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text("No submitted profiles"),
                ),

              ...submitted.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final profile = data["profile"] ?? {};

                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: profile["profileImageUrl"] != null
                        ? CircleAvatar(
                      backgroundImage: NetworkImage(
                          profile["profileImageUrl"]),
                    )
                        : const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    title: Text(data["email"] ?? "No Email"),
                    subtitle: Text(profile["fullName"] ?? "No Name"),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              StudentReviewScreen(studentId: doc.id),
                        ),
                      );
                    },
                  ),
                );
              }),

              const SizedBox(height: 20),

              const Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  "📄 Not Submitted",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              if (notSubmitted.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text("All students submitted profiles"),
                ),

              ...notSubmitted.map((doc) {
                final data = doc.data() as Map<String, dynamic>;

                return Card(
                  color: Colors.grey.shade200,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.person_outline),
                    ),
                    title: Text(data["email"] ?? "No Email"),
                    subtitle: const Text("Profile not submitted"),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}