import 'package:flutter/material.dart';
import 'package:flutter_app/detail.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Suggestion extends StatelessWidget {
  List books;
  Suggestion({@required this.books});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: books.map((book) => Card(
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Detail(book: book)));
              },
              child: Container(
                width: 150,
                padding: EdgeInsets.all(5.0),
                child: Column(
                  children: <Widget>[
                    FadeInImage.assetNetwork(placeholder: 'assets/placeholder.jpg', image: book['cover'], height: 180,),
                    Padding(padding: EdgeInsets.only(top: 5.0),),
                    Expanded(
                      child: Text(book['title'], style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
                    )
                  ],
                ),
              ),
            )
        )).toList(),
      ),
    );
  }
}
