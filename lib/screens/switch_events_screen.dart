import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class SwitchEventsScreen extends StatefulWidget {
  @override
  _SwitchEventsScreenState createState() => _SwitchEventsScreenState();
}

class _SwitchEventsScreenState extends State<SwitchEventsScreen> {
  final DatabaseReference _dbRef =
  FirebaseDatabase.instance.ref().child('switch_events');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Switch Events')),
      body: StreamBuilder(
        stream: _dbRef.onValue,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.snapshot.value == null)
            return Center(child: Text("No data found"));

          final dataMap = Map<dynamic, dynamic>.from(
              snapshot.data!.snapshot.value as Map);
          final entries = dataMap.entries.toList().reversed.toList();

          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              final data = Map<String, dynamic>.from(entry.value);

              final from = data['from'] ?? 'Unknown';
              final to = data['to'] ?? 'Unknown';
              final timestamp = data['timestamp'] ?? 'Unknown';

              return ListTile(
                leading: Icon(Icons.switch_left),
                title: Text('From: $from → To: $to'),
                subtitle: Text('Timestamp: $timestamp'),
              );
            },
          );
        },
      ),
    );
  }
}
