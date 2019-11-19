import 'dart:async' as prefix0;

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart' as prefix1;
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io' as io;
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'dart:isolate';
import 'dart:ui';

class Detail extends StatefulWidget {
  @override
  _DetailState createState() => _DetailState();
  var book;
  Detail({Key key, @required this.book}):super(key: key);
}

class _DetailState extends State<Detail> {
  CancelToken cancel;
  bool downloading = false;
  bool downloaded = false;
  var progressString = "";
  var book;
  bool _isLoading;
  _TaskInfo task;
  double progress = 0.0;
  bool _permissionReady;
  String _localPath;
  ReceivePort _port = ReceivePort();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    // TODO: implement dispose
    _unbindBackgroundIsolate();
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback);

    _permissionReady = false;
    _isLoading = true;
    _prepare();
    super.initState();
    book = widget.book;
  }

  void _requestDownload(_TaskInfo task) async {
    task.taskId = await FlutterDownloader.enqueue(
        url: task.book['download'],
        headers: {"auth": "test_for_sql_encoding"},
        savedDir: _localPath,
        showNotification: true,
        fileName: task.book['title'].toString().replaceAll("/", "")+task.book['id'].toString().replaceAll("/", "")+'.'+task.book['extension'],
        openFileFromNotification: true);
  }

  void _cancelDownload(_TaskInfo task) async {
    await FlutterDownloader.cancel(taskId: task.taskId);
  }

