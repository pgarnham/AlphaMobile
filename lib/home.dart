import 'package:alpha_mobile/data.dart';
import 'package:flutter/material.dart';

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
                height: 300,
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  'assets/parcela01.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
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
