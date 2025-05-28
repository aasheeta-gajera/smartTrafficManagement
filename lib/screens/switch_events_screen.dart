import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';

class SwitchEventsScreen extends StatefulWidget {
  const SwitchEventsScreen({super.key});

  @override
  _SwitchEventsScreenState createState() => _SwitchEventsScreenState();
}

class _SwitchEventsScreenState extends State<SwitchEventsScreen> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('switch_events');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Switch Events', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green.shade50,
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: StreamBuilder(
          stream: _dbRef.onValue,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.switch_left_outlined, size: 48, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'No switch events found',
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
                final entry = entries[index];
                final data = Map<String, dynamic>.from(entry.value);
                final from = data['from'] ?? 'Unknown';
                final to = data['to'] ?? 'Unknown';
                final timestamp = data['timestamp'] ?? 'Unknown';

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
                              color: Colors.green.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(Icons.switch_left, color: Colors.green.shade700, size: 24),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      'Traffic Light Switch',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.green.shade900,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      from,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.green.shade900,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Icon(Icons.arrow_forward, color: Colors.green.shade700),
                                    const SizedBox(width: 16),
                                    Text(
                                      to,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.green.shade900,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Time: $timestamp',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.grey[700],
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