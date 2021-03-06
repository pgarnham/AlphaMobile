import 'package:flutter/material.dart';
import 'package:alpha_mobile/widgets/conversationList.dart';
import 'package:http/http.dart' as http;
import 'package:alpha_mobile/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MessagesPage extends StatefulWidget {
  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  Future<List> chatUsers;

  @override
  void initState() {
    super.initState();
    chatUsers = loadChats();
  }

  Future<List> loadChats() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String userApiKey = sharedPreferences.getString("apiKey");
    var uri = Uri.parse(apiUrl + getChats);
    Map<String, String> myHeaders = Map<String, String>();
    myHeaders['Content-Type'] = 'application/json';
    myHeaders['Authorization'] = "Bearer " + userApiKey;
    final response = await http.get(uri, headers: myHeaders);

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return jsonDecode(response.body);
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load Chats');
    }
  }

  Future<void> reloadChats() async {
    setState(() {
      chatUsers = loadChats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mensajes'), actions: [
        GestureDetector(
          onTap: reloadChats,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(
              Icons.refresh,
              size: 30.0,
              color: Colors.white,
            ),
          ),
        )
      ]),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10, left: 16, right: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Buscar...",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey.shade100)),
                ),
              ),
            ),
            FutureBuilder(
                future: chatUsers,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.only(top: 16),
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ConversationList(
                            name: snapshot.data[index]["property"]["title"],
                            ownerName: snapshot.data[index]["property"]["user"]
                                    ["first_name"] +
                                " " +
                                snapshot.data[index]["property"]["user"]
                                    ["last_name"],
                            ownerId: snapshot.data[index]["property"]["user"]
                                ["id"],
                            imageUrl: "",
                            time: "",
                            propertyId: snapshot.data[index]["property"]["id"],
                            isMessageRead:
                                (index == 0 || index == 3) ? true : false,
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
                }),
          ],
        ),
      ),
    );
  }
}
