import 'dart:convert';

import 'package:alpha_mobile/appointment.dart';
import 'package:alpha_mobile/variables.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PropertiesPage extends StatefulWidget {
  @override
  _PropertiesPageState createState() => _PropertiesPageState();
}

class _PropertiesPageState extends State<PropertiesPage> {
  Future<List> apiProperties;

  @override
  void initState() {
    super.initState();
    apiProperties = getData();
  }

  Future<List> getData() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      var userApiKey = sharedPreferences.getString("apiKey");

      final response = await http.get(
        Uri.parse(apiUrl + getPropertiesPath),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + userApiKey
        },
      );

      //print(response.statusCode);
      //print(jsonDecode(response.body));
      return jsonDecode(response.body);
    } catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Intenta nuevamente')));
      print(e);
    }
    return [];
  }

  Future<void> reloadData() async {
    setState(() {
      apiProperties = getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Propiedades'),
        ),
        body: RefreshIndicator(
          onRefresh: reloadData,
          child: FutureBuilder<List>(
            future: apiProperties,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PropertiesDetail(
                                    snapshot.data[index]["id"],
                                    snapshot.data[index])),
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
                                  snapshot.data[index]["title"],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                Text(
                                  snapshot.data[index]["address"],
                                  style: TextStyle(fontSize: 17),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    snapshot.data[index]["water"]
                                        ? Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: FaIcon(
                                                FontAwesomeIcons.faucet,
                                                color: Colors.black45),
                                          )
                                        : SizedBox.shrink(),
                                    snapshot.data[index]["electricity"]
                                        ? Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: FaIcon(FontAwesomeIcons.bolt,
                                                color: Colors.black45),
                                          )
                                        : SizedBox.shrink(),
                                    snapshot.data[index]["sewer"]
                                        ? Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: FaIcon(
                                                FontAwesomeIcons.toilet,
                                                color: Colors.black45),
                                          )
                                        : SizedBox.shrink(),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Precio: " +
                                                snapshot.data[index]["price"]
                                                    .toString() +
                                                " UF",
                                            style: TextStyle(fontSize: 17),
                                          ),
                                          Text(
                                            "Superficie: " +
                                                snapshot.data[index]["area"]
                                                    .toString() +
                                                " m2",
                                            style: TextStyle(fontSize: 17),
                                          ),
                                          Text(
                                            "Contacto: " +
                                                snapshot.data[index]["contact"],
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
                  );
                } else {
                  return Center(child: Text("No hay propiedades"));
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ));
  }
}

class PropertiesDetail extends StatefulWidget {
  final int propertyId;
  final Map propertyInfo;
  PropertiesDetail(this.propertyId, this.propertyInfo);
  @override
  _PropertiesDetailState createState() => _PropertiesDetailState();
}

class _PropertiesDetailState extends State<PropertiesDetail> {
  String _message;

  newMessage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String userApiKey = sharedPreferences.getString("apiKey");
    int userId = sharedPreferences.getInt("userId");
    var uri = Uri.parse(apiUrl + sendMessage);
    Map<String, String> myHeaders = Map<String, String>();
    myHeaders['Content-Type'] = 'application/json';
    myHeaders['Authorization'] = "Bearer " + userApiKey;
    var myBody = {
      "sent_by_id": userId,
      "sent_to_id": widget.propertyInfo["user"]["id"],
      "content": _message,
      "message_type": "",
      "property_id": widget.propertyId,
      "status": "OK"
    };
    final response =
        await http.post(uri, body: jsonEncode(myBody), headers: myHeaders);

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load Chats');
    }
  }

  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myController.dispose();
    super.dispose();
  }

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
                  MaterialPageRoute(
                      builder: (context) => MakeAppointment(widget.propertyId)),
                );
              },
              icon: Icon(Icons.calendar_today),
              label: Text("Agendar Visita"),
            ),
            SizedBox(height: 18),
            Text(
              widget.propertyInfo["title"],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
              widget.propertyInfo["address"],
              style: TextStyle(fontSize: 17),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.propertyInfo["water"]
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: FaIcon(FontAwesomeIcons.faucet,
                            color: Colors.black45),
                      )
                    : SizedBox.shrink(),
                widget.propertyInfo["electricity"]
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: FaIcon(FontAwesomeIcons.bolt,
                            color: Colors.black45),
                      )
                    : SizedBox.shrink(),
                widget.propertyInfo["sewer"]
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: FaIcon(FontAwesomeIcons.toilet,
                            color: Colors.black45),
                      )
                    : SizedBox.shrink(),
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
                        "Precio: " +
                            widget.propertyInfo["price"].toString() +
                            " UF",
                        style: TextStyle(fontSize: 17),
                      ),
                      Text(
                        "Superficie: " +
                            widget.propertyInfo["area"].toString() +
                            " m2",
                        style: TextStyle(fontSize: 17),
                      ),
                      Text(
                        "Contacto: " + widget.propertyInfo["contact"],
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
                widget.propertyInfo["description"],
                style: TextStyle(fontSize: 17),
                textAlign: TextAlign.justify,
              ),
            ),
            SizedBox(height: 50),
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Preguntale algo al vendedor'),
              controller: myController,
              keyboardType: TextInputType.multiline,
              minLines: 1, //Normal textInputField will be displayed
              maxLines: 5, // when user presses enter it will adapt to it
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20)),
              onPressed: () async {
                _message = myController.text;
                await newMessage();
                myController.clear();
              },
              child: const Text('Enviar'),
            )
          ],
        ),
      ),
    );
  }
}
