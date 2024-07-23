import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DoctorDashboard extends StatefulWidget {
  const DoctorDashboard({super.key});

  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  final FirebaseFirestore firestore= FirebaseFirestore.instance;

  Future<void> setAppointment(String appointmentId,DateTime date) async
  {
    await firestore.collection('appointments').doc(appointmentId).update({
      'appointmentDate':date,
      'status':'scheduled',
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Appointment Date set")));

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Doctor Dashboard"),
        ),
        body: StreamBuilder(
          stream: firestore.collection('appointments').where('status', isEqualTo: 'pending').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text("No pending appointments"));
            }
            return ListView(
              children: snapshot.data!.docs.map((doc) {
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                return ListTile(
                  title: Text(data['problem']),
                  subtitle: Text("User ID: ${data['userId']}"),
                  trailing: ElevatedButton(
                    onPressed: () async {
                      DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (selectedDate != null) {
                        setAppointment(doc.id, selectedDate);
                      }
                    },
                    child: Text("Set Appointment Date"),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}