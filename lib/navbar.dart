import 'package:alpha_mobile/account.dart';
import 'package:alpha_mobile/calendar.dart';
import 'package:alpha_mobile/home.dart';
import 'package:alpha_mobile/login.dart';
import 'package:alpha_mobile/messages.dart';
import 'package:alpha_mobile/notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _currIndex = 0;

  final GlobalKey<NavigatorState> firstKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> secondKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> thirdKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> fourthKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> fifthKey = GlobalKey<NavigatorState>();

  final tabs = [
    PropertiesPage(),
    MessagesPage(),
    NotificationsPage(),
    CalendarPage(),
    LoginPage()
  ];

  @override
  Widget build(BuildContext context) {
    final tabKeys = [firstKey, secondKey, thirdKey, fourthKey, fifthKey];
    return WillPopScope(
      onWillPop: () async {
        return !await tabKeys[_currIndex].currentState.maybePop();
      },
      child: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          activeColor: Colors.blue,
          onTap: (index) {
            setState(() {
              _currIndex = index;
            });
          },
          currentIndex: _currIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.view_list_outlined, size: 25),
              activeIcon: Icon(Icons.view_list, size: 28),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.email_outlined, size: 25),
              activeIcon: Icon(Icons.email, size: 28),
              label: 'Mensajes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_outlined, size: 25),
              activeIcon: Icon(Icons.notifications, size: 28),
              label: 'Notificaciones',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined, size: 25),
              activeIcon: Icon(Icons.calendar_today, size: 28),
              label: 'Calendario',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline, size: 25),
              activeIcon: Icon(Icons.person, size: 28),
              label: 'Cuenta',
            ),
          ],
        ),
        tabBuilder: (context, index) {
          return CupertinoTabView(
            navigatorKey: tabKeys[index],
            builder: (context) {
              return CupertinoPageScaffold(child: tabs[index]);
            },
          );
        },
      ),
    );
  }
}
