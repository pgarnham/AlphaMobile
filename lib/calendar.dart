import 'dart:convert';

import 'package:alpha_mobile/variables.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:http/http.dart' as http;

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarController _controller;
  bool _isLoading = true;
  List<Appointment> myAppointments = [];

  @override
  void initState() {
    _controller = CalendarController();
    super.initState();
    getData();
  }

  void getData() async {
    List<Appointment> appointments = [];
    setState(() {
      _isLoading = true;
    });
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      var userApiKey = sharedPreferences.getString("apiKey");
      var userId = sharedPreferences.getInt("userId");

      final response = await http.get(
        Uri.parse(apiUrl + getUserAppointment + userId.toString()),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + userApiKey
        },
      );

      //print(response.statusCode);
      //print(jsonDecode(response.body));
      await Future.forEach(jsonDecode(response.body), (appoint) async {
        var year = int.parse(appoint["datetime"].substring(0, 4));
        var month = int.parse(appoint["datetime"].substring(5, 7));
        var day = int.parse(appoint["datetime"].substring(8, 10));
        var hour = int.parse(appoint["datetime"].substring(11, 13));
        var minute = int.parse(appoint["datetime"].substring(14, 16));

        final DateTime startTime = DateTime(year, month, day, hour, minute, 0);
        final DateTime endTime = startTime.add(Duration(hours: 2));
        String subject = appoint["property"]["title"];

        appointments.add(
          Appointment(
            startTime: startTime,
            endTime: endTime,
            subject: subject,
            color: Colors.blue,
          ),
        );
      });

      setState(() {
        myAppointments = appointments;
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    if (_controller.view == CalendarView.month &&
        calendarTapDetails.targetElement == CalendarElement.calendarCell) {
      _controller.view = CalendarView.day;
    } else if ((_controller.view == CalendarView.week ||
            _controller.view == CalendarView.workWeek) &&
        calendarTapDetails.targetElement == CalendarElement.viewHeader) {
      _controller.view = CalendarView.day;
    } else if (calendarTapDetails.targetElement ==
            CalendarElement.appointment ||
        calendarTapDetails.targetElement == CalendarElement.agenda) {
      final Appointment appointmentDetails = calendarTapDetails.appointments[0];

      String _subjectText = appointmentDetails.subject;
      String _dateText =
          appointmentDetails.startTime.toString().substring(0, 10);

      String _timeText =
          appointmentDetails.startTime.toString().substring(10, 16);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Container(
                child: Text(
              _subjectText,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            )),
            content: Container(
              height: 80,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        'Fecha: ' + _dateText,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: <Widget>[
                      Text(
                        'Hora: ' + _timeText,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: <Widget>[
                      Text(
                        'Detalles: ',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              new TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: new Text('Cerrar'))
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calendario"),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                getData();
              },
              child: Icon(
                Icons.refresh,
                size: 30.0,
                color: Colors.grey[200],
              ),
            ),
          )
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height - 130,
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : SfCalendar(
                controller: _controller,
                view: CalendarView.month,
                allowedViews: [
                  CalendarView.day,
                  CalendarView.week,
                  CalendarView.month,
                ],
                onTap: calendarTapped,
                firstDayOfWeek: 1,
                initialDisplayDate: DateTime.now(),
                dataSource: MeetingDataSource(myAppointments),
                appointmentTextStyle: TextStyle(fontSize: 18),
                selectionDecoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.3),
                  border: Border.all(color: Colors.blue, width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  shape: BoxShape.rectangle,
                ),
              ),
      ),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
