import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import './Parametro_Model.dart';

class DatabaseHelper {
  Future<Parametro> read() async {
    final prefs = await SharedPreferences.getInstance();
    Parametro prm = Parametro('', '', '', '');

    if (prefs != null) {
      prm.host = prefs.getString('host') ?? 'localhost';
      prm.user = prefs.getString('user') ?? 'ccb';
      prm.password = prefs.getString('password') ?? 'Poqw0001';
      prm.db = prefs.getString('db') ?? 'ccb';
      print('host: ${prm.host} usr: ${prm.user}');
    }

    //this._prm = prm;
    return prm;
  }
}
