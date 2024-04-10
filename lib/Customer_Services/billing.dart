import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/user_model.dart';
import '../request_tow_order.dart';
import 'Searching.dart';

class Billing extends StatefulWidget {
  final String carModel;
  final String carPlateNo;
  final String remarks;
  final String pickUpLocation;
  final String dropOffLocation;

  Billing({
    required this.carModel,
    required this.carPlateNo,
    required this.remarks,
    required this.pickUpLocation,
    required this.dropOffLocation,
  });

  // const Billing({Key? key}) : super(key: key);

  @override
  State<Billing> createState() => _BillingState();
}

// void calculateDistance() {
//   double distanceInMeters = Geolocator.distanceBetween(AssistantMethods().pickAddLong, pickAddLat, dropAddLat, dropAddLong);
//   print(distanceInMeters);
// }

class _BillingState extends State<Billing> {

  final _firebaseAuth = FirebaseAuth.instance;
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

  @override
  Widget build(BuildContext context) {
    final confirmButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                (context),
                MaterialPageRoute(builder: (context) => search()),
                (route) => true);
          },
          child: const Text(
            "Confirm",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        elevation: 0,
        title: const Text(
          "Tow Details",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: [
                Text('Name:${loggedInUser.firstName} ${loggedInUser.lastName}',
                  style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                Text('Phone Number: ${loggedInUser.phone}', style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
                Text('Pick up location: Thankot'),
                Text('Drop off location: Patan'),
                Text('Vechile model: Ford'),
                Text('Vehicle Number Plate: A AB 1234'),
                Text('Remarks: Car problem'),
                Text('Date: '),
                Text('Time: '),
                // Text('distance: '+ distanceInMeters.toString()),
                confirmButton,
              ],
            ),
          ),
        ),
      ),
    );
  }


}