//  void _pauseDownload(_TaskInfo task) async {
//    await FlutterDownloader.pause(taskId: task.taskId);
//  }
//
//  void _resumeDownload(_TaskInfo task) async {
//    String newTaskId = await FlutterDownloader.resume(taskId: task.taskId);
//    task.taskId = newTaskId;
//  }
//
//  void _retryDownload(_TaskInfo task) async {
//    String newTaskId = await FlutterDownloader.retry(taskId: task.taskId);
//    task.taskId = newTaskId;
//  }

  Future<bool> _openDownloadedFile(_TaskInfo task) {
    return FlutterDownloader.open(taskId: task.taskId);
  }

  void _delete(_TaskInfo task) async {
    await FlutterDownloader.remove(
        taskId: task.taskId, shouldDeleteContent: true);
    await _prepare();
    setState(() {});
  }

  Future<bool> _checkPermission() async {
    if (Theme.of(context).platform == TargetPlatform.android) {
      PermissionStatus permission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
      if (permission != PermissionStatus.granted) {
        Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler()
            .requestPermissions([PermissionGroup.storage]);
        if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  void share() {
    final RenderBox box = context.findRenderObject();
    if(task.status == DownloadTaskStatus.complete) {
      Share.file(path: Uri.file("${task.savePath}/${task.book['title'].toString().replaceAll("/", "")+task.book['id'].toString().replaceAll("/", "")+'.'+task.book['extension']}").toFilePath(), text: 'hello', title: task.book['title']).share(
          sharePositionOrigin:
          box.localToGlobal(Offset.zero) &
          box.size);
    } else {
      Share.plainText(title: task.book['title'], text: task.book['title']+" by "+task.book['author']+". Download at: "+task.book['download']).share(
          sharePositionOrigin:
          box.localToGlobal(Offset.zero) &
          box.size);
    }
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      print('UI Isolate Callback: $data');
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];

//      final task = _tasks?.firstWhere((task) => task.taskId == id);
      if (task.taskId == id) {
        setState(() {
          task.status = status;
          task.progress = progress;
        });
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

   static void downloadCallback(
      String id, DownloadTaskStatus status, int prog) {
    print(
        'Background Isolate Callback: task ($id) is in status ($status) and process ($prog)');
    final SendPort send =
    IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, prog]);
  }

//  void fetchFiles() async {
//    var dir = await getExternalStorageDirectory();
//    List files = io.Directory(dir.path).listSync();
////    print(files);
//    List name = [];
//    files.forEach((element) {
//      name.add(element.toString().replaceAll("File: ", ""));
//    });
////    print(name);
//    var search = "'${dir.path}/${book['id']}.${book['extension']}'";
////    print(search);
//    if(name.contains(search)){
//      setState(() {
//        downloaded = true;
//      });
//    }
//  }

  Future<Null> _prepare() async {
    final tasks = await FlutterDownloader.loadTasks();

    task = _TaskInfo(book: book);
    tasks?.forEach((work) {
        if (task.book['download'] == work.url) {
          task.taskId = work.taskId;
          task.status = work.status;
          task.progress = work.progress;
          task.savePath = work.savedDir;
//          task.file = work.savedDir+'/'+work.filename;
//          print(task.file);
        }
    });


    _permissionReady = await _checkPermission();

    _localPath = (await _findLocalPath()) + '/Download';

    final savedDir = io.Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }

    setState(() {
      _isLoading = false;
    });
  }
  
  prefix0.Future<String> _findLocalPath() async {
    final directory = Theme.of(context).platform == TargetPlatform.android
        ?await getExternalStorageDirectory()
        :await getApplicationDocumentsDirectory();
    return directory.path;
  }

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;
    return Scaffold(
      body: Builder(builder: (context) =>
      _isLoading?Center(child:CircularProgressIndicator()):SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
                width: MediaQuery.of(context).size.width,
                child: GestureDetector(
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/placeholder.jpg',
                    image: book['cover'],
                    fit: BoxFit.fill,
                    height:MediaQuery.of(context).size.height ,),
                  onTap: () {
                    showDialog(context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Container(
                              width: 450,
                              child: FadeInImage.assetNetwork(
                                placeholder: 'assets/placeholder.jpg',
                                image: book['cover'],
                                fit: BoxFit.fill,),
                            ),
                            contentPadding: EdgeInsets.all(0.0),
                          );
                        });
                  },
                )
            ),
            Container(
              height: 70,
              padding: EdgeInsets.only(top: 20.0),
              color: Colors.black45,
              child: Row(
                children: <Widget>[
                  IconButton(icon: Icon(Icons.arrow_back),color: Colors.white, onPressed: () {
                    Navigator.pop(context);
                  },)
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/3),
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
//            alignment: Alignment.topLeft,
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.grey,
                      offset: Offset(0.0, 0.0),
                      blurRadius: 3.0,
                      spreadRadius: 1.0),]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(book['title'], style: TextStyle(color: Colors.black, fontSize: 22.0),textAlign: TextAlign.left,),
                  Padding(padding: EdgeInsets.only(top: 5.0),),
                Text(book['author'], style: TextStyle(color: Colors.grey[800], fontSize: 16.0),textAlign: TextAlign.left,),
                Padding(padding: EdgeInsets.only(top: 5.0),),
                Text(book['publisher'], style: TextStyle(color: Colors.grey[600], fontSize: 16.0),textAlign: TextAlign.left,),
                Padding(padding: EdgeInsets.only(top: 10.0)),
                  task.status == DownloadTaskStatus.complete? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child:  OutlineButton(onPressed: () {
                          _openDownloadedFile(task).then((success) {
                            if(!success) {
                              Scaffold.of(context).showSnackBar(SnackBar(content: Text('Cannot open file'),));
                            }
                          });
                        }, child: Text('Open'),
                          textColor: Colors.blue,
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),
                      Expanded(
                        flex: 1,
                        child: RaisedButton(onPressed: () {
                          _delete(task);
                        },
                          child: Text('Delete', style: prefix1.TextStyle(color: Colors.white),),
                          color: Colors.blue,),
                      )

                    ],
                  )
                      :task.status == DownloadTaskStatus.running?Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text('Downloading...', style: TextStyle(color: Colors.grey), textAlign: TextAlign.left,),
                          Spacer(),
                          Text((task.progress).toString()+'%', style: TextStyle(color: Colors.grey)),
                          Padding(padding: EdgeInsets.only(right: 40.0),)
                        ],
                      ),

                      Row(children: <Widget>[
                        SizedBox(
                          width: MediaQuery.of(context).size.width-70,
                          child: LinearProgressIndicator(value: task.progress/100,),
                        ),
                        Padding(padding: EdgeInsets.only(right: 5.0),),
                        GestureDetector(
                          onTap: () {
                            _cancelDownload(task);
                          },
                          child: Icon(Icons.close, color: Colors.grey,),
                        )
                      ],)
                    ],
                  ):Row(
                    children: <Widget>[
                      Expanded(
                          flex: 3,
                          child: RaisedButton(onPressed: () {
                            setState(() {
                              downloading = true;
                            });
                            _requestDownload(task);
//                          downloadBook();
                          }, child: Text('Download '+book['extension']+' ( '+book['size']+' )',style: TextStyle(color: Colors.white),),
                            color: Colors.blue,
                          ))
                    ],
                  ),
                  Divider(color: Colors.grey[700],),
                  Text(book['description'], style: prefix1.TextStyle(color: Colors.grey),),
                  Padding(padding: EdgeInsets.only(top: 20.0),),
                  Table(
                    children: [
                      TableRow(
                        children: [
                          Text('Title', style: prefix1.TextStyle(color: Colors.grey),),
                          Text(book['title']+'\n', style: prefix1.TextStyle(color: Colors.grey))
                        ]
                      ),
                      TableRow(
                          children: [
                            Text('Author', style: prefix1.TextStyle(color: Colors.grey),),
                            Text(book['author']+'\n', style: prefix1.TextStyle(color: Colors.grey))
                          ]
                      ),
                      TableRow(
                          children: [
                            Text('Volume', style: prefix1.TextStyle(color: Colors.grey),),
                            Text(book['volume']+'\n', style: prefix1.TextStyle(color: Colors.grey))
                          ]
                      ),
                      TableRow(
                          children: [
                            Text('Series', style: prefix1.TextStyle(color: Colors.grey),),
                            Text(book['series']+'\n', style: prefix1.TextStyle(color: Colors.grey))
                          ]
                      ),
                      TableRow(
                          children: [
                            Text('Edition', style: prefix1.TextStyle(color: Colors.grey),),
                            Text(book['edition']+'\n', style: prefix1.TextStyle(color: Colors.grey))
                          ]
                      ),
                      TableRow(
                          children: [
                            Text('Publication', style: prefix1.TextStyle(color: Colors.grey),),
                            Text(book['publisher']+'\n', style: prefix1.TextStyle(color: Colors.grey))
                          ]
                      ),
                      TableRow(
                          children: [
                            Text('Pages', style: prefix1.TextStyle(color: Colors.grey),),
                            Text(book['pages']+'\n', style: prefix1.TextStyle(color: Colors.grey))
                          ]
                      ),
                      TableRow(
                          children: [
                            Text('Language', style: prefix1.TextStyle(color: Colors.grey),),
                            Text(book['language']+'\n', style: prefix1.TextStyle(color: Colors.grey))
                          ]
                      ),
                      TableRow(
                          children: [
                            Text('Size', style: prefix1.TextStyle(color: Colors.grey),),
                            Text(book['size']+'\n', style: prefix1.TextStyle(color: Colors.grey))
                          ]
                      ),
                      TableRow(
                          children: [
                            Text('Year', style: prefix1.TextStyle(color: Colors.grey),),
                            Text(book['year']+'\n', style: prefix1.TextStyle(color: Colors.grey))
                          ]
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: OutlineButton(
                          textColor: Colors.blue,
                          borderSide: BorderSide(color: Colors.blue),
                          child: Text('Share'),
                          onPressed: () {
//                            ShareExtend.share("${task.book['title']} by ${task.book['author']}. \n Download at: \n${task.book['download']}", "text");
//                              ShareExtend.share('hello', "text");
                          share();

                          },
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ))
    );
  }
}

class _TaskInfo {
  final book;
  String savePath;
  String taskId;
  int progress = 0;
  DownloadTaskStatus status = DownloadTaskStatus.undefined;
//  String file;

  _TaskInfo({this.book});
}

