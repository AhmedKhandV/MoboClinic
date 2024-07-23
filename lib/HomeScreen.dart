import 'package:flutter/material.dart';
import 'package:mobo_clinic/MedicalHistoryScreen.dart';

import 'Appointment.dart';
import 'UpdatePatientDetails.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 6,
        title: Text("Mobo Clinic"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Mobo Clinic',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('Update Information'),
              onTap: () {
                // Handle navigation to Appointments
                Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatePatientDetails()));
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Medical History'),
              onTap: () {
                // Handle navigation to Medical History
                Navigator.push(context, MaterialPageRoute(builder: (context) => MedicalHistoryScreen()));
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Search Doctor',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22.0),
                ),
              ),
              controller: search,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Search Doctor";
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Appointment()),
                );
              },
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.local_hospital, size: 30),
                      SizedBox(width: 10),
                      Text("Make Appointment", style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


