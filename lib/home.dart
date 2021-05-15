import 'package:alpha_mobile/data.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class PropertiesPage extends StatefulWidget {
  @override
  _PropertiesPageState createState() => _PropertiesPageState();
}

class _PropertiesPageState extends State<PropertiesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Propiedades'),
      ),
      body: ListView.builder(
        itemCount: properties.length,
        itemBuilder: (BuildContext ctx, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PropertiesDetail(index)),
              );
            },
            child: Container(
              height: 480,
              child: Card(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Container(
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                        child: Image.asset(
                          'assets/parcela01.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Text(
                      properties[index]["title"],
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text(
                      properties[index]["address"],
                      style: TextStyle(fontSize: 17),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lightbulb, color: Colors.black45),
                        Icon(Icons.local_drink, color: Colors.black45),
                      ],
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Precio: " + properties[index]["price"],
                                style: TextStyle(fontSize: 17),
                              ),
                              Text(
                                "Superficie: " + properties[index]["surface"],
                                style: TextStyle(fontSize: 17),
                              ),
                              Text(
                                "Contacto: " + properties[index]["contact"],
                                style: TextStyle(fontSize: 17),
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class PropertiesDetail extends StatefulWidget {
  final int index;
  PropertiesDetail(this.index);
  @override
  _PropertiesDetailState createState() => _PropertiesDetailState();
}

class _PropertiesDetailState extends State<PropertiesDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(3),
              child: Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 180.0,
                    enlargeCenterPage: true,
                    autoPlay: true, // en vola lo pondría false
                    aspectRatio: 16 / 9,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration: Duration(milliseconds: 1200),
                    viewportFraction: 0.8,
                  ),
                  items: [
                    //1st Image of Slider
                    Container(
                      margin: EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: NetworkImage(
                              "https://cf.bstatic.com/images/hotel/max1024x768/117/117060679.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    //1st Image of Slider
                    Container(
                      margin: EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: NetworkImage(
                              "https://www.costacuraco.cl/wp-content/uploads/2020/06/costa-curaco-ventas-de-terrenos-en-chiloe-home-background-instagram-feed.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    //1st Image of Slider
                    Container(
                      margin: EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: NetworkImage(
                              "https://images.locanto.cl/Venta-de-Parcelas-en-el-Sur-de-Chile-Los-Lagos-Propiedades/vap_5015949749.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MakeAppointment()),
                );
                /* showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Column(
                          children: [
                            Text(
                              "Agendar",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                      selectedDate.toString().substring(0, 10)),
                                  ElevatedButton(
                                      onPressed: () => _selectDate(context),
                                      child: Text("Selecciona Fecha")),
                                  TextFormField(),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      child: Text("Submit"),
                                      onPressed: () {
                                        if (_formKey.currentState.validate()) {
                                          _formKey.currentState.save();
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ); */
              },
              icon: Icon(Icons.calendar_today),
              label: Text("Agendar Visita"),
            ),
            SizedBox(height: 18),
            Text(
              properties[widget.index]["title"],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
              properties[widget.index]["address"],
              style: TextStyle(fontSize: 17),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lightbulb, color: Colors.black45),
                Icon(Icons.local_drink, color: Colors.black45),
              ],
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Precio: " + properties[widget.index]["price"],
                        style: TextStyle(fontSize: 17),
                      ),
                      Text(
                        "Superficie: " + properties[widget.index]["surface"],
                        style: TextStyle(fontSize: 17),
                      ),
                      Text(
                        "Contacto: " + properties[widget.index]["contact"],
                        style: TextStyle(fontSize: 17),
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                properties[widget.index]["description"],
                style: TextStyle(fontSize: 17),
                textAlign: TextAlign.justify,
              ),
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

class MakeAppointment extends StatefulWidget {
  MakeAppointment({Key key}) : super(key: key);

  @override
  _MakeAppointmentState createState() => _MakeAppointmentState();
}

class _MakeAppointmentState extends State<MakeAppointment> {
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
    if (picked != null)
      setState(() {
        selectedTime = picked;
      });
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
          //mainAxisAlignment: MainAxisAlignment.center,
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
                child: Text("Confirmar"),
                onPressed: () {
                  print(selectedDate);
                  print(selectedTime);
                  // Join selectedDate y selectedTime and request to the backend
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
