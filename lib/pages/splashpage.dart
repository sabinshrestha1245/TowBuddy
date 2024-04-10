import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../driver/driver_dashboard.dart';
import '../mechanic/mechanic_dashboard.dart';
import 'homepage.dart';
import 'loginpage.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() {
    return SplashPageState();
  }
}

class SplashPageState extends State<SplashPage> {
  final storage = const FlutterSecureStorage();
  readfromstorage() async {
    String? value = await storage.read(key: "role");
    if (value == "Customer") {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePage()));
      //Homepages
    } else if (value == "Driver") {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => DriverDashboard()));
      //DriverDashboard
    } else if (value == "Mechanic") {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MechanicDashboard()));
      //MechanicDashboard
    } else {
      Navigator.pushNamed(context, "/Signin");
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          readfromstorage();
          //loading
        }
        return const Signin();
      },
    );
  }
}
