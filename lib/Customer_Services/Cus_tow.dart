import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../map/Pickup(map).dart';
import '../request_tow_order.dart';

class Tow extends StatefulWidget {
  const Tow({Key? key}) : super(key: key);

  @override
  State<Tow> createState() => _TowState();
}

class _TowState extends State<Tow> {
  final _firebaseAuth = FirebaseAuth.instance;
  User? user;
  RequestTowOrder requestTowOrder = RequestTowOrder();
  TextEditingController carModelController = TextEditingController();
  TextEditingController carPlateNoController = TextEditingController();
  TextEditingController remarksController = TextEditingController();


  @override
  void initState() {
    super.initState();
    user = _firebaseAuth.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .get()
          .then((value) {
        if (value.exists) {
          // Handle user data here
          // For example:
          // setState(() {
          //   loggedInUser = UserModel.fromMap(value.data());
          // });
        } else {
          print("User data not found");
        }
      }).catchError((error) {
        print("Failed to fetch user data: $error");
      });
    } else {
      print("User is not logged in");
    }
  }

  @override
  Widget build(BuildContext context) {
    //Car Model field
    final carModelField = TextFormField(
      autofocus: false,
      onChanged: (text) {
        requestTowOrder.carModel = text;
      },
      keyboardType: TextInputType.name,
      cursorColor: Colors.black,
      style: TextStyle(color: Colors.black.withOpacity(0.9)),
      validator: (value) {
        RegExp regex = new RegExp(r'^.{,}$');
        if (value!.isEmpty) {
          return ("Car model cannot be Empty");
        }
        if (!regex.hasMatch(value)) {
          return ("Min. 3 Character");
        }
        return null;
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Car Model (Eg.-Ford F150)",
        fillColor: const Color.fromRGBO(217, 217, 217, 0.56),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(
            width: 1,
          ),
        ),
      ),
    );

    //carPlateNo field
    final carPlateNoField = TextFormField(
      controller: carPlateNoController,
      autofocus: false,
      keyboardType: TextInputType.name,
      cursorColor: Colors.black,
      style: TextStyle(color: Colors.black.withOpacity(0.9)),
      validator: (value) {
        if (value!.isEmpty) {
          return ("Car Plate No. cannot be Empty");
        }
        return null;
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Car Plate No. (Eg.-A BE 1234)",
        fillColor: const Color.fromRGBO(217, 217, 217, 0.56),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(
            width: 1,
          ),
        ),
      ),
    );

    //remarks field
    final remarksField = TextFormField(
      controller: remarksController,
      autofocus: false,
      keyboardType: TextInputType.text,
      cursorColor: Colors.black,
      style: TextStyle(color: Colors.black.withOpacity(0.9)),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Remarks (Optional)",
        fillColor: const Color.fromRGBO(217, 217, 217, 0.56),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(
            width: 1,
          ),
        ),
      ),
    );

    //Continue button
    final continueButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          postRequestTowOrderToFirestore();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PickMap(
                carModel: carModelController.text,
                carPlateNo: carPlateNoController.text,
                remarks: remarksController.text,
              ),
            ),
          );
        },
        child: const Text(
          "Continue",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Tow",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Form(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 115,
                    child: Image.asset(
                      'assets/Logo.png',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  SizedBox(width: 10, height: 20),
                  const Text(
                    "Please Enter The Following",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 45),
                  const Text(
                    "Details",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  carModelField,
                  SizedBox(height: 20),
                  carPlateNoField,
                  SizedBox(height: 20),
                  remarksField,
                  SizedBox(height: 20),
                  continueButton,
                  SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void postRequestTowOrderToFirestore() async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance.collection('towDetail');
      if (user != null) {
        final DocumentReference docRef = await firebaseFirestore.add({
          'CarModel': requestTowOrder.carModel,
          'CarPlate': carPlateNoController.text,
          'Remark': remarksController.text,
          'UserId': user!.uid,
        });

        // Retrieve the generated document ID and update it in the database
        final String towId = docRef.id;
        await docRef.update({'TowId': towId});
      } else {
        print("User is not logged in");
      }
    } catch (error) {
      print("Failed to post tow order to Firestore: $error");
    }
  }


}
