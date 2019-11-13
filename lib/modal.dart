import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/detail.dart';

class BookDetail extends StatefulWidget {

  var book;
  BookDetail({Key key, @required this.book}):super(key: key);
  @override
  _BookDetailState createState() => _BookDetailState();
}
class _BookDetailState extends State<BookDetail> {

  var book;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    book = widget.book;
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 450,
          width: 300,
          child: FadeInImage.assetNetwork(
            placeholder: 'assets/placeholder.jpg',
            image: book['cover'],
            fit: BoxFit.fill,),
        ),
        Container(
          width: 300,
          height: 240,
          color: Colors.white,
          padding: EdgeInsets.all(10.0),
          margin: EdgeInsets.only(top: MediaQuery.of(context).orientation==Orientation.portrait?210:150),
          child: Column(
            children: <Widget>[
              Text(book['title'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                    ),
              ),
              Divider(),
              Text(book['description'],
                maxLines: MediaQuery.of(context).orientation==Orientation.portrait?6:2,
                overflow: TextOverflow.fade,
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey
                ),
              ),

            ],
          ),
        ),
        Container(
          height: 65,
//          color: Colors.blue,
          margin: EdgeInsets.only(top: MediaQuery.of(context).orientation==Orientation.portrait?400:260),
          child: Container(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: RaisedButton(
                        child: Text('Read More...', style: TextStyle(color: Colors.white),),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Detail(book: book)));
                        },
                        color: Colors.blue,
                        splashColor: Colors.greenAccent,
                      ),
                    )
                  ],
                ),
              )

        )
      ],
    );
  }
}
