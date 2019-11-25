import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/detail.dart';
import 'package:flutter_app/modal.dart';
import 'package:flutter_app/utils/database_helper.dart';

class Favourites extends StatefulWidget {
  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  List data;

  void fetchFavourites() async{
    DatabaseHelper databaseHelper = DatabaseHelper();
    var temp = await databaseHelper.fetchBook();
    setState(() {
      data = temp;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchFavourites();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    fetchFavourites();
    return Scaffold(
      appBar: AppBar(
        title: Text('Favourites'),
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
          Navigator.pop(context);
        },),
      ),
      body: data == null ? Center(
        child: CircularProgressIndicator(),
      ) :data.length == 0? Center(
        child: Text('No Favourites Yet', style: TextStyle(color: Colors.grey[700], fontSize: 18),),
      ) :ListView.builder(
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) { return Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Detail(book: data[index])));
                },
                child: new ListTile(
                  leading: GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content:
                              BookDetail(book: data[index]),
                              contentPadding: EdgeInsets.all(0.0),
                            );
                          });
                    },
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/placeholder.jpg',
                      image: data[index]['cover'],
                      width: 40.0,
                    ),
                  ),
                  title: new Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          data[index]['title'],
                          overflow: TextOverflow.ellipsis,
                        ),
                        flex: 3,
                      ),
                    ],
                  ),
                  subtitle: new Container(
                    padding: EdgeInsets.only(top: 5.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 7,
                          child: new Text(
                            'by ' + data[index]['author'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: new TextStyle(
                                fontSize: 15.0,
                                color: Colors.grey),
                          ),
                        ),
                        Spacer(),
                        Badge(
                          badgeColor:
                          data[index]['extension'] == 'pdf'
                              ? Colors.red
                              : Colors.green,
                          badgeContent: Text(
                            data[index]['extension'].toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          shape: BadgeShape.square,
                          elevation: 0,
                          borderRadius: 5.0,
                          toAnimate: false,
                          padding: EdgeInsets.all(3.0),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              new Divider(
                height: 10.0,
              ),
            ],
          );
          }
      ),
    );
  }
}
