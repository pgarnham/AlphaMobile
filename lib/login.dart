import 'dart:convert';

import 'package:alpha_mobile/navbar.dart';
import 'package:alpha_mobile/register.dart';
import 'package:alpha_mobile/variables.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _inputMail;
  String _inputPassword;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Iniciar Sesión'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 70),
              Image.asset('assets/logo.png'),
              SizedBox(height: 50),
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                  onSaved: (value) {
                    _inputMail = value;
                  },
                  validator: (value) {
                    if (value.isEmpty || value == null) {
                      return "Email requerido";
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Contraseña',
                  ),
                  obscureText: true,
                  onSaved: (value) {
                    _inputPassword = value;
                  },
                  validator: (value) {
                    if (value.isEmpty || value == null) {
                      return "Contraseña requerida";
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  if (!_isLoading) {
                    setState(() {
                      _isLoading = true;
                    });
                    final FormState currentForm = _formKey.currentState;
                    if (currentForm.validate()) {
                      currentForm.save();
                      try {
                        final response = await http.post(
                          Uri.parse(apiUrl + loginPath),
                          body: json.encode({
                            "email": _inputMail,
                            "password": _inputPassword,
                          }),
                          headers: {"Content-Type": "application/json"},
                        );

                        print(response.statusCode);
                        print(jsonDecode(response.body));

                        if (response.statusCode == 200) {
                          print("Success");
                          SharedPreferences sharedPreferences =
                              await SharedPreferences.getInstance();

                          sharedPreferences.setBool("isLogged", true);
                          sharedPreferences.setInt(
                              "userId", jsonDecode(response.body)['id']);
                          sharedPreferences.setString(
                              "apiKey", jsonDecode(response.body)['api_key']);
                          sharedPreferences.setString(
                              "userName",
                              jsonDecode(response.body)['first_name'] +
                                  " " +
                                  jsonDecode(response.body)['last_name']);
                          sharedPreferences.setString(
                              "userEmail", jsonDecode(response.body)['email']);

                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => NavBar()),
                              (Route<dynamic> route) => false);
                        } else {
                          print("Error");
                          setState(
                            () {
                              _isLoading = false;
                            },
                          );
                        }
                      } catch (e) {
                        print(e);
                      }
                    } else {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  }
                },
                child:
                    _isLoading ? Text("Cargando...") : Text("Iniciar Sesión"),
              ),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("No tienes cuenta?"),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignupPage()),
                        );
                      },
                      child: Text("Registrate"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
