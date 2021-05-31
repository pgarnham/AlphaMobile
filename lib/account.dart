import 'package:alpha_mobile/auxiliar.dart';
import 'package:alpha_mobile/launch.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cuenta'),
      ),
      body: Center(
        child: ElevatedButton.icon(
          label: Text("Cerrar Sesión"),
          icon: Icon(Icons.logout),
          onPressed: () async {
            SharedPreferences sharedPreferences =
                await SharedPreferences.getInstance();
            await sharedPreferences.clear();
            Navigator.pushAndRemoveUntil(
                SaveContext.buildContext,
                MaterialPageRoute(builder: (context) => LaunchPage()),
                (Route<dynamic> route) => false);
          },
        ),
      ),
    );
  }
}
