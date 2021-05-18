import 'dart:async';

import 'package:flutter/material.dart';

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
                      } catch (e) {} // Manejar SignUp con Backend
                    } else {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  }
                },
                child: Text("Registrarme"),
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
