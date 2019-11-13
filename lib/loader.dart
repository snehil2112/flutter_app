import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20.0),
        child: Shimmer.fromColors(
            child: Column(
              children: [0, 1, 2, 3]
                  .map((_) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48.0,
                      height: 48.0,
                      color: Colors.white,
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 8.0,
                            color: Colors.white,
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          Container(
                            width: double.infinity,
                            height: 8.0,
                            color: Colors.white,
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          Container(
                            width: 40.0,
                            height: 8.0,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ))
                  .toList(),
            ),
            baseColor: Colors.grey,
            highlightColor: Colors.white)
    );
  }
}