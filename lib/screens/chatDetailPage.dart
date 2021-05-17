import 'package:flutter/material.dart';

class ChatDetailPage extends StatefulWidget {
  String propertyName;
  List<Map> messages;
  ChatDetailPage({
    @required this.propertyName,
    @required this.messages,
  });
  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
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
                  backgroundImage: NetworkImage(
                      "https://randomuser.me/api/portraits/men/5.jpg"),
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
                        "Disponible",
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.settings,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          ListView.builder(
            itemCount: widget.messages.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 10, bottom: 10),
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Expanded(
                child: Container(
                  padding: EdgeInsets.only(
                      left: widget.messages[index]["messageType"] == "receiver"
                          ? 24
                          : 7,
                      right: widget.messages[index]["messageType"] == "receiver"
                          ? 7
                          : 24),
                  margin: EdgeInsets.symmetric(vertical: 7),
                  width: MediaQuery.of(context).size.width,
                  alignment: widget.messages[index]["messageType"] == "receiver"
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    decoration: BoxDecoration(
                        color:
                            widget.messages[index]["messageType"] == "receiver"
                                ? Colors.blue[400]
                                : Colors.grey[200],
                        borderRadius:
                            widget.messages[index]["messageType"] == "receiver"
                                ? BorderRadius.only(
                                    topRight: Radius.circular(17),
                                    topLeft: Radius.circular(17),
                                    bottomLeft: Radius.circular(17))
                                : BorderRadius.only(
                                    topLeft: Radius.circular(17),
                                    topRight: Radius.circular(17),
                                    bottomRight: Radius.circular(17),
                                    bottomLeft: Radius.elliptical(-20, -3))),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              widget.messages[index]["author"].toUpperCase(),
                              style: TextStyle(
                                color: widget.messages[index]["messageType"] ==
                                        "receiver"
                                    ? Colors.white
                                    : Colors.black,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              widget.messages[index]["timeStamp"].toUpperCase(),
                              style: TextStyle(
                                  color: widget.messages[index]
                                              ["messageType"] ==
                                          "receiver"
                                      ? Colors.white
                                      : Color(0xFF9E9E9E),
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          alignment: widget.messages[index]["messageType"] ==
                                  "receiver"
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Text(
                              widget.messages[index]["messageType"] ==
                                      "receiver"
                                  ? widget.messages[index]["messageContent"]
                                  : widget.messages[index]["messageContent"],
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: widget.messages[index]
                                              ["messageType"] ==
                                          "receiver"
                                      ? Colors.white
                                      : Colors.black,
                                  letterSpacing: 0.4,
                                  fontSize: 15)),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
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
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () {},
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
