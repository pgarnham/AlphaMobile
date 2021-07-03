import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final bool isAuthor;
  final String name;
  final String date;
  final String message;

  ChatBubble(
      {@required this.message,
      @required this.isAuthor,
      @required this.name,
      @required this.date});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding:
            EdgeInsets.only(left: isAuthor ? 32 : 7, right: isAuthor ? 7 : 32),
        margin: EdgeInsets.symmetric(vertical: 7),
        width: MediaQuery.of(context).size.width,
        alignment: isAuthor ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          decoration: BoxDecoration(
              color: isAuthor ? Colors.blue[400] : Colors.grey[200],
              borderRadius: isAuthor
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
                    name.toUpperCase(),
                    style: TextStyle(
                      color: isAuthor ? Colors.white : Colors.black,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    date.toUpperCase(),
                    style: TextStyle(
                        color: isAuthor ? Colors.white : Color(0xFF9E9E9E),
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                alignment:
                    isAuthor ? Alignment.centerRight : Alignment.centerLeft,
                child: Text(message,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: isAuthor ? Colors.white : Colors.black,
                        letterSpacing: 0.4,
                        fontSize: 15)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
