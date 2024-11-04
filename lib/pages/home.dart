import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:indoor_air_quality_check/pages/dashboard.dart';
import 'package:indoor_air_quality_check/pages/profile.dart';
import 'package:indoor_air_quality_check/pages/progress.dart';
import 'package:indoor_air_quality_check/pages/rooms.dart';
import 'package:line_icons/line_icons.dart';

import '../charts/line_chart.dart';
import '../theme/background_clip.dart';
import '../theme/variables.dart';
import '../widgets/chart_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    Dashboard(),
    ProgressPage(),
    RoomListPage(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: Container(
          color: MidnightBlue,
          height: 80,
          child: GNav(
            rippleColor: MidnightBlue,
            // tab button ripple color when pressed
            hoverColor: BabyBlue,
            // tab button hover color
            gap: 8,
            // the tab button gap between icon and text
            tabs: const [
              GButton(
                icon: LineIcons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.card_membership,
                text: 'Progress',
              ),
              GButton(
                icon: Icons.room_preferences,
                text: 'Rooms',
              ),
              GButton(
                icon: LineIcons.user,
                text: 'Profile',
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
        // floatingActionButton: _selectedIndex==3 ? FloatingActionButton(
        //   onPressed: _addRoom,
        //   tooltip: 'Add Room',
        //   child: Icon(Icons.add),
        // ) : null,
      ),
    );
  }
}
