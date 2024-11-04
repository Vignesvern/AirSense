import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

import '../theme/background_clip.dart';
import '../theme/variables.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({Key? key}) : super(key: key);

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  @override
  bool isButtonEnabled = false;
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipPath(
                  clipper: BackgroundWaveClipper(),
                  child:Container(
                      width: MediaQuery.of(context).size.width,
                      height: 400,
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [ MidnightBlue , MidnightBlue],
                      )),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top - 10,
                  left: MediaQuery.of(context).padding.left + 7,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Progress",
                      //_dateString ?? "Loading",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 32,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 50,
                  left: MediaQuery.of(context).padding.left + 140,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Your rank : ",
                      //_dateString ?? "Loading",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 90,
                  left: MediaQuery.of(context).padding.left + 150,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Image.asset('assets/images/IronRank2.png'),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 200,
                  left: MediaQuery.of(context).padding.left + 150,
                  child: Text(
                    "IRON 2",
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold
                    ),
                  )
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 250,
                  left: MediaQuery.of(context).padding.left + 40,
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          width: 300,
                          height: 15,
                          child: LinearProgressIndicator(
                            color: purpleLight,
                            borderRadius: BorderRadius.circular(50),
                            value: 0.5,
                          ),
                        ),
                      ),
                      Text(
                        "50%",
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.white
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top +300,
                  left: MediaQuery.of(context).padding.left + 20,
                  child: Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: [
                          TextSpan(
                              text : "You need ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: white,
                                fontSize: 15
                              )
                          ),
                          TextSpan(
                              text: "250.4 ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: purpleLight,
                                fontSize: 15
                              )
                          ),
                          TextSpan(
                              text: "hours of pure air with an average\n quality over 85% to rank up!",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: white,
                                fontSize: 15
                              )
                          )
                        ]
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "DAILY MISSIONS",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Card(
              elevation: 4.0, // Shadow depth
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Rounded corners
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Use minimum space
                  children: <Widget>[
                    const ListTile(
                      leading: Icon(Icons.double_arrow),
                      title: Text(
                          'ECO CHAMPION I',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: MidnightBlue
                          ),
                      ),
                      subtitle: Text(
                          'Maintain air quality over 80% for 15 hours',
                          style: TextStyle(
                            fontSize: 12
                          ),
                      ),
                    ),
                    Container(
                      width: 250,
                      child: Column(
                        children: [
                          LinearProgressIndicator(
                            color: MidnightBlue,
                            borderRadius: BorderRadius.circular(50),
                            value: 0.5,
                          ),
                          SizedBox(
                            height: 2.4,
                          ),
                          Text(
                            "7.5 hours completed",
                            style: TextStyle(
                                fontSize: 10
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      )
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IgnorePointer(
                          ignoring : !isButtonEnabled,
                          child: SizedBox(
                            width: 140,
                            height: 60,
                            child: ElevatedButton(
                              onPressed: (){
                          
                              },
                              child: Row(
                                children: [
                                  Text(
                                      "Receive 10 "
                                  ),
                                  Icon(
                                    Icons.diamond_outlined,
                                    size: 18,
                                  )
                                ],
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isButtonEnabled ? blueShade1 : purpleLight,
                                elevation: 0
                              )
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 4.0, // Shadow depth
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Rounded corners
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Use minimum space
                  children: <Widget>[
                    const ListTile(
                      leading: Icon(Icons.double_arrow),
                      title: Text(
                        'ECO CHAMPION II',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: MidnightBlue
                        ),
                      ),
                      subtitle: Text(
                        'Maintain air quality over 80% for 20 hours',
                        style: TextStyle(
                            fontSize: 12
                        ),
                      ),
                    ),
                    Container(
                        width: 250,
                        child: Column(
                          children: [
                            LinearProgressIndicator(
                              color: MidnightBlue,
                              borderRadius: BorderRadius.circular(50),
                              value: 0.5,
                            ),
                            SizedBox(
                              height: 2.4,
                            ),
                            Text(
                              "10 hours completed",
                              style: TextStyle(
                                  fontSize: 10
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        )
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IgnorePointer(
                          ignoring : !isButtonEnabled,
                          child: SizedBox(
                            width: 140,
                            height: 60,
                            child: ElevatedButton(
                                onPressed: (){

                                },
                                child: Row(
                                  children: [
                                    Text(
                                        "Receive 15 "
                                    ),
                                    Icon(
                                      Icons.diamond_outlined,
                                      size: 18,
                                    )
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: isButtonEnabled ? blueShade1 : purpleLight,
                                    elevation: 0
                                )
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 4.0, // Shadow depth
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Rounded corners
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Use minimum space
                  children: <Widget>[
                    const ListTile(
                      leading: Icon(Icons.double_arrow),
                      title: Text(
                        'ECO CHAMPION III',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: MidnightBlue
                        ),
                      ),
                      subtitle: Text(
                        'Maintain air quality over 80% for 24 hours',
                        style: TextStyle(
                            fontSize: 12
                        ),
                      ),
                    ),
                    Container(
                        width: 250,
                        child: Column(
                          children: [
                            LinearProgressIndicator(
                              color: MidnightBlue,
                              borderRadius: BorderRadius.circular(50),
                              value: 0.5,
                            ),
                            SizedBox(
                              height: 2.4,
                            ),
                            Text(
                              "20 hours completed",
                              style: TextStyle(
                                  fontSize: 10
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        )
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IgnorePointer(
                          ignoring : !isButtonEnabled,
                          child: SizedBox(
                            width: 140,
                            height: 60,
                            child: ElevatedButton(
                                onPressed: (){

                                },
                                child: Row(
                                  children: [
                                    Text(
                                        "Receive 20 "
                                    ),
                                    Icon(
                                      Icons.diamond_outlined,
                                      size: 18,
                                    )
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: isButtonEnabled ? blueShade1 : purpleLight,
                                    elevation: 0
                                )
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
  }
}
