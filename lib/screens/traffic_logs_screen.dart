import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TrafficLogsScreen extends StatefulWidget {
  const TrafficLogsScreen({super.key});

  @override
  _TrafficLogsScreenState createState() => _TrafficLogsScreenState();
}

class _TrafficLogsScreenState extends State<TrafficLogsScreen> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('traffic_logs');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Traffic Logs', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.orange.shade50,
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: StreamBuilder(
          stream: _dbRef.onValue,
          builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${snapshot.error}',
                      style: GoogleFonts.poppins(fontSize: 16, color: Colors.red),
                    ),
                  ],
                ),
              );
            }
            if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.traffic_outlined, size: 48, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'No traffic logs found',
                      style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              );
            }

            final data = snapshot.data!.snapshot.value;
            if (data is! Map) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.warning_amber_outlined, size: 48, color: Colors.orange[400]),
                    const SizedBox(height: 16),
                    Text(
                      'Invalid data format',
                      style: GoogleFonts.poppins(fontSize: 16, color: Colors.orange[700]),
                    ),
                  ],
                ),
              );
            }

            final dataMap = Map<dynamic, dynamic>.from(data);
            final entries = dataMap.entries.toList().reversed.toList();

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                final data = Map<String, dynamic>.from(entry.value);
                final currentRoadGreen = data['current_road_green'] ?? 'Unknown';
                final emergencyOverride = data['emergency_override'] ?? false;
                final roadAVehicleCount = (data['road_a_vehicle_count'] as num?)?.toInt() ?? 0;
                final roadBVehicleCount = (data['road_b_vehicle_count'] as num?)?.toInt() ?? 0;
                final timestamp = data['timestamp'] ?? 'Unknown time';

                final chartData = [
                  ChartData('Road A', roadAVehicleCount.toDouble()),
                  ChartData('Road B', roadBVehicleCount.toDouble()),
                ];

                return TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 300),
                  builder: (context, double opacity, child) {
                    return Opacity(
                      opacity: opacity,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.1),
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
                                      color: Colors.orange.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(Icons.traffic, color: Colors.orange.shade700, size: 24),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Traffic Status',
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.orange.shade900,
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
                                      color: emergencyOverride ? Colors.red.shade50 : Colors.green.shade50,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: emergencyOverride ? Colors.red.shade200 : Colors.green.shade200,
                                      ),
                                    ),
                                    child: Text(
                                      emergencyOverride ? 'Emergency' : 'Normal',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: emergencyOverride ? Colors.red.shade700 : Colors.green.shade700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.traffic_outlined, color: Colors.orange.shade700),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Current Green: $currentRoadGreen',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.orange.shade900,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Vehicle Count',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800],
                                ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: 120,
                                child: SfCartesianChart(
                                  primaryXAxis: CategoryAxis(
                                    labelStyle: GoogleFonts.poppins(fontSize: 12),
                                  ),
                                  primaryYAxis: NumericAxis(
                                    labelStyle: GoogleFonts.poppins(fontSize: 12),
                                    minimum: 0,
                                  ),
                                  tooltipBehavior: TooltipBehavior(enable: true),
                                  series: <CartesianSeries>[
                                    ColumnSeries<ChartData, String>(
                                      dataSource: chartData,
                                      xValueMapper: (ChartData data, _) => data.road,
                                      yValueMapper: (ChartData data, _) => data.count,
                                      name: 'Road A',
                                      color: Colors.orange.shade400,
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                                      animationDuration: 1000,
                                      dataLabelSettings: DataLabelSettings(
                                        isVisible: true,
                                        textStyle: GoogleFonts.poppins(fontSize: 12),
                                      ),
                                    ),
                                    ColumnSeries<ChartData, String>(
                                      dataSource: chartData,
                                      xValueMapper: (ChartData data, _) => data.road,
                                      yValueMapper: (ChartData data, _) => data.count,
                                      name: 'Road B',
                                      color: Colors.blue.shade400,
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                                      animationDuration: 1000,
                                      dataLabelSettings: DataLabelSettings(
                                        isVisible: true,
                                        textStyle: GoogleFonts.poppins(fontSize: 12),
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
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.road, this.count);
  final String road;
  final double count;
}