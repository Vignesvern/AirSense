import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/background_clip.dart';
import '../theme/variables.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: BackgroundWaveClipper(),
          child: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: 510,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ MidnightBlue, MidnightBlue],
                  )),
              child: Container(
                padding: const EdgeInsets.fromLTRB(15, 30, 0,
                    30),
                child: const Text("Profile",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    fontSize: 32,
                  ),
                ),
              )
          ),
        ),
        ListView(
        padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
        children: [
          SizedBox(height: 20,),
          Center(
            child: CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/images/DefaultProfile.jpg'), // Replace with the actual image path or network image
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Aravind",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "9198373821",
            style: TextStyle(
                fontSize: 16,
                color: Colors.white
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "aravindah03011@gmail.com",
            style: TextStyle(
                fontSize: 16,
                color: Colors.white
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 4,
            child: ListTile(
              title: Text('Average Score'),
              subtitle: Text("85.4"),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 4,
            child: ListTile(
              title: Text('Diamonds'),
              subtitle: Text("1240"),
            ),
          ),
        ],
      ),
    ]
    );
  }
}
