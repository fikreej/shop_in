import 'package:flutter/material.dart';
import 'package:shop_in/screens/all_address.dart';
import 'package:shop_in/screens/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shop_in/screens/tabs.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {'/all_addresses': (context) => const AllAddressesPage(), // Define route for All Addresses page
    // Other routes in your app},
      },
      title: 'Shop_In',
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              return const TabsScreen();
            }

            return const AuthScreen();
          }),
    );
  }
}
