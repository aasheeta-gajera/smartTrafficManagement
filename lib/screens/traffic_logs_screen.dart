import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class TrafficLogsScreen extends StatefulWidget {
  @override
  _TrafficLogsScreenState createState() => _TrafficLogsScreenState();
}

class _TrafficLogsScreenState extends State<TrafficLogsScreen> {
  final DatabaseReference _dbRef =
  FirebaseDatabase.instance.ref().child('traffic_logs');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Traffic Logs')),
      body: StreamBuilder(
        stream: _dbRef.onValue,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.snapshot.value == null)
            return Center(child: Text("No traffic logs found"));

          final dataMap = Map<dynamic, dynamic>.from(
              snapshot.data!.snapshot.value as Map);
          final entries = dataMap.entries.toList().reversed.toList();

          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              final data = Map<String, dynamic>.from(entry.value);

              final currentRoadGreen = data['current_road_green'] ?? 'Unknown';
              final emergencyOverride = data['emergency_override'] ?? false;
              final roadAVehicleCount = data['road_a_vehicle_count'] ?? 0;
              final roadBVehicleCount = data['road_b_vehicle_count'] ?? 0;
              final timestamp = data['timestamp'] ?? 'Unknown time';

              return Card(
                margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                child: ListTile(
                  leading: Icon(Icons.traffic, color: Colors.orange),
                  title: Text('Current Green: $currentRoadGreen'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Emergency Override: $emergencyOverride'),
                      Text('Road A Vehicles: $roadAVehicleCount'),
                      Text('Road B Vehicles: $roadBVehicleCount'),
                      Text('Timestamp: $timestamp'),
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
