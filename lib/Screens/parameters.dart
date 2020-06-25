import 'package:shared_preferences/shared_preferences.dart';

import '../Data/Parametro_Model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ParametroDetail extends StatefulWidget {
  final String _appBarTitle;
  final Parametro _parametro;

  ParametroDetail(this._parametro, this._appBarTitle);

  static const routeName = '/parametros';

  @override
  State<StatefulWidget> createState() {
    return ParametroDetailState(this._parametro, this._appBarTitle);
  }
}

class ParametroDetailState extends State<ParametroDetail> {
  //Model _model = Model();

  final String _appBarTitle;
  Parametro _parametro;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _hostController = TextEditingController();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _dbController = TextEditingController();

  final FocusNode _hostFocus = FocusNode();
  final FocusNode _userFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _dbFocus = FocusNode();

  ParametroDetailState(this._parametro, this._appBarTitle);

  @override
  void initState() {
    super.initState();

    if (!_appBarTitle.contains('Alterar')) {
      _parametro = Parametro('10.0.3.2', 'root', 'ebtaju', 'ccb');
      _read();
    }
    _hostController.text = _parametro.host;
    _userController.text = _parametro.user;
    _passwordController.text = _parametro.password;
    _dbController.text = _parametro.db;
  }

  @override
  void dispose() {
    _hostController.dispose();
    _userController.dispose();
    _passwordController.dispose();
    _dbController.dispose();

    _hostFocus.dispose();
    _userFocus.dispose();
    _passwordFocus.dispose();
    _dbFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline5;
    return WillPopScope(
      onWillPop: () {
        // For when user presses Back navigation button in device navigationBar (Android)
        Navigator.pop(context, false);
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            _appBarTitle,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context, false);
              }),
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                child: ListView(
                  children: <Widget>[
                    // Name
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 30.0, bottom: 15.0, left: 6.0, right: 6.0),
                      child: TextFormField(
                        controller: _hostController,
                        autocorrect: false,
                        textInputAction: TextInputAction.next,
                        focusNode: _hostFocus,
                        //enabled: (_appBarTitle == 'Add Parametro'), // name is the key. can't change it. must delete and re-create.
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
                            return 'Não pode ser branco';
                          } else if (value.length > 19) {
                            return 'host deve ter no máximo 20 caracteres.';
                          }
                        },
                        style: textStyle,
                        decoration: _inputDecoration(textStyle, "host"),
                      ),
                    ),
                    // Home and Mobile Phones
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: 170,
                          height: 50,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(bottom: 15.0, left: 6.0),
                            child: TextFormField(
                              controller: _userController,
                              //keyboardType: TextInputType.number,
                              autocorrect: false,
                              textInputAction: TextInputAction.next,
                              focusNode: _userFocus,
                              onFieldSubmitted: (term) {
                                _userFocus.unfocus();
                                FocusScope.of(context)
                                    .requestFocus(_passwordFocus);
                              },
                              style: textStyle,
                              validator: (String value) {
                                _parametro.user = _userController.text;
                                if (value.length > 19) {
                                  return "Phone numbers must be less than 30 characters";
                                }
                              },
                              decoration: _inputDecoration(textStyle, "user"),
                            ),
                          ),
                        ),
                        Container(
                          width: 170,
                          height: 50,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(bottom: 15.0, right: 6.0),
                            child: TextFormField(
                              controller: _passwordController,
                              //keyboardType: TextInputType.phone,
                              autocorrect: false,
                              textInputAction: TextInputAction.next,
                              focusNode: _passwordFocus,
                              onFieldSubmitted: (term) {
                                _passwordFocus.unfocus();
                                FocusScope.of(context).requestFocus(_dbFocus);
                              },
                              style: textStyle,
                              validator: (String value) {
                                _parametro.password = _passwordController.text;
                                if (value.length > 29) {
                                  return "Phone numbers must be less than 30 characters";
                                }
                              },
                              decoration:
                                  _inputDecoration(textStyle, "password"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Email
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 30.0, bottom: 15.0, left: 6.0, right: 6.0),
                      child: TextFormField(
                        controller: _dbController,
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        textInputAction: TextInputAction.next,
                        focusNode: _dbFocus,
                        onFieldSubmitted: (term) {
                          _dbFocus.unfocus();
                          FocusScope.of(context).requestFocus(_hostFocus);
                        },
                        validator: (String value) {
                          _parametro.db = _dbController.text;
                          if (value.length > 19) {
                            return 'Email must be less than 20 characters';
                          }
                        },
                        style: textStyle,
                        decoration: _inputDecoration(textStyle, "db"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                      child: RaisedButton(
                        color: Theme.of(context).accentColor,
                        textColor: Theme.of(context).primaryColorDark,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        child: Text(
                          'Gravar',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          setState(() {
                            if (_formKey.currentState.validate()) {
                              _save();
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
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

  _read() async {
    final prefs = await SharedPreferences.getInstance();
    _parametro.host = await prefs.getString('host');
    _parametro.user = await prefs.getString('user');
    _parametro.password = await prefs.getString('password');
    _parametro.db = await prefs.getString('db');

    print('host: ${_parametro.host}');
  }

  _save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('host', _parametro.host);
    prefs.setString('user', _parametro.user);
    prefs.setString('password', _parametro.password);
    prefs.setString('db', _parametro.db);
    print('saved ${_parametro.host}');
    Navigator.pop(context, true);
  }
}
