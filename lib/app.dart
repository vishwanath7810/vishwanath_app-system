import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'providers/auth_provider.dart';
import 'presentation/auth/login_screen.dart';
import 'presentation/admin/admin_dashboard.dart';
import 'presentation/student/student_dashboard.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Vishwanath App",
      home: authState.when(
        data: (user) {
          if (user == null) {
            return const LoginScreen();
          }

          return RoleBasedRouter(user: user);
        },
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (_, __) => const LoginScreen(),
      ),
    );
  }
}

class RoleBasedRouter extends StatelessWidget {
  final User user;

  const RoleBasedRouter({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection("Users")
          .doc(user.uid)
          .get(),
      builder: (context, snapshot) {
        // Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // If document doesn't exist
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Scaffold(
            body: Center(
              child: Text(
                "User profile not found.\nContact Admin.",
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final data = snapshot.data!.data();

        if (data == null) {
          return const Scaffold(
            body: Center(child: Text("User data is empty.")),
          );
        }

        // 🔥 SAFE ROLE EXTRACTION
        final role =
        (data["role"] ?? "").toString().trim().toLowerCase();

        print("Logged in role: $role");

        // Role Routing
        if (role == "admin") {
          return const AdminDashboard();
        } else if (role == "student") {
          return const StudentDashboard();
        } else {
          return Scaffold(
            body: Center(
              child: Text(
                "Invalid role assigned: $role",
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }
      },
    );
  }
}