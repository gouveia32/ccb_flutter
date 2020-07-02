import 'Parametro_Db_Helper.dart';

class Model {
  static final Model _model = new Model._internal();

  factory Model() {
    return _model;
  }

  Model._internal();

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<Parametro> read() async {
    return _databaseHelper.read();
  }
}

class Parametro {
  String _host;
  String _user;
  String _password;
  String _db;

  Parametro(this._host, this._user, this._password, this._db);

  String get host => _host;
  String get user => _user;
  String get password => _password;
  String get db => _db;

  set host(String newHost) {
    this._host = newHost;
  }

  set user(String newUser) {
    this._user = newUser;
  }

  set password(String newPassword) {
    this._password = newPassword;
  }

  set db(String newDb) {
    this._db = newDb;
  }
}
