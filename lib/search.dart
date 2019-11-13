import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter_app/detail.dart';
import 'package:flutter_app/modal.dart';
import 'package:flutter_app/searchBar.dart';

import 'loader.dart';


class Search extends StatefulWidget {
  String query;
  int page;
  Search({Key key, @required this.query, @required this.page}): super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List data=[];
  String query;
  int page;
  bool resp = false;
  String error;
  @override
  void initState() {
    super.initState();
    this.getJsonData();
  }

  Future<String> getJsonData() async{
    if(query == null) {
      query = widget.query;
      page = 1;
    }
    String url = "https://libgenesis.herokuapp.com/searchBooks/"+query+"/"+page.toString();
    var response = await http.get(url);
    setState(() {
      resp = true;
    });
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON.
      //print(response.body);

      setState(() {
        error = null;
        data.addAll(json.decode(response.body));
      });

      return 'Success';
    }
    else {
      // If that call was not successful, throw an error.
      setState(() {
        String temp = json.decode(response.body)['message'];
        var arr = temp.split(":");
        if(arr.length > 1)
          error = arr[1];
        else
          error = arr[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back), color: Colors.grey, onPressed: () {
          Navigator.pop(context);
        }),
        backgroundColor: Colors.white,
        title: Row(
          children: <Widget>[
            Text(query, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 18.0),),
            Spacer(),
//            Icon(Icons.search, color: Colors.grey,)
            Tap()
          ],
        ),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.mic_none), onPressed: null)
        ],
      ),
      body: !resp?Loader():error!=null?Container(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height/3,
            horizontal: MediaQuery.of(context).size.width/4 ),
        child: Column(
          children: <Widget>[
            Text(error,
              style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 20.0),),
            RaisedButton(onPressed: () {
              setState(() {
                error='';
                resp = false;
              });
              getJsonData();
            },
            child: Text('Retry', style: TextStyle(color: Colors.black, fontSize: 16.0),),)
          ],
        ),
      ):
      ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, int index) => Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Detail(book: data[index])));
                },
                child: new ListTile(
                  leading: GestureDetector(
                    onTap: () {
                      showDialog(context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: BookDetail(book: data[index]),
                              contentPadding: EdgeInsets.all(0.0),
                            );
                          });
                    },
                    child: FadeInImage.assetNetwork(placeholder: 'assets/placeholder.jpg', image: data[index]['cover'], width: 40.0,),
                  ),
                  title: new Row(
                    children: <Widget>[
                      Expanded(child: Text(data[index]['title'],
                        overflow: TextOverflow.ellipsis,),
                        flex: 3,),
                    ],
                  ),
                  subtitle: new Container(
                    padding: EdgeInsets.only(top: 5.0),
                    child: new Text('by '+data[index]['author'],maxLines: 2, overflow: TextOverflow.ellipsis, style: new TextStyle(fontSize: 15.0, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              new Divider(
                height: 10.0,
              ),
            ],
          ),),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        splashColor: Colors.greenAccent,
        onPressed: () {
          setState(() {
            page = page+1;
          });
          getJsonData();
      },
        tooltip: 'Load More',
      ),
    );
  }
}

class Tap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => SearchBar()));
      },
      child: Icon(Icons.search, color: Colors.grey,)
    );
  }
}

class Error extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}








//      appBar: new AppBar(
//        leading: IconButton(icon: Icon(Icons.menu), onPressed: () {}),
//        title: search? new Container(
//          margin: EdgeInsets.only(top: 7.0, bottom: 7.0),
//          decoration: BoxDecoration(
//            borderRadius: BorderRadius.circular(5.0),
//            color: Colors.white
//          ),
////          color: Colors.white,
//          child: Row(
//            children: <Widget>[
//              IconButton(icon: Icon(Icons.arrow_back, color: Colors.grey,), onPressed: () {
//                setState(() {
//                  search = false;
//                });
//              }),
//              Expanded(
//                child: TextField(
//                  decoration: InputDecoration(hintText: 'Search...',
//                  border: InputBorder.none),
//                  controller: _controller,
//                  onSubmitted: (q) {
//                    setState(() {
//                      getJsonData(q, 1);
//                    });
//                  },
//                ),
//              ),
//              IconButton(icon: Icon(Icons.close, color: Colors.grey,), onPressed: () {
//                _controller.clear();
//              })
//            ],
//          ),
//        ):new Container(child: Row(
////          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//          children: <Widget>[
//            Text('Library',),
//            Spacer(),
//            IconButton(icon: Icon(Icons.search), onPressed: () {
//              setState(() {
//                search = true;
//              });
//            }),
//          ],
//        ),
//          margin: EdgeInsets.only(left: 0.0),
//        ),
//        actions: <Widget>[
//          IconButton(icon: Icon(Icons.more_vert), onPressed: null)
//        ],
//      ),