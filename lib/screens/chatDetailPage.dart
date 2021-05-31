import 'package:flutter/material.dart';
import 'package:alpha_mobile/widgets/chatBubble.dart';
import 'package:http/http.dart' as http;
import 'package:alpha_mobile/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ChatDetailPage extends StatefulWidget {
  String propertyName;
  List<Map> messages;
  String imageUrl;
  int propertyId;
  String ownerName;
  int ownerId;
  ChatDetailPage(
      {@required this.propertyName,
      @required this.propertyId,
      @required this.ownerName,
      @required this.ownerId,
      @required this.imageUrl});
  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  Future<List> chatMessages;
  List<bool> isAuthorList = new List<bool>.empty(growable: true);
  List<Map> newMessagesList = new List<Map>.empty(growable: true);
  String _newMessage = "";

  @override
  void initState() {
    super.initState();
    chatMessages = loadMessages();
  }

  Future<List> loadMessages() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String userApiKey = sharedPreferences.getString("apiKey");
    int userId = sharedPreferences.getInt("userId");
    print(widget.propertyId.toString());
    var uri = Uri.parse(apiUrl + getMessages + widget.propertyId.toString());
    print(uri);
    Map<String, String> myHeaders = Map<String, String>();
    myHeaders['Content-Type'] = 'application/json';
    myHeaders['Authorization'] = "Bearer " + userApiKey;
    final response = await http.get(uri, headers: myHeaders);

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      List<dynamic> values = new List<dynamic>.empty(growable: true);
      values = jsonDecode(response.body);
      if (values.length > 0) {
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            int senderId = values[i]["sent_by"]["id"];
            if (senderId == userId) {
              isAuthorList.add(true);
            } else {
              isAuthorList.add(false);
            }
          }
        }
      }
      return jsonDecode(response.body);
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load Chats');
    }
  }

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
      "sent_to_id": widget.ownerId,
      "content": _newMessage,
      "message_type": "",
      "property_id": widget.propertyId,
      "status": "OK"
    };
    final response =
        await http.post(uri, body: jsonEncode(myBody), headers: myHeaders);

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      newMessagesList.add(jsonDecode(response.body));
      await reloadMessages();
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load Chats');
    }
  }

  Future<void> reloadMessages() async {
    setState(() {
      chatMessages = loadMessages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.imageUrl),
                  maxRadius: 20,
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.propertyName,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        widget.ownerName,
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: reloadMessages,
                  child: Icon(
                    Icons.refresh,
                    size: 30.0,
                    color: Colors.blue[200],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          FutureBuilder<List>(
              future: chatMessages,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            ListView.builder(
                              itemCount: snapshot.data.length,
                              shrinkWrap: true,
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return ChatBubble(
                                    message: snapshot.data[index]["content"],
                                    isAuthor: isAuthorList[index],
                                    name: snapshot.data[index]["sent_by"]
                                            ["first_name"] +
                                        " " +
                                        snapshot.data[index]["sent_by"]
                                            ["last_name"],
                                    date: snapshot.data[index]["timestamp"]
                                        .substring(0, 9));
                              },
                            ),
                            SizedBox(
                              height: 160,
                            )
                          ],
                        ));
                  } else {
                    return Center(child: Text("No hay propiedades"));
                  }
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 170, // lo cambié para que se vea el campo de texto
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                      onChanged: (value) {
                        _newMessage = value;
                      },
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () async {
                      setState(() async {
                        await newMessage();
                      });
                    },
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                    backgroundColor: Colors.blue,
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
