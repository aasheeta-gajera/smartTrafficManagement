import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';

class TrafficViolationsScreen extends StatefulWidget {
  const TrafficViolationsScreen({super.key});

  @override
  State<TrafficViolationsScreen> createState() => _TrafficViolationsScreenState();
}

class _TrafficViolationsScreenState extends State<TrafficViolationsScreen> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('TrafficViolations');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Traffic Violations',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        leading:  IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios_new_sharp,color: Colors.black,)),
      ),
      body: StreamBuilder(
        stream: _dbRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return Center(
              child: Text(
                'No violations found',
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
              ),
            );
          }

          final dataMap = Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);
          final entries = dataMap.entries.toList().reversed.toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              final data = Map<String, dynamic>.from(entry.value);
              final plate = data['number_plate'] ?? 'Unknown';
              final helmet = data['helmet'] ?? 'Unknown';
              final timestamp = data['timestamp'] ?? 'Unknown';

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: helmet == "Yes" ? Colors.green.shade100 : Colors.red.shade100,
                    child: Icon(
                      helmet == "Yes" ? Icons.check_circle : Icons.warning,
                      color: helmet == "Yes" ? Colors.green : Colors.red,
                    ),
                  ),
                  title: Text(
                    'Plate: $plate',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Helmet: $helmet',
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                      Text(
                        'Time: $timestamp',
                        style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
