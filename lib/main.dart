import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter_app/downloads.dart';
import 'package:flutter_app/recommended.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter_app/latest.dart';
import 'package:flutter_app/searchBar.dart';
import 'dart:convert';
import 'package:splashscreen/splashscreen.dart';


void main() async{
  await FlutterDownloader.initialize();
  runApp(new MaterialApp(
  home: new MyApp(),
  debugShowCheckedModeBanner: false,
));}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 2,
      navigateAfterSeconds: HomePage(),
      title: Text('LibGen', style: TextStyle(
          color: Colors.teal,
          fontSize: 30.0,
          fontWeight: FontWeight.bold
      ),),
      image: Image.asset('assets/logo.jpg',),
      backgroundColor: Colors.white,
      photoSize: 100,
      loaderColor: Colors.transparent,
    );
  }
}


class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
  // This widget is the root of your application.

}

class HomePageState extends State<HomePage> {
  List data;
  String error;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    try {
      this.getJsonData();
    } catch(e) {
      setState(() {
        error = 'Check Your Connection';
      });
    }
  }

  void getJsonData() async{
    error=null;
    String url = "https://libgenesis.herokuapp.com/latest";
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        // If the call to the server was successful, parse the JSON.
//      print(response.body);

        setState(() {
          data = json.decode(response.body);
        });

      } else {
        // If that call was not successful, throw an error.

//      throw Exception('Failed to load post');
        setState(() {
          String temp = json.decode(response.body)['message'];
          var arr = temp.split(":");
          if(arr.length > 1)
            error = arr[1];
          else
            error = arr[0];
        });
      }
    }catch(e) {
      setState(() {
        error = 'Check Your Connection!';
      });
    }
  }

  openTheDrawer() {
    _scaffoldKey.currentState.openDrawer();
  }

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
        child: ListView(
      // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Icon(Icons.account_circle, size: 100, ),
//            decoration: BoxDecoration(
//              color: Colors.white,
//            ),
          ),
          ListTile(
            title: Text('Favourites'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Downloads'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
              prefix0.Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Downloads();
              }));

            },
          ),
        ],
      ),
    ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          bottom: TabBar(tabs: [
            Tab(text: 'Latest',),
            Tab(text: 'Recommended',)
          ],
            indicatorColor: Colors.lightBlue,
            labelColor: Colors.lightBlue,
            indicatorSize: TabBarIndicatorSize.label,
            unselectedLabelColor: Colors.grey,
          ),
          title: Container(
            margin: EdgeInsets.symmetric(vertical: 5.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: [BoxShadow(color: Colors.grey,
                    offset: Offset(0.0, 0.0),
                    blurRadius: 3.0,
                    spreadRadius: 1.0),]
            ),
            child: Row(
              children: <Widget>[
                IconButton(icon: Icon(Icons.menu),color: Colors.grey, onPressed: () {
                  _scaffoldKey.currentState.openDrawer();
                }),
                SearchBox(),
                Icon(Icons.search, color: Colors.grey,)
              ],
            ),
          ),
        ),
        body: TabBarView(children: [
          error!=null
              ?Container(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height/3,
                left: MediaQuery.of(context).size.width/20 ),
            child: Column(
              children: <Widget>[
                Text(error,
                  style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 20.0),),
                RaisedButton(onPressed: () {
                  setState(() {
                    error='';
                  });
                  getJsonData();
                },
                  child: Text('Retry', style: TextStyle(color: Colors.black, fontSize: 16.0),),)
              ],
            ),
          )
              :data == null?Center(child: CircularProgressIndicator()):Latest(data: data,),
          SingleChildScrollView(
            child: Recommended(),
          )
        ]),

      ),
    );




  }
  
}

class SearchBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => SearchBar()));
      },
      child: new Container(
        width:MediaQuery.of(context).size.width > 120 ?MediaQuery.of(context).size.width-120:0,
        child: Text('Search Books', style: TextStyle(color: Colors.grey, fontSize: 18.0),)
      )
    );
  }
}
