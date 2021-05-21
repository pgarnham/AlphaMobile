import 'dart:async';
import 'dart:convert';

import 'package:alpha_mobile/navbar.dart';
import 'package:alpha_mobile/variables.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _inputName;
  String _inputMail;
  String _inputPassword;
  String _inputConfirmPassword;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrarse'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Image.asset('assets/logo.png'),
              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nombre',
                  ),
                  onSaved: (value) {
                    _inputName = value;
                  },
                  validator: (value) {
                    if (value.isEmpty || value == null) {
                      return "Nombre requerido";
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
                    }),
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
                    validator: (value) {
                      _inputPassword = value;
                      if (value.isEmpty || value == null) {
                        return "Contraseña requerida";
                      } else {
                        return null;
                      }
                    }),
              ),
              SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Confimar contraseña',
                    ),
                    obscureText: true,
                    validator: (value) {
                      _inputConfirmPassword = value;
                      if (value.isEmpty || value == null) {
                        return "Contraseña requerida";
                      } else if (value != _inputPassword) {
                        return "Contraseñas no coinciden";
                      } else {
                        return null;
                      }
                    }),
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
                          Uri.parse(apiUrl + signupPath),
                          body: json.encode({
                            "first_name": _inputName,
                            "last_name": "",
                            "user_type": 0,
                            "date_of_birth": "2021-05-21",
                            "email": _inputMail,
                            "password": _inputPassword
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
                          sharedPreferences.setString(
                              "apiKey", jsonDecode(response.body)['api_key']);

                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => NavBar()),
                              (Route<dynamic> route) => false);
                        } else {
                          print("Failed");
                          setState(
                            () {
                              _isLoading = false;
                            },
                          );
                        }
                      } catch (e) {
                        print(e);
                        setState(
                          () {
                            _isLoading = false;
                          },
                        );
                      }
                    } else {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  }
                },
                child: _isLoading ? Text("Cargando...") : Text("Registrarme"),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Ya tienes cuenta?"),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Inicia Sesión"))
                ],
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
