import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:real_time_chart/real_time_chart.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../theme/background_clip.dart';
import '../theme/variables.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  late List<_SensorData> sensorDataList = [];
  late List<_SensorData> lastDataList = [];

  late double ppm = 0.0;
  late double co = 0.0;
  late double methane = 0.0;
  late double ammonia = 0.0;
  late double temp = 0.0;
  late double humid = 0.0;
  late String PPM = "";

  late final streamData = FirebaseDatabase.instance.ref().child('UsersData').child('hpS18ECifIcqyTDPNDw84Cjd5ck2').child('readings').child('air').onValue;

  int selectedIndex = 0;
  late var stream = positiveDataStream(selectedIndex);

  List<String> dropdownItems = [
    'CO2',
    'CO',
    'Methane',
    'Ammonia'
  ];

  @override
  void initState() {
    super.initState();
    sensorDataList.add(_SensorData(DateTime.now(), getValue(selectedIndex)));
    lastDataList.add(_SensorData(DateTime.now(), getValue(selectedIndex)));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: streamData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data?.snapshot.value as Map?;
          if (data == null) {
            return Text(
              'No data',
              style: TextStyle(
                color: white,
                fontSize: 30,
              ),
            );
          }
          ppm = double.parse(data['ppm']);
          co = double.parse(data['co']);
          methane = double.parse(data['methane']);
          ammonia = double.parse(data['ammonia']);
          temp = double.parse(data['temp']);
          humid = double.parse(data['humid']);

          sensorDataList.add(_SensorData(DateTime.now(), getValue(selectedIndex)));

          lastDataList.clear();
          lastDataList.add(_SensorData(DateTime.now(), getValue(selectedIndex)));

          stream = positiveDataStream(selectedIndex);
          PPM = ppm.toStringAsFixed(2);

          print("PPM : $ppm\n");
          print("PPM : $co\n");
          print("PPM : $methane\n");
          print("PPM : $ammonia\n");

          return SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                      children: [
                        ClipPath(
                          clipper: BackgroundWaveClipper(),
                          child: Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              height: 400,
                              decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [purple, purple],
                                  )),
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(15, 30, 0,
                                    30),
                                child: const Text("Dashboard",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 32,
                                  ),
                                ),
                              )
                          ),
                        ),
                        Positioned(
                          top: MediaQuery
                              .of(context)
                              .padding
                              .top + 40,
                          left: MediaQuery
                              .of(context)
                              .padding
                              .left + 10,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Welcome back Aravind!",
                              //_dateString ?? "Loading",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: MediaQuery
                              .of(context)
                              .padding
                              .top + 100,
                          left: MediaQuery
                              .of(context)
                              .padding
                              .left + 137,
                          child: Container(
                            child: Text(
                              "CO2 PPM Score",
                              style: TextStyle(
                                  color: white
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: MediaQuery
                              .of(context)
                              .padding
                              .top + 125,
                          left: MediaQuery
                              .of(context)
                              .padding
                              .left + 120,
                          child: Text(
                              "$PPM",
                              style: TextStyle(
                                color: white,
                                fontSize: 50,
                              ),
                          ),
                        ),
                        Positioned(
                          top: MediaQuery
                              .of(context)
                              .padding
                              .top + 205,
                          left: MediaQuery
                              .of(context)
                              .padding
                              .left + 90,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Quality : ",
                                style: TextStyle(
                                  color: white,
                                  fontSize: 20,
                                ),
                              ),
                              qualityStatus(ppm),
                              // Text(
                              //   "MODERATE",
                              //   style: TextStyle(
                              //     color: Colors.limeAccent,
                              //     fontSize: 20,
                              //   ),
                              // ),
                              IconButton(
                                  onPressed: (){
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context){
                                          return Container(
                                            height: 800,
                                            child: Center(
                                              child : Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Text(
                                                      "Quality Index",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 20
                                                    ),
                                                  ),
                                                  DataTable(
                                                    columns: [
                                                      DataColumn(label: Text(
                                                        'Range(PPM) of CO2',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w500
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      )),
                                                      DataColumn(label: Text(
                                                        'Status',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w500
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      )),
                                                    ],
                                                    rows: [
                                                      DataRow(cells: [
                                                        DataCell(Text('0-50')),
                                                        DataCell(Text('Good')),
                                                      ]),
                                                      DataRow(cells: [
                                                        DataCell(Text('51-100')),
                                                        DataCell(Text('Moderate')),
                                                      ]),
                                                      DataRow(cells: [
                                                        DataCell(Text('101-200')),
                                                        DataCell(Text('Unhealthy')),
                                                      ]),
                                                      DataRow(cells: [
                                                        DataCell(Text('201-251')),
                                                        DataCell(Text('Very Unhealthy')),
                                                      ]),
                                                      DataRow(cells: [
                                                        DataCell(Text('250>')),
                                                        DataCell(Text('Hazardous')),
                                                      ]),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }
                                    );
                                  },
                                  icon: Icon(
                                      Icons.info_outline,
                                      color: Colors.white,
                                  )
                              )
                            ],
                          ),
                        ),
                        Positioned(
                          top: MediaQuery
                              .of(context)
                              .padding
                              .top + 260,
                          left: MediaQuery
                              .of(context)
                              .padding
                              .left + 95,
                          child: ElevatedButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    // Modify the container as per your requirement
                                    height: 800,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                              "Report",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold
                                              ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          // Text(
                                          //   "Current PPM of CO2 is : $ppm\n"
                                          //    "Current PPM of CO is : $co\n"
                                          //       "Current PPM of Methane is : $methane\n"
                                          //       "Current PPM of Ammonia is : $ammonia\n"
                                          //       "Current Temp is : $temp\n"
                                          //       "Current Humidity is : $humid\n",
                                          //   style: TextStyle(fontSize: 14),
                                          //   textAlign: TextAlign.center,
                                          // ),
                                          DataTable(
                                            columns: [
                                              DataColumn(label: Text(
                                                'Components',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500
                                                ),
                                                textAlign: TextAlign.center,
                                              )),
                                              DataColumn(label: Text(
                                                'Value',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500
                                                ),
                                                textAlign: TextAlign.center,
                                              )),
                                            ],
                                            rows: [
                                              DataRow(cells: [
                                                DataCell(Text('CO2')),
                                                DataCell(Text('$ppm PPM')),
                                              ]),
                                              DataRow(cells: [
                                                DataCell(Text('CO')),
                                                DataCell(Text('$co PPM')),
                                              ]),
                                              DataRow(cells: [
                                                DataCell(Text('Methane')),
                                                DataCell(Text('$methane PPM')),
                                              ]),
                                              DataRow(cells: [
                                                DataCell(Text('Ammonia')),
                                                DataCell(Text('$ammonia PPM')),
                                              ]),
                                              DataRow(cells: [
                                                DataCell(Text('Temperture')),
                                                DataCell(Text('$temp C')),
                                              ]),
                                              DataRow(cells: [
                                                DataCell(Text('Humidity')),
                                                DataCell(Text('$humid%')),
                                              ]),
                                            ],
                                          ),
                                      // DataTable(
                                      //   columns: [
                                      //     DataColumn(label: Text(
                                      //         'Range(PPM) of CO2',
                                      //       style: TextStyle(
                                      //           fontSize: 14,
                                      //           fontWeight: FontWeight.w500
                                      //       ),
                                      //       textAlign: TextAlign.center,
                                      //     )),
                                      //     DataColumn(label: Text(
                                      //         'Status',
                                      //         style: TextStyle(
                                      //         fontSize: 14,
                                      //         fontWeight: FontWeight.w500
                                      //     ),
                                      //       textAlign: TextAlign.center,
                                      //     )),
                                      //   ],
                                      //   rows: [
                                      //     DataRow(cells: [
                                      //       DataCell(Text('0-50')),
                                      //       DataCell(Text('Good')),
                                      //     ]),
                                      //     DataRow(cells: [
                                      //       DataCell(Text('51-100')),
                                      //       DataCell(Text('Moderate')),
                                      //     ]),
                                      //     DataRow(cells: [
                                      //       DataCell(Text('101-200')),
                                      //       DataCell(Text('Unhealthy')),
                                      //     ]),
                                      //     DataRow(cells: [
                                      //       DataCell(Text('201-251')),
                                      //       DataCell(Text('Very Unhealthy')),
                                      //     ]),
                                      //     DataRow(cells: [
                                      //       DataCell(Text('250>')),
                                      //       DataCell(Text('Hazardous')),
                                      //     ]),
                                      //     ],
                                      //   ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Text(
                              "Generate detailed report",
                              style: TextStyle(
                                  color: purple
                              ),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  purpleLight),
                              elevation: MaterialStateProperty.all(0),
                            ),
                          ),
                        )
                        // Center(
                        //   child: Text(_timeString ?? "Loading", style: TextStyle(fontSize: 24)),
                        // ),
                      ]
                  ),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(15, 10, 10, 10),
                        child: Text(
                          "Realtime Graphs",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                            fontSize: 25,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            height: 50,
                            width: 154,
                            child: DropdownButton(
                              value: selectedIndex == -1 ? null : selectedIndex,
                              hint: const Text('Select an option'),
                              items: List.generate(
                                dropdownItems.length,
                                    (index) => DropdownMenuItem(
                                  value: index,
                                  child: Text(dropdownItems[index]),
                                ),
                              ),
                              onChanged: (index) {
                                setState(() {
                                  selectedIndex = index!;
                                  stream = positiveDataStream(selectedIndex);
                                  sensorDataList.clear();
                                });
                              },
                              alignment: Alignment.center,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 270,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SfCartesianChart(
                          primaryXAxis: const DateTimeAxis(
                            isVisible: false,
                            labelIntersectAction:
                            AxisLabelIntersectAction.rotate45,
                          ),
                          primaryYAxis: const NumericAxis(
                            minimum: 0,
                            maximum: 200,
                            interval: 50,
                          ),
                          series: <LineSeries<_SensorData, DateTime>>[
                          LineSeries<_SensorData, DateTime>(
                              dataSource: sensorDataList,
                              xValueMapper: (_SensorData data, _) => data.time,
                              yValueMapper: (_SensorData data, _) => data.value,
                              dataLabelSettings: DataLabelSettings(isVisible: false),
                            ),
                            LineSeries<_SensorData, DateTime>(
                              dataSource: lastDataList,
                              xValueMapper: (_SensorData data, _) => data.time,
                              yValueMapper: (_SensorData data, _) => data.value,
                              // Set data label settings only for the current data point
                              dataLabelSettings:
                              DataLabelSettings(isVisible: true),
                            ),
                          ],
                        ),
                      ),
                  )
                ]
            ),
          );
        }
        if (snapshot.hasError) {
          print(snapshot.error.toString());
          return Text(snapshot.error.toString());
        }
        return Text('....');
      }
     );
  }

  Widget qualityStatus(double x){
    if(x<50) {
      return Text(
        "GOOD",
        style: TextStyle(
          color: Colors.greenAccent,
          fontSize: 20,
        ),
      );
    }
    else if(x>50 && x<100){
      return Text(
        "MODERATE",
        style: TextStyle(
          color: Colors.limeAccent,
          fontSize: 20,
        ),
      );
    }
    else if(x>100 && x<200){
      return Text(
        "UNHEALTHY",
        style: TextStyle(
          color: Colors.orangeAccent,
          fontSize: 20,
        ),
      );
    }
    else if(x>200 && x<250){
      return Text(
        "VERY UNHEALTHY",
        style: TextStyle(
          color: Colors.deepOrange,
          fontSize: 20,
        ),
      );
    }
    else{
      return Text(
        "HAZARDOUS",
        style: TextStyle(
          color: Colors.red,
          fontSize: 20,
        ),
      );
    }
  }

  Stream<double> positiveDataStream(int x) {
    if(x==0) {
      return Stream.periodic(const Duration(milliseconds: 1000), (_) {
      return ppm;
    }).asBroadcastStream();
    }
    if(x==1) {
      return Stream.periodic(const Duration(milliseconds: 1000), (_) {
      return co;
    }).asBroadcastStream();
    }
    if(x==2) {
      return Stream.periodic(const Duration(milliseconds: 1000), (_) {
      return methane;
    }).asBroadcastStream();
    }
    if(x==3) {
      return Stream.periodic(const Duration(milliseconds: 1000), (_) {
      return ammonia;
    }).asBroadcastStream();
    }
    return Stream.periodic(const Duration(milliseconds: 1000), (_) {
      return 200.0;
    }).asBroadcastStream();
  }

  double getValue(int index) {
    switch (index) {
      case 0:
        return ppm;
      case 1:
        return co;
      case 2:
        return methane;
      case 3:
        return ammonia;
      default:
        return 0.0;
    }
  }
}

class _SensorData {
  final DateTime time;
  final double value;

  _SensorData(this.time, this.value);
}




