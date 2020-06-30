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
  Parametro _prm;

  Model _model = Model();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _hostController = TextEditingController();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _dbController = TextEditingController();

  final FocusNode _hostFocus = FocusNode();
  final FocusNode _userFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _dbFocus = FocusNode();

  ParametroDetailState(_prm, this._appBarTitle);

  @override
  initState() {
    super.initState();

    //_prm = Parametro('', '', '', '');

    _getMoreData();
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
    if (_prm == null) {
      _getMoreData();
      //_totItens = _clienteList.length;
    }
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
                          _prm.host = value;
                        },
                        validator: (String value) {
                          _prm.host = _hostController.text;
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
                                _prm.user = _userController.text;
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
                                _prm.password = _passwordController.text;
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
                          _prm.db = _dbController.text;
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

  Future<Parametro> _read() async {
    final prefs = await SharedPreferences.getInstance();
    Parametro prm = Parametro('', '', '', '');
    prm.host = prefs.getString('host') ?? 'localhost';
    prm.user = prefs.getString('user') ?? 'ccb';
    prm.password = prefs.getString('password') ?? 'Poqw0001';
    prm.db = prefs.getString('db') ?? 'ccb';

    print('host: ${prm.host}');
    //this._prm = prm;
    return prm;
  }

  _save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('host', _prm.host);
    prefs.setString('user', _prm.user);
    prefs.setString('password', _prm.password);
    prefs.setString('db', _prm.db);
    print('saved ${_prm.host}');
    Navigator.pop(context, true);
  }

  restore() async {
    print('restoring...');
    Parametro prm = Parametro('', '', '', '');
    SharedPreferences sharedPrefs;
    sharedPrefs = await SharedPreferences.getInstance().then((value) {
      this._prm.host = sharedPrefs.getString('host');
      this._prm.user = sharedPrefs.getString('user');
      this._prm.password = sharedPrefs.getString('password');
      this._prm.db = sharedPrefs.getString('db');
    });
  }

  _getMoreData() {
    Future<Parametro> prmFuture = _model.read();
    prmFuture.then((prm) {
      setState(() {
        this._prm = prm;
      });
    }).catchError((e) async {
      print(e.toString());
    });
  }
}
