import 'dart:math';

import 'package:flutter/material.dart';
import '../theme/variables.dart';

void main() {
  runApp(MyApp());
}

class Room {
  final String name;
  final int aqi;
  final int alert;
  final String sensorId;

  Room(
      {required this.name,
        required this.aqi,
        required this.alert,
        required this.sensorId});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Room AQI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: RoomListPage(),
    );
  }
}

class RoomListPage extends StatefulWidget {
  @override
  _RoomListPageState createState() => _RoomListPageState();
}

class _RoomListPageState extends State<RoomListPage> {
  List<Room> rooms = [
    Room(name: 'Living Room', aqi: 50, alert: 100, sensorId: '1234'),
    Room(name: 'Bedroom', aqi: 75, alert: 120, sensorId: '5678'),
    Room(name: 'Kitchen', aqi: 100, alert: 150, sensorId: '91011'),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        height: 100,
        color: purple,
        child: const Align(
          alignment: FractionalOffset(0.05, 0.9),
          child: Padding(
            padding: EdgeInsets.only(bottom: 4.0),
            child: Text(
              "Rooms",
              style: TextStyle(color: Colors.white, fontSize: 24.0),
            ),
          ),
        ),
      ),
      ListView.builder(
        itemCount: rooms.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black87),
              borderRadius: BorderRadius.circular(8.0),
              gradient: _getGradientColors(rooms[index].aqi),
            ),
            margin: index == 0
                ? const EdgeInsets.only(
                top: 90.0, left: 8.0, right: 8.0, bottom: 8.0)
                : const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(rooms[index].name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('AQI: ${rooms[index].aqi}'),
                  Text('Sensor ID: ${rooms[index].sensorId}'),
                  Text('Alert Level: ${rooms[index].alert}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      _editRoom(index);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _deleteRoom(index);
                    },
                  ),
                ],
              ),
              onTap: () {
                // tile selection
              },
            ),
          );
        },
      ),
      Positioned(
        left: MediaQuery.of(context).padding.left + 280,
        top: MediaQuery.of(context).padding.top + 610,
        child: ElevatedButton(onPressed: _addRoom, child: Icon(Icons.add)),
      )
    ]);
  }

  LinearGradient _getGradientColors(int aqi) {
    final int segmentSize = 10;
    Color startColor, endColor;

    if (aqi <= 50) {
      startColor = Colors.lightGreenAccent;
      endColor = Colors.greenAccent;
    } else if (aqi <= 100) {
      startColor = Colors.greenAccent;
      endColor = Colors.yellowAccent;
    } else if (aqi <= 150) {
      startColor = Colors.yellowAccent;
      endColor = Colors.orangeAccent;
    } else {
      startColor = Colors.orangeAccent;
      endColor = Colors.red;
    }

    double percentage = (aqi % segmentSize) / segmentSize;
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color.lerp(endColor, startColor, percentage)!,
        Color.lerp(endColor, startColor, percentage)!,
      ],
    );
  }

  void _addRoom() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        var random = Random();
        String roomName = '';
        String sensorDetails = '';
        int aqiAlertLevel = 0;
        int randomAqi = random.nextInt(201);

        return AlertDialog(
          title: Text('Add New Room'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Room Name'),
                  onChanged: (value) {
                    roomName = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Sensor ID'),
                  onChanged: (value) {
                    sensorDetails = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'AQI Alert Level'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    aqiAlertLevel = int.tryParse(value) ?? 0;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  rooms.add(Room(
                      name: roomName,
                      alert: aqiAlertLevel,
                      aqi: randomAqi,
                      sensorId: sensorDetails));
                });
                Navigator.of(context).pop();
              },
              child: Text('Done'),
            ),
          ],
        );
      },
    );
  }

  void _editRoom(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String roomName = rooms[index].name;
        String sensorDetails = rooms[index].sensorId;
        int aqiAlertLevel = rooms[index].alert;
        int randomAqi = rooms[index].aqi;

        return AlertDialog(
          title: Text('Edit Room'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Room Name'),
                  controller: TextEditingController(text: roomName),
                  onChanged: (value) {
                    roomName = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Sensor ID'),
                  controller: TextEditingController(text: sensorDetails),
                  onChanged: (value) {
                    sensorDetails = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'AQI Alert Level'),
                  keyboardType: TextInputType.number,
                  controller:
                  TextEditingController(text: aqiAlertLevel.toString()),
                  onChanged: (value) {
                    aqiAlertLevel = int.tryParse(value) ?? 0;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  rooms[index] = Room(
                      name: roomName,
                      aqi: randomAqi,
                      alert: aqiAlertLevel,
                      sensorId: sensorDetails);
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteRoom(int index) {
    setState(() {
      rooms.removeAt(index);
    });
  }
}