import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';

class Model {
  static final Model _model = new Model._internal();

  factory Model() {
    return _model;
  }

  Model._internal();
}

class Parametro {
  String host = '10.0.2.2';
  String user = 'root';
  String bd = 'ccb';
  String password = 'ebtaju';

  Parametro(this.host, this.user, this.bd, this.password);
}

class ParametroEdit extends StatefulWidget {
  final String _appBarTitle;
  final Parametro _parametro;

  static const routeName = '/parameters';

  ParametroEdit(this._parametro, this._appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return ParametroState(this._parametro, this._appBarTitle);
  }
}

class ParametroState extends State<ParametroEdit> {
  Model _model = Model();

  final String _appBarTitle;
  Parametro _parametro;

  final TextEditingController _hostController = TextEditingController();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _bdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final FocusNode _hostFocus = FocusNode();
    final FocusNode _userFocus = FocusNode();
    final FocusNode _bdFocus = FocusNode();
    final FocusNode _passwordFocus = FocusNode();

    ParametroState(this._parametro, this._appBarTitle);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline6;
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Parâmetros'),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
                top: 60.0, bottom: 10.0, left: 6.0, right: 6.0),
            child: TextFormField(
              controller: _hostController,
              autocorrect: false,
              textInputAction: TextInputAction.next,
              enabled:
                  true, // name is the key. can't change it. must delete and re-create.
              onFieldSubmitted: (term) {
                _hostFocus.unfocus();
                FocusScope.of(context).requestFocus(_userFocus);
              },
              onSaved: (String value) {
                print("OnSaved: $value");
                _parametro.host = value;
              },
              validator: (String value) {
                _parametro.host = _hostController.text;
                if (value.isEmpty) {
                  return 'host é obrigatório';
                } else if (value.length > 119) {
                  return 'host deve ter no máximo 120 caracters';
                }
              },
              style: textStyle,
              decoration: _inputDecoration(textStyle, "Host"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              child: Text('Read'),
              onPressed: () {
                _read();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              child: Text('Save'),
              onPressed: () {
                _save();
              },
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(TextStyle textStyle, String text) {
    return InputDecoration(
        labelText: text,
        labelStyle: textStyle,
        errorStyle: TextStyle(color: Colors.yellowAccent, fontSize: 15.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)));
  }

  // Replace these two methods in the examples that follow

  _read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'my_int_key';
    final value = prefs.getInt(key) ?? 0;
    print('read: $value');
  }

  _save() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'my_int_key';
    final value = 42;
    prefs.setInt(key, value);
    print('saved $value');
  }
}
