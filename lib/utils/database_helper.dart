import 'dart:async' as prefix0;

import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_app/model/favorite.dart';

class DatabaseHelper {

  static DatabaseHelper _databaseHelper;
  static Database _database;

  String favoriteTable = 'favorite';
  String colId = 'id';
  String colTitle = 'title';
  String colVolume = 'volume';
  String colSeries = 'series';
  String colAuthor = 'author';
  String colEdition = 'edition';
  String colPublisher = 'publisher';
  String colCity = 'city';
  String colPages = 'pages';
  String colLanguage = 'language';
  String colDownload = 'download';
  String colCover = 'cover';
  String colSize = 'size';
  String colYear = 'year';
  String colDescription = 'description';
  String colTopic = 'topic';
  String colExtension = 'extension';

  DatabaseHelper._createInstance();

  Future<Database> intialiseDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'favorites.db';

    var favoritesDatabase = openDatabase(path, version: 1, onCreate: _createDb);
    return favoritesDatabase;
  }

  Future<Database> get database async {
    if(_database == null){
      _database = await intialiseDatabase();
    }
    return _database;
  }

  factory DatabaseHelper() {
    if(_databaseHelper == null)
      _databaseHelper = DatabaseHelper._createInstance();
    return _databaseHelper;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $favoriteTable($colId TEXT PRIMARY KEY,'
        '$colTitle TEXT,'
        '$colVolume TEXT,'
        '$colSeries TEXT,'
        '$colAuthor TEXT,'
        '$colEdition TEXT,'
        '$colPublisher TEXT,'
        '$colCity TEXT,'
        '$colPages TEXT,'
        '$colLanguage TEXT,'
        '$colDownload TEXT,'
        '$colCover TEXT,'
        '$colSize TEXT,'
        '$colYear TEXT,'
        '$colDescription TEXT,'
        '$colTopic TEXT,'
        '$colExtension TEXT'
        ')');
  }

  prefix0.Future<List<Map<String, dynamic>>> fetchBook() async {
    Database db = await this.database;

    var result = await db.query(favoriteTable);
//    print(result.toList().runtimeType);
    return result.toList();
  }

  Future<List<Map<String, dynamic>>> fetchBookById(String id) async {
    Database db = await this.database;

    var result = await db.query(favoriteTable, where: '$colId = $id');
    return result.toList();
  }

  Future<int> insertBook(FavouriteBook book) async {
    Database db = await this.database;

    var result = await db.insert(favoriteTable, book.toMap());

    return result;
  }

  Future<int> deleteBook(String id) async {
    Database db = await this.database;

    var result = await db.delete(favoriteTable, where: '$colId = $id');

    return result;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, String>> x = await db.rawQuery('SELECT COUNT (*) FROM $favoriteTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

}