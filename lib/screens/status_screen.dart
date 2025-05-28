import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DatabaseReference statusRef = FirebaseDatabase.instance.ref().child('status');

    return Scaffold(
      appBar: AppBar(
        title: Text('Status', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: statusRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info_outline, size: 48, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No status record found',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          final statusData = Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);
          final emergencyUid = statusData['emergency_uid'] ?? 'Unknown';
          final emergencyActive = statusData['emergency_vehicle_active'] ?? false;

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade50,
                  Colors.white,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: emergencyActive ? Colors.red.shade50 : Colors.green.shade50,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              emergencyActive ? Icons.directions_car : Icons.car_rental_outlined,
                              size: 48,
                              color: emergencyActive ? Colors.red : Colors.green,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Emergency Vehicle Status',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue.shade900,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: emergencyActive ? Colors.red.shade50 : Colors.green.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: emergencyActive ? Colors.red.shade200 : Colors.green.shade200,
                              ),
                            ),
                            child: Text(
                              emergencyActive ? 'Active' : 'Inactive',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: emergencyActive ? Colors.red : Colors.green,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Vehicle UID',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  emergencyUid.toString(),
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue.shade900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}