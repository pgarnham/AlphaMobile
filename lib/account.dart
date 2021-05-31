import 'package:alpha_mobile/auxiliar.dart';
import 'package:alpha_mobile/launch.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String userName = "";
  String userEmail = "";

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userName = sharedPreferences.getString("userName");
      userEmail = sharedPreferences.getString("userEmail");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cuenta'),
      ),
      body: SingleChildScrollView(
        child: Card(
          color: Colors.grey[200],
          child: Container(
            height: MediaQuery.of(context).size.height - 140,
            child: Column(
              children: [
                Container(
                  height: 200,
                  width: 200,
                  margin:
                      EdgeInsets.only(top: 5, bottom: 10, left: 10, right: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 5),
                      borderRadius: BorderRadius.circular(100),
                      image: DecorationImage(
                          image: NetworkImage(
                              "https://i.pinimg.com/originals/51/f6/fb/51f6fb256629fc755b8870c801092942.png"),
                          fit: BoxFit.cover)),
                ),
                SizedBox(height: 10),
                Text(userName, style: TextStyle(fontSize: 30)),
                Text(userEmail, style: TextStyle(fontSize: 20)),
                SizedBox(height: 30),
                Center(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
