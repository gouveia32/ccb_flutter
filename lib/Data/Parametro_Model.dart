class Model {
  static final Model _model = new Model._internal();

  factory Model() {
    return _model;
  }

  Model._internal();
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
    if (newHost != null) {
      this._host = newHost;
    }
  }

  set user(String newUser) {
    if (newUser != null) {
      this._user = newUser;
    }
  }

  set password(String newPassword) {
    if (newPassword != null) {
      this._password = newPassword;
    }
  }

  set db(String newDb) {
    if (newDb != null) {
      this._db = newDb;
    }
  }
}
