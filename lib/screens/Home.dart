import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget buildCard(BuildContext context, String title, IconData icon, String route, Color gradientStart, Color gradientEnd) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [gradientStart, gradientEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: gradientStart.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tap to view details',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 18, color: Colors.white.withOpacity(0.8)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Text(
          'EmerGoFlow',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          buildCard(
            context,
            'Emergency Events',
            Icons.warning_amber_rounded,
            '/emergency_events',
            const Color(0xFFFF5252),
            const Color(0xFFFF1744),
          ),
          buildCard(
            context,
            'Status',
            Icons.timeline_rounded,
            '/status',
            const Color(0xFF2196F3),
            const Color(0xFF1976D2),
          ),
          buildCard(
            context,
            'Switch Events',
            Icons.toggle_on_rounded,
            '/switch_events',
            const Color(0xFF4CAF50),
            const Color(0xFF388E3C),
          ),
          buildCard(
            context,
            'Traffic Logs',
            Icons.receipt_long_rounded,
            '/traffic_logs',
            const Color(0xFF9C27B0),
            const Color(0xFF7B1FA2),
          ),
        ],
      ),
    );
  }
}


//0xFF833B65
//0xFF672E50