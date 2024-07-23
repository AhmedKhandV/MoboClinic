import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MedicalHistoryScreen extends StatefulWidget {
  const MedicalHistoryScreen({super.key});

  @override
  State<MedicalHistoryScreen> createState() => _MedicalHistoryScreenState();
}

class _MedicalHistoryScreenState extends State<MedicalHistoryScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _historyController = TextEditingController();

  User? get user => _auth.currentUser;

  Future<void> _addMedicalHistory() async {
    if (_historyController.text.isNotEmpty) {
      await _firestore.collection('users').doc(user?.uid).collection('medical_history').add({
        'description': _historyController.text,
        'timestamp': Timestamp.now(),
      });
      _historyController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Medical history added successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical History'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _historyController,
              decoration: InputDecoration(
                labelText: 'Add Medical History',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addMedicalHistory,
              child: const Text('Add History'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('users')
                    .doc(user?.uid)
                    .collection('medical_history')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No medical history found.'));
                  }
                  final historyDocs = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: historyDocs.length,
                    itemBuilder: (context, index) {
                      final doc = historyDocs[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(doc['description']),
                          subtitle: Text(doc['timestamp'].toDate().toString()),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
