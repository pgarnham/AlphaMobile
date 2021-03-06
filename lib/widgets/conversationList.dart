import 'package:alpha_mobile/data.dart';
import 'package:flutter/material.dart';
import 'package:alpha_mobile/screens/chatDetailPage.dart';

class ConversationList extends StatefulWidget {
  final String name;
  final String ownerName;
  final int ownerId;
  final String imageUrl;
  final String time;
  final bool isMessageRead;
  final int propertyId;
  ConversationList(
      {@required this.name,
      @required this.ownerName,
      @required this.ownerId,
      @required this.imageUrl,
      @required this.time,
      @required this.propertyId,
      @required this.isMessageRead});
  @override
  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ChatDetailPage(
            propertyName: widget.name,
            propertyId: widget.propertyId,
            ownerName: widget.ownerName,
            ownerId: widget.ownerId,
            imageUrl: widget
                .imageUrl, // Esto se debería pedir al momento de abrir el chat
          );
        }));
      },
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.imageUrl),
                    maxRadius: 30,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.name,
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            widget.ownerName,
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                                fontWeight: widget.isMessageRead
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              widget.time,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: widget.isMessageRead
                      ? FontWeight.bold
                      : FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
