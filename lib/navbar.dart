import 'package:alpha_mobile/account.dart';
import 'package:alpha_mobile/home.dart';
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

  final tabs = [
    PropertiesPage(),
    MessagesPage(),
    NotificationsPage(),
    AccountPage()
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
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
            icon: Icon(Icons.person_outline, size: 25),
            activeIcon: Icon(Icons.person, size: 28),
            label: 'Cuenta',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView(
          builder: (context) {
            return CupertinoPageScaffold(child: tabs[_currIndex]);
          },
        );
      },
    );
  }
}
