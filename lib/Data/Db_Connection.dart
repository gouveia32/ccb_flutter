import 'package:mysql1/mysql1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Parametro_Model.dart';

class DbHelper {
  static DbHelper _dbHelper;

  DbHelper._createInstance();

  factory DbHelper() {
    if (_dbHelper == null) {
      _dbHelper = DbHelper._createInstance();
    }
    return _dbHelper;
  }

  Future<Parametro> _read() async {
    final prefs = await SharedPreferences.getInstance();
    Parametro parametro = Parametro('', '', '', '');
    parametro.host = prefs.getString('host') ?? 'localhost';
    parametro.user = prefs.getString('user') ?? 'ccb';
    parametro.password = prefs.getString('password') ?? 'Poqw0001';
    parametro.db = prefs.getString('db') ?? 'ccb';
    return parametro;
  }

  Future<MySqlConnection> get databaseConnection async {
    Parametro prm = await _read();
    MySqlConnection _databaseConnection;

    try {
      _databaseConnection = await MySqlConnection.connect(ConnectionSettings(
          host: prm.host,
          port: 3306,
          user: prm.user,
          db: prm.db,
          password: prm.password));
    } catch (e) {
      print(e.toString());
      rethrow;
    }
    return _databaseConnection;
  }
}
