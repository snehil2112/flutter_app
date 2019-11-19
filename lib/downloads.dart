import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class Downloads extends StatefulWidget {
  @override
  _DownloadsState createState() => _DownloadsState();
}

class _DownloadsState extends State<Downloads> {
  List tasks;
  List ongoing;
  int selected = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load();
    print(ongoing);
  }

  void load() async {
    tasks = [];
    ongoing = [];
    List temp = await FlutterDownloader.loadTasks();
    setState(() {
      temp?.forEach((task) {
        if (task.status == DownloadTaskStatus.complete) {
          tasks.add(task);
        }
        else if(task.status == DownloadTaskStatus.running) {
          ongoing.add(task);
        }
      });
    });
  }

  Future<bool> _openDownloadedFile(var task) {
    return FlutterDownloader.open(taskId: task.taskId);
  }

  void _delete(var task) async {
    await FlutterDownloader.remove(
        taskId: task.taskId, shouldDeleteContent: true);
    load();
  }

  void _cancelDownload(var task) async {
    await FlutterDownloader.cancel(taskId: task.taskId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Downloads'),
      ),
      body: selected==0
          ?ongoing.length == 0?Center(child: Text('No ongoing downloads', style: TextStyle(color: Colors.grey, fontSize: 18.0),),):ListView.builder(
          itemCount: ongoing.length,
          itemBuilder: (BuildContext context, int index) => Column(
            children: <Widget>[
              ListTile(
                leading: Image.asset('./assets/placeholder.jpg', width: 40,),
                title: Column(
                  children: <Widget>[
                    Text(ongoing[index].filename, maxLines: 2,),
                    Padding(padding: EdgeInsets.only(top: 5.0),),
                    LinearProgressIndicator(value: ongoing[index].progress/100,)
                  ],
                ),
                trailing: IconButton(icon: Icon(Icons.delete),onPressed: () {
                  _cancelDownload(ongoing[index]);
                },),
              )
            ],
          ))
          :tasks.length == 0?Center(child: Text('No books downloaded', style: TextStyle(color: Colors.grey, fontSize: 18.0),), ):ListView.builder(
        itemCount: tasks == null ? 0 : tasks.length,
        itemBuilder: (BuildContext context, int index) => Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                _openDownloadedFile(tasks[index]).then((success) {
                  if (!success) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('Cannot open file'),
                    ));
                  }
                });
              },
              child: new ListTile(
                leading: Image.asset('assets/placeholder.jpg', width: 40,),
                title: new Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        tasks[index].filename,
                        overflow: TextOverflow.ellipsis,
                      ),
                      flex: 3,
                    ),
                  ],
                ),
                trailing: GestureDetector(
                  onTap: () {
//                    _delete(tasks[index]);
                    showDialog(context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Delete Book'),
                            content: Text('Are you sure?'),
                            actions: <Widget>[
                              RaisedButton(
                                color: Colors.blue,
                                onPressed: () {
                                  _delete(tasks[index]);
                                  Navigator.pop(context);
                                },
                                child: Text('OK', style: TextStyle(color: Colors.white),),
                              ),
                              OutlineButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                borderSide: BorderSide(color: Colors.blue),
                                highlightedBorderColor: Colors.blue,
                                textColor: Colors.blue,
                                child: Text('Cancel'),
                              )
                            ],
                          );
                        });
                  },
                  child: Icon(Icons.delete),
                ),
              ),
            ),
            new Divider(
              height: 10.0,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        currentIndex: selected,
        onTap: (index) {
          setState(() {
            selected = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.file_download),
            title: Text('Ongoing')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            title: Text('Completed')
          )
        ],
      ),
    );
  }
}
