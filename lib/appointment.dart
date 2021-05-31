import 'dart:convert';

import 'package:alpha_mobile/variables.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MakeAppointment extends StatefulWidget {
  final int propertyId;
  MakeAppointment(this.propertyId);

  @override
  _MakeAppointmentState createState() => _MakeAppointmentState();
}

class _MakeAppointmentState extends State<MakeAppointment> {
  bool _isLoading = false;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 08, minute: 00);

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2050));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agendar'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            Icon(Icons.calendar_today, size: 100, color: Colors.blue),
            SizedBox(height: 50),
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent, width: 1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                children: [
                  Text(
                    selectedDate.toString().substring(0, 10),
                    style: TextStyle(fontSize: 18),
                  ),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text(
                      "Selecciona Fecha",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent, width: 1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                children: [
                  Text(
                    selectedTime.format(context),
                    style: TextStyle(fontSize: 18),
                  ),
                  ElevatedButton(
                    onPressed: () => _selectTime(context),
                    child: Text(
                      "Selecciona Hora",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ElevatedButton(
                child: _isLoading ? Text("Cargando...") : Text("Confirmar"),
                onPressed: () async {
                  if (!_isLoading) {
                    setState(() {
                      _isLoading = true;
                    });
                    var date = selectedDate.toString().substring(0, 10);
                    var time = selectedTime.format(context);
                    var finalDateTime = date + 'T' + time + ':00.414Z';
                    try {
                      SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();

                      var userId = sharedPreferences.getInt("userId");
                      var userApiKey = sharedPreferences.getString("apiKey");

                      final response = await http.post(
                        Uri.parse(apiUrl + makeAppointmentPath),
                        body: json.encode({
                          "datetime": finalDateTime,
                          "status": "status",
                          "user_id": userId,
                          "property_id": 1
                        }),
                        headers: {
                          "Content-Type": "application/json",
                          "Authorization": "Bearer " + userApiKey
                        },
                      );

                      print(response.statusCode);
                      print(jsonDecode(response.body));

                      if (response.statusCode == 200) {
                        print("Success");
                        setState(() {
                          _isLoading = false;
                        });
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Agendado exitosamente')));
                      } else {
                        print("Error");
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Intenta nuevamente')));
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Intenta nuevamente')));
                      print(e);
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
