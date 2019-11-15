import 'package:flutter/material.dart';
import 'package:flutter_app/search.dart';


class BookByTopic extends StatelessWidget {
  List<Topic> topics = [
    Topic(id: '210', name: 'Technology', imgUrl: 'assets/technology.png'),
    Topic(id: '69', name: 'Computer', imgUrl: 'assets/computer.jpg'),
    Topic(id: '12', name: 'Biology', imgUrl: 'assets/biology.gif'),
    Topic(id: '43', name: 'Astrology', imgUrl: 'assets/astrology.jpg'),
    Topic(id: '48', name: 'Beauty', imgUrl: 'assets/beauty.png'),
    Topic(id: '1', name: 'Business', imgUrl: 'assets/business.png'),
    Topic(id: '296', name: 'Chemistry', imgUrl: 'assets/chemistry.png'),
    Topic(id: '305', name: 'Economy', imgUrl: 'assets/economy.png'),
    Topic(id: '32', name: 'Geography', imgUrl: 'assets/geography.png'),
    Topic(id: '64', name: 'History', imgUrl: 'assets/history.jpg'),
    Topic(id: '102', name: 'Literature', imgUrl: 'assets/literature.png'),
    Topic(id: '264', name: 'Physics', imgUrl: 'assets/physics.png'),

  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Browse by topics',textAlign: TextAlign.left, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey[700]),),
        Divider(),
        Container(
          height: 150.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: topics.map((topic) => Card(
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Search(query: 'topicid'+topic.id, page: 1, display: topic.name,)));
                  },
                  child: Container(
                    width: 120,
                    padding: EdgeInsets.all(5.0),
                    child: Column(
                      children: <Widget>[
                        Image.asset(topic.imgUrl, height: 100, width: 110,),
                        Text(topic.name, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500))
                      ],
                    ),
                  ),
                )
            )).toList(),
          ),
        ),
      ],
    );
  }
}

class Topic {
  String name;
  String id;
  String imgUrl;
  Topic({this.id, this.name, this.imgUrl});
}