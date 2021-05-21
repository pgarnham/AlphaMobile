import 'package:alpha_mobile/login.dart';
import 'package:alpha_mobile/navbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LaunchPage extends StatefulWidget {
  @override
  _LaunchPageState createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  String userApiKey;

  @override
  void initState() {
    checkUser().whenComplete(() async {
      if (userApiKey != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => NavBar()),
            (Route<dynamic> route) => false);
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
            (Route<dynamic> route) => false);
      }
    });
    super.initState();
  }

  Future checkUser() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var apiKey = sharedPreferences.getString('apiKey');
    setState(() {
      userApiKey = apiKey;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
    );
  }
}
