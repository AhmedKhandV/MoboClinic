import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Appointment extends StatefulWidget {
  const Appointment({super.key});

  @override
  State<Appointment> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  final formkey=GlobalKey<FormState>();
  final TextEditingController problemcontroller=TextEditingController();

  final FirebaseAuth auth=FirebaseAuth.instance;
  final FirebaseFirestore firestore=FirebaseFirestore.instance;

  Future<void> ScheduleAppointement () async
  {
    if(formkey.currentState?.validate()== true)
      {
        User? user=auth.currentUser;
        if(user!=null)
          {
            await firestore.collection('appointments').add({
              'userId':user.uid,
              'problem': problemcontroller.text,
              'status': 'pending',
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Appointment Scheduled")));
            //navigate if want
          }
      }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: formkey,
          child: Column(
            children: [
              TextFormField(
                controller: problemcontroller,
                decoration: InputDecoration(
                  labelText: "Describe your problem",
                  border: OutlineInputBorder(),
                ),
                validator: (value)
                {
                  if(value==null || value.isEmpty)
                    {
                      return "Describe your problem";
                    }
                  return null;
                },
              ),
              SizedBox(height: 20,),
              ElevatedButton(onPressed: ScheduleAppointement, child: Text("Schedule")),
            ],
          ),
        ),
      ),
    );
  }
}
