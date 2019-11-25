class FavouriteBook {
  String _id;
  String _title;
  String _volume;
  String _series;
  String _author;
  String _edition;
  String _publisher;
  String _city;
  String _pages;
  String _language;
  String _download;
  String _cover;
  String _size;
  String _year;
  String _description;
  String _topic;
  String _extension;

  FavouriteBook(
      this._id,
      this._title,
      this._volume,
      this._series,
      this._author,
      this._edition,
      this._publisher,
      this._city,
      this._pages,
      this._language,
      this._download,
      this._cover,
      this._size,
      this._year,
      this._description,
      this._topic,
      this._extension);

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  String get volume => _volume;

  set volume(String value) {
    _volume = value;
  }

  String get series => _series;

  set series(String value) {
    _series = value;
  }

  String get author => _author;

  set author(String value) {
    _author = value;
  }

  String get edition => _edition;

  set edition(String value) {
    _edition = value;
  }

  String get publisher => _publisher;

  set publisher(String value) {
    _publisher = value;
  }

  String get city => _city;

  set city(String value) {
    _city = value;
  }

  String get pages => _pages;

  set pages(String value) {
    _pages = value;
  }

  String get language => _language;

  set language(String value) {
    _language = value;
  }

  String get download => _download;

  set download(String value) {
    _download = value;
  }

  String get cover => _cover;

  set cover(String value) {
    _cover = value;
  }

  String get size => _size;

  set size(String value) {
    _size = value;
  }

  String get year => _year;

  set year(String value) {
    _year = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  String get topic => _topic;

  set topic(String value) {
    _topic = value;
  }

  String get extension => _extension;

  set extension(String value) {
    _extension = value;
  }

  Map<String, String> toMap() {
    var map = Map<String, String>();
    map['id'] = _id;
    map['title'] = _title;
    map['volume'] = _volume;
    map['series'] = _series;
    map['author'] = _author;
    map['edition'] = _edition;
    map['publisher'] = _publisher;
    map['city'] = _city;
    map['pages'] = _pages;
    map['language'] = _language;
    map['download'] = _download;
    map['cover'] = _cover;
    map['size'] = _size;
    map['year'] = _year;
    map['description'] = _description;
    map['topic'] = _topic;
    map['extension'] = _extension;

    return map;
  }

  FavouriteBook.fromMap(Map<String, String> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._volume = map['volume'];
    this._series = map['series'];
    this._author = map['author'];
    this._edition = map['edition'];
    this._publisher = map['publisher'];
    this._city = map['city'];
    this._pages = map['pages'];
    this._language = map['language'];
    this._download = map['download'];
    this._cover = map['cover'];
    this._size = map['size'];
    this._year = map['year'];
    this._description = map['description'];
    this._topic = map['topic'];
    this._extension = map['extension'];
  }
}
