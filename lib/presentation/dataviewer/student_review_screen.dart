import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentReviewScreen extends StatefulWidget {
  final String studentId;

  const StudentReviewScreen({super.key, required this.studentId});

  @override
  State<StudentReviewScreen> createState() => _StudentReviewScreenState();
}

class _StudentReviewScreenState extends State<StudentReviewScreen> {
  bool isLoading = false;

  Future<void> _approveProfile() async {
    setState(() => isLoading = true);

    await FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.studentId)
        .update({
      "profileStatus": "approved",
      "profileReview": {
        "reason": null,
        "reviewedAt": FieldValue.serverTimestamp(),
      }
    });

    setState(() => isLoading = false);

    Navigator.pop(context);
  }

  Future<void> _rejectProfile() async {
    final reasonController = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Reject Profile"),
          content: TextField(
            controller: reasonController,
            decoration: const InputDecoration(
              hintText: "Enter rejection reason",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (reasonController.text.trim().isEmpty) return;

                await FirebaseFirestore.instance
                    .collection("Users")
                    .doc(widget.studentId)
                    .update({
                  "profileStatus": "rejected",
                  "profileReview": {
                    "reason": reasonController.text.trim(),
                    "reviewedAt": FieldValue.serverTimestamp(),
                  }
                });

                Navigator.pop(context); // close dialog
                Navigator.pop(context); // close screen
              },
              child: const Text("Reject"),
            ),
          ],
        );
      },
    );
  }

  Widget _infoTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 120,
              child: Text("$title:",
                  style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student Profile Review")),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection("Users")
            .doc(widget.studentId)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final profile = data["profile"] ?? {};

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [

                // 🔥 PROFILE IMAGE
                if (profile["profileImageUrl"] != null)
                  CircleAvatar(
                    radius: 60,
                    backgroundImage:
                    NetworkImage(profile["profileImageUrl"]),
                  )
                else
                  const CircleAvatar(
                    radius: 60,
                    child: Icon(Icons.person, size: 40),
                  ),

                const SizedBox(height: 20),

                _infoTile("Email", data["email"] ?? ""),
                _infoTile("Department", data["departmentName"] ?? ""),
                _infoTile("Full Name", profile["fullName"] ?? ""),
                _infoTile("Phone", profile["phone"] ?? ""),
                _infoTile("DOB", profile["dob"] ?? ""),
                _infoTile("Address", profile["address"] ?? ""),
                _infoTile("Gender", profile["gender"] ?? ""),
                _infoTile("Blood Group", profile["bloodGroup"] ?? ""),
                _infoTile("Emergency", profile["emergencyContact"] ?? ""),

                const SizedBox(height: 30),

                if (data["profileStatus"] == "pending")
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                          onPressed:
                          isLoading ? null : _approveProfile,
                          child: const Text("Approve"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          onPressed:
                          isLoading ? null : _rejectProfile,
                          child: const Text("Reject"),
                        ),
                      ),
                    ],
                  )
                else
                  Text(
                    "Already ${data["profileStatus"]}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}