import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../authentication/auth.dart';
import '../driver_check_history.dart';
import '../model/user_model.dart';
import '../pages/contact _information.dart';
import '../pages/generalsetting.dart';
import '../pages/loginpage.dart';
import 'gird_driver.dart';

class DriverDashboard extends StatefulWidget {
  const DriverDashboard({Key? key}) : super(key: key);

  @override
  State<DriverDashboard> createState() => _DriverDashboardState();
}

class _DriverDashboardState extends State<DriverDashboard> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());

      setState(() {});
    });
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  Widget tapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        return DriverDashboard();
        break;

      case 1:
        return DriverCheckHistory();
        break;

      default:
        return SettingsScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        key: _globalKey,
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                  decoration: const BoxDecoration(color: Colors.white60),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      Text(
                        "${loggedInUser.firstName} ${loggedInUser.lastName}",
                        style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600)),
                      Text(
                        "${loggedInUser.email}",
                        style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600)),
                       /* SizedBox(
                      height: 50,
                      child:
                      Image.network(FirebaseAuth.instance.currentUser!.photoURL!,
                            ),
                        ),

                       Text("${FirebaseAuth.instance.currentUser!.displayName}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    Text("${FirebaseAuth.instance.currentUser!.email}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),),*/
                    ],
                  )),
              ListTile(
                leading: const Icon(
                  Icons.home,
                  color: Colors.black,
                ),
                title: const Text(
                  'Home',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const DriverDashboard())),
                // Update the state of the app
                // ...
                // Then close the drawer
              ),
              const Divider(
                thickness: 2,
              ),
              ListTile(
                leading: const Icon(
                  Icons.access_time_outlined,
                  color: Colors.black,
                ),
                title: const Text(
                  'Check History',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              const Divider(
                thickness: 2,
              ),
              ListTile(
                leading: const Icon(
                  Icons.settings,
                  color: Colors.black,
                ),
                title: const Text(
                  'General Settings',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SettingsScreen()));
                },
              ),
              const Divider(
                thickness: 2,
              ),
              ListTile(
                leading: const Icon(
                  Icons.person_outline,
                  color: Colors.black,
                ),
                title: const Text(
                  'Account Settings',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
               const Divider(
                thickness: 2,
              ),
               ListTile(
                leading: const Icon(
                  Icons.chat_bubble_outline,
                  color: Colors.black,
                ),
                title: const Text(
                  'Customer Support',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  // Update the state of the app
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ContactInformation()));
                  // Then close the drawer
                },
              ),
              const Divider(
                thickness: 2,
              ),
              ListTile(
                leading: const Icon(
                  Icons.contact_support_outlined,
                  color: Colors.black,
                ),
                title: const Text(
                  'About',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              const Divider(
                thickness: 2,
              ),
              ListTile(
                leading: const Icon(
                  Icons.exit_to_app,
                  color: Colors.black,
                ),
                title: const Text(
                  'SignOut',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () async {
                  await Auth().signOut();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Signin()));
                },
              ),
              const Divider(
                thickness: 2,
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //meue or drawer
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white60,
                          borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.all(5),
                      child: IconButton(
                        onPressed: () {
                          _globalKey.currentState?.openDrawer();
                        },
                        icon: const Icon(Icons.menu),
                        color: Colors.black,
                      ),
                    ),
                    //Notification
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.white60,
                            borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.all(5),
                        child: IconButton(
                            onPressed: () async {
                              await Auth().signOut();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Signin()));
                            },
                            icon: const Icon(
                              Icons.notifications,
                              color: Colors.black,
                            ))),
                  ],
                ),

                //greeting
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome",
                        style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600)),

                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "${loggedInUser.firstName} ${loggedInUser.lastName}",
                        style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600)),
                      // Text(
                      //   "${loggedInUser.email}",
                      //   style: GoogleFonts.openSans(
                      //       textStyle: const TextStyle(
                      //           color: Colors.black,
                      //           fontSize: 16,
                      //           fontWeight: FontWeight.w600)),
                      // ),
                      // Text(
                      //   "${loggedInUser.phone}",
                      //   style: GoogleFonts.openSans(
                      //       textStyle: const TextStyle(
                      //           color: Colors.black,
                      //           fontSize: 16,
                      //           fontWeight: FontWeight.w600)),
                      // ),
                      // Text(
                      //   "${loggedInUser.role}",
                      //   style: GoogleFonts.openSans(
                      //       textStyle: const TextStyle(
                      //           color: Colors.black,
                      //           fontSize: 16,
                      //           fontWeight: FontWeight.w600)),
                      // ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Choose A Service",
                  style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w600)),

                /* const SizedBox(
                  height: 10,
                ),*/
                GridDriver()
              ],
            ),
          ),
        ),

        );
  }
}
