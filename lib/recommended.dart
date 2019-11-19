import 'package:flutter/material.dart';
import 'package:flutter_app/bookloader.dart';
import 'package:flutter_app/suggestion.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'bookbytopic.dart';

class Recommended extends StatefulWidget {
  @override
  _RecommendedState createState() => _RecommendedState();
}

class _RecommendedState extends State<Recommended> {
  List book1;
  List book2;
  String error1, error2;
  Future<List> getJsonData(String name) async{
    String url = "https://libgenesis.herokuapp.com/searchBooks/"+name+"/1";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON.
//      print(response.body);
      return json.decode(response.body);
    } else {
      // If that call was not successful, throw an error.
      print(response.body);
      throw Exception('Failed to load post');
    }
  }

  void harryPotter() async {
    setState(() {
      error1 = null;
    });
    try{
      var temp = await getJsonData('harry potter');
      if(!mounted)
        return;
      setState(() {
        book1 = temp;
      });
    } catch (e) {
      if(!mounted)
        return;
      setState(() {
        error1 = 'Some problem occured';
      });
    }
  }

  void gameOfThrones() async {
    setState(() {
      error2 = null;
    });
    try{
      var temp = await getJsonData('game of thrones');
      if(!mounted)
        return;
      setState(() {
        book2 = temp;
      });
    } catch (e) {
      if(!mounted)
        return;
      setState(() {
        error2 = 'Some problem occured!';
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    harryPotter();
    gameOfThrones();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          BookByTopic(),
          Padding(padding: EdgeInsets.only(top: 15.0),),
          Text('Harry Potter Series',textAlign: TextAlign.left, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey[700]),),
          Divider(),
          error1 != null?Container(
            child: Center(
              child: Column(
                children: <Widget>[
                  Text(error1),
                  RaisedButton(
                    onPressed: () {
                      harryPotter();
                    },
                    child: Text('Retry'),
                  )
                ],
              ),
            ),
          ):book1 == null
              ?BookLoader()
              :Suggestion(books: book1,),
          Padding(padding: EdgeInsets.only(top: 15.0),),
          Text('Game of Thrones Series',textAlign: TextAlign.left, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey[700]),),
          Divider(),
          error2 != null?Container(
            child: Center(
              child: Column(
                children: <Widget>[
                  Text(error2),
                  RaisedButton(
                    onPressed: () {
                      gameOfThrones();
                    },
                    child: Text('Retry'),
                  )
                ],
              ),
            ),
          ):book2 == null
              ?BookLoader()
              :Suggestion(books: book2,)
        ],
      )

    );
  }
}





