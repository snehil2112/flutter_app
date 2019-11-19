import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BookLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20.0),
        child: Shimmer.fromColors(
            child: Column(
              children: [
                Padding(padding: EdgeInsets.only(bottom: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 150,
                      height: 100,
                      color: Colors.grey[300],
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 2.0),),
                    Container(
                      width: 150,
                      height: 8.0,
                      color: Colors.grey[300],
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 2.0),),
                    Container(
                      width: 150,
                      height: 8.0,
                      color: Colors.grey[300],
                    ),
                  ],
                ),
                )
              ],
            ),
            baseColor: Colors.grey[200],
            highlightColor: Colors.grey[300])
    );
  }
}
