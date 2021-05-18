import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarController _controller;
  @override
  void initState() {
    _controller = CalendarController();
    super.initState();
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
      ),
      body: SfCalendar(
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
        dataSource: MeetingDataSource(getAppointments()),
        appointmentTextStyle: TextStyle(fontSize: 18),
        selectionDecoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.3),
          border: Border.all(color: Colors.blue, width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          shape: BoxShape.rectangle,
        ),
      ),
    );
  }
}

List<Appointment> getAppointments() {
  List<Appointment> meetings = [];
  final DateTime today = DateTime.now();
  final DateTime startTime =
      DateTime(today.year, today.month, today.day, 9, 0, 0);
  final DateTime endTime = startTime.add(Duration(hours: 2));

  meetings.add(
    Appointment(
      startTime: startTime,
      endTime: endTime,
      subject: "Visita Terreno",
      color: Colors.blue,
    ),
  );

  meetings.add(
    Appointment(
      startTime: DateTime(2021, 05, 20, 12, 0, 0),
      endTime: DateTime(2021, 05, 20, 15, 0, 0),
      subject: "Visita Parcela",
      color: Colors.blue,
    ),
  );

  return meetings;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
