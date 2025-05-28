import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';

class EmergencyEventsScreen extends StatelessWidget {
  const EmergencyEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DatabaseReference eventsRef = FirebaseDatabase.instance.ref().child('emergency_events');

    return Scaffold(
      appBar: AppBar(
        title: Text('Emergency Events', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.red.shade50,
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: StreamBuilder<DatabaseEvent>(
          stream: eventsRef.onValue,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.warning_amber_outlined, size: 48, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'No emergency events found',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              );
            }

            final dataMap = Map<dynamic, dynamic>.from(snapshot.data!.snapshot.value as Map);
            final entries = dataMap.entries.toList().reversed.toList();

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final item = Map<String, dynamic>.from(entries[index].value);
                final uid = item['uid'] ?? 'Unknown UID';
                final timestamp = item['timestamp'] ?? 'Unknown';

                return TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 300),
                  builder: (context, double opacity, child) {
                    return Opacity(
                      opacity: opacity,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(Icons.warning, color: Colors.red.shade700, size: 24),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Emergency Vehicle',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.red.shade900,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'UID: $uid',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Time: $timestamp',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.red.shade200),
                                ),
                                child: Text(
                                  'Active',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}