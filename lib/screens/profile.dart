import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key,});

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<String?>(
        future: fetchUserEmail(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            String? userEmail = snapshot.data;
            if (userEmail != null) {
              String userName = extractUserName(userEmail);
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                    'assets/images/shop_logo.png',
                    fit: BoxFit.cover,
                    height:50,
                  ),  
                  const SizedBox(height: 20),
                    Text(
                      'Welcome, $userName!',
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        signOut(context); // Call sign-out function
                      },
                      child: const Text('Sign Out'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/all_addresses'); // Navigate to All Addresses screen
                      },
                      child: const Text('All Addresses'),
                    ),
                  ],
                ),
              );             
            } else {
            return const Center(child: Text('No user signed in.'));
          }
          }
        },
      ),
    );
  }

  Future<String?> fetchUserEmail() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        return user.email;
      } else {
        return null; // No user signed in
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching user email: $e');
      return null;
    }
  }

  String extractUserName(String email) {
    // Split the email by '@' character and return the first part
    return email.split('@').first;
  }

  void signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate back to the authentication screen (assuming it's named '/authentication')
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/authentication');
    } catch (e) {
      // ignore: avoid_print
      print('Error signing out: $e');
      // Show error message or handle sign-out failure
    }
  }
}

