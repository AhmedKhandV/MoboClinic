import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobo_clinic/HomeScreen.dart';

class PatientDetails extends StatefulWidget {
  const PatientDetails({super.key});

  @override
  State<PatientDetails> createState() => _PatientDetailsState();
}

class _PatientDetailsState extends State<PatientDetails> {
  final formkey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();

  final TextEditingController contactnumbercontroller = TextEditingController();

  final TextEditingController addresscontroller = TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> saveDetails() async {
    if (formkey.currentState?.validate() == true) {
      User? user = auth.currentUser;
      if (user != null) {
        await firestore.collection('users').doc(user.uid).set({
          'First_Name': firstNameController.text,
          'Contact_Number': contactnumbercontroller.text,
          'address': addresscontroller.text,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Details Saved Successfully"),
          ),
        );
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    }
  }
    @override
    Widget build(BuildContext context) {
      return SafeArea(
        child: Scaffold(
          body: Form(
            key: formkey,
            child: ListView(
              children: [
                TextFormField(
                  controller: firstNameController,
                  decoration: const InputDecoration(labelText: 'FirstName'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter your First Name";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: contactnumbercontroller,
                  decoration: const InputDecoration(labelText: 'Contact Number'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter your Contact Number";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: addresscontroller,
                  decoration: const InputDecoration(labelText: "Address"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter Address";
                    }
                    return null;
                  },
                ),
                ElevatedButton(onPressed: saveDetails, child: Text("Save Details")),
              ],
            ),
          ),
        ),
      );
    }
  }

