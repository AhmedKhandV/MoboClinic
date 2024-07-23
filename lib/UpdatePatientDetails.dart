import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UpdatePatientDetails extends StatefulWidget {
  const UpdatePatientDetails({super.key});

  @override
  State<UpdatePatientDetails> createState() => _UpdatePatientDetailsState();
}

class _UpdatePatientDetailsState extends State<UpdatePatientDetails> {
  final form=GlobalKey<FormState>();
  final TextEditingController firstNamecontroller=TextEditingController();
  final TextEditingController contactNumbercontroller=TextEditingController();
  final TextEditingController addresscontroller=TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState()
  {
    super.initState();
    loadUserDetails();
  }
  Future<void>loadUserDetails() async
  {
    User? user=auth.currentUser;
    if(user!=null)
      {
        DocumentSnapshot userDoc=await firestore.collection('user').doc(user.uid).get();
        if(userDoc.exists)
          {
            Map<String,dynamic> data=userDoc.data() as Map<String,dynamic>;
            setState(() {
              firstNamecontroller.text=data['First_Name'];
              contactNumbercontroller.text=data['Contact_Number'];
              addresscontroller.text=data['address'];
            });
          }
      }
  }

  Future<void>updateDetails() async
  {
    if(form.currentState!.validate()==true)
      {
        User? user=auth.currentUser;
        if(user!=null)
          {
            await firestore.collection('users').doc(user.uid).update({
              "First_Name":firstNamecontroller.text,
              "Contact_Number":contactNumbercontroller.text,
              "address": addresscontroller.text,
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Details Updated")));

          }
      }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
      body: Form(
        key: form,
        child: Column(
          children: [
            TextFormField(
              controller: firstNamecontroller,
              decoration:InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
              ),
              validator: (value)
              {
                if(value==null || value.isEmpty)
                  {
                    return "Please Enter Your Name";
                  }
                return null;
              },
            ),
            SizedBox(height: 16,),
            TextFormField(
              controller: contactNumbercontroller,
              decoration: InputDecoration(
                labelText: 'Contact Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your contact number";
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: addresscontroller,
              decoration: InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your address";
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateDetails,
              child: Text("Update Details"),
            ),
          ],
        ),
      ),
      
        ),
    );
  }
}
