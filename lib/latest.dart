import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter_app/loader.dart';
import 'package:flutter_app/modal.dart';
import 'package:loading/indicator.dart';
import 'package:loading/loading.dart';
import 'package:transparent_image/transparent_image.dart';

class Latest extends StatefulWidget {
  @override
  List data;
  Latest({Key key, @required this.data}):super(key: key);
  _LatestState createState() => _LatestState();
}

class _LatestState extends State<Latest> {
  List data;
  Future<String> getJsonData() async{
    String url = "https://libgenesis.herokuapp.com/latest";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON.
      print(response.body);

      setState(() {
        data = json.decode(response.body);
      });

      return 'Success';
    } else {
      // If that call was not successful, throw an error.
      print(response.body);
      throw Exception('Failed to load post');
    }
  }
  @override
  void initState() {
    super.initState();
    data = widget.data;
    //this.getJsonData();
  }
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: getJsonData,
      child: GridView.count(
        crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait?2:4,
        padding: EdgeInsets.all(5.0),
        mainAxisSpacing: 5.0,
        children: data.map((book) => GestureDetector(
          onTap: () {
            showDialog(context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: BookDetail(book: book),
                    contentPadding: EdgeInsets.all(0.0),
                  );
                });
          },
          child: Card(
              child: Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(5.0),
                      alignment: Alignment.center,
                      child: FadeInImage.assetNetwork(placeholder: 'assets/placeholder.jpg',image: book['cover']),),
                    Container(
                      padding: EdgeInsets.all(5.0),
                      alignment: Alignment.bottomCenter,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[
                            Colors.black.withAlpha(0),
                            Colors.black12,
                            Colors.black87
                          ],
                        ),
                      ),
                      child: Text(
                        book['title'],
                        maxLines: 2,
                        overflow: TextOverflow.fade,
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                    ),
                  ],
                ),
              )
          ),
        )
        ).toList(),
      ),
    );
  }
}
