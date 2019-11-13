import 'package:flutter/material.dart';
import 'package:flutter_app/search.dart';

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  bool clear = false;
  final _controller = TextEditingController();
  @override
  void initState() {
    _controller.addListener(() {
      final text = _controller.text.toLowerCase();
//      print(text);
      _controller.value = _controller.value.copyWith(
        text: text,
        composing: TextRange.empty,
      );
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.grey,), onPressed: () {
          Navigator.pop(context);
        }),
        title: Container(
          child: TextField(
            autofocus: true,
            decoration: InputDecoration(hintText: 'Search...',
                 border: InputBorder.none),
            controller: _controller,
            onChanged: (query) {
              setState(() {
                clear = (query != '');
              });
            },
            onSubmitted: (query) {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => Search(query: query, page: 1)));
            },
          ),
        ),
        backgroundColor: Colors.white,
        actions: <Widget>[
          clear?IconButton(icon: Icon(Icons.close), color: Colors.grey, onPressed: () {
            _controller.clear();
            setState(() {
              clear = false;
            });
          }):IconButton(icon: Icon(Icons.mic_none), onPressed: null)
        ],
      ),
    );
  }
}

