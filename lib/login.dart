import 'dart:async';

import 'package:alpha_mobile/register.dart';
import 'package:flutter/material.dart';

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
                        Timer(
                          const Duration(milliseconds: 2000),
                          () {
                            setState(
                              () {
                                _isLoading = false;
                              },
                            );
                          },
                        );
                      } catch (e) {} // Manejar Login con Backend
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
