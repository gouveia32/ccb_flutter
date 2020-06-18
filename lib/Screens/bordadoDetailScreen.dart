import '../Data/Bordado_Model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class BordadoDetail extends StatefulWidget {
  final String _appBarTitle;
  final Bordado _bordado;

  BordadoDetail(this._bordado, this._appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return BordadoDetailState(this._bordado, this._appBarTitle);
  }
}

class BordadoDetailState extends State<BordadoDetail> {
  Model _model = Model();

  static const routeName = '/bordado-detail-list';

  final String _appBarTitle;
  Bordado _bordado;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _arquivoController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _caminhoController = TextEditingController();
  final TextEditingController _disqueteController = TextEditingController();
  final TextEditingController _bastidorController = TextEditingController();

  final FocusNode _arquivoFocus = FocusNode();
  final FocusNode _descricaoFocus = FocusNode();
  final FocusNode _caminhoFocus = FocusNode();
  final FocusNode _disqueteFocus = FocusNode();
  final FocusNode _bastidorFocus = FocusNode();

  BordadoDetailState(this._bordado, this._appBarTitle);

  @override
  void initState() {
    super.initState();

    if (_appBarTitle == "Alterar Bordado") {
      _arquivoController.text = _bordado.arquivo;
      _descricaoController.text = _bordado.descricao;
      _caminhoController.text = _bordado.caminho;

      _disqueteController.text = _bordado.disquete;
      _bastidorController.text = _bordado.bastidor;
    }
  }

  @override
  void dispose() {
    _arquivoController.dispose();
    _descricaoController.dispose();
    _caminhoController.dispose();
    _disqueteController.dispose();
    _bastidorController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline6;

    return WillPopScope(
      onWillPop: () {
        // For when user presses Back navigation button in device navigationBar (Android)
        _returnToHomePage(false);
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
                _returnToHomePage(false);
              }),
        ),
        body: Center(
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
                          top: 20.0, bottom: 10.0, left: 6.0, right: 6.0),
                      child: TextFormField(
                        controller: _arquivoController,
                        autocorrect: false,
                        textInputAction: TextInputAction.next,
                        focusNode: _arquivoFocus,
                        enabled: (_appBarTitle ==
                            'Add Contact'), // name is the key. can't change it. must delete and re-create.
                        onFieldSubmitted: (term) {
                          _arquivoFocus.unfocus();
                          FocusScope.of(context).requestFocus(_descricaoFocus);
                        },
                        onSaved: (String value) {
                          print("OnSaved: $value");
                          _bordado.arquivo = value;
                        },
                        validator: (String value) {
                          _bordado.arquivo = _arquivoController.text;
                          if (value.isEmpty) {
                            return 'Arquivo é obrigatório';
                          } else if (value.length > 119) {
                            return 'Arquivo deve ter no máximo 120 caracters';
                          }
                        },
                        style: textStyle,
                        decoration: _inputDecoration(textStyle, "Arquivo"),
                      ),
                    ),
                    // Home and Mobile Phones
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 133,
                          height: 50,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(bottom: 15.0, left: 6.0),
                            child: TextFormField(
                              controller: _descricaoController,
                              //keyboardType: TextInputType.number,
                              autocorrect: false,
                              textInputAction: TextInputAction.next,
                              focusNode: _descricaoFocus,
                              onFieldSubmitted: (term) {
                                _descricaoFocus.unfocus();
                                FocusScope.of(context)
                                    .requestFocus(_descricaoFocus);
                              },
                              style: TextStyle(fontSize: 16.0),
                              validator: (String value) {
                                _bordado.caminho = _caminhoController.text;
                                if (value.length > 19) {
                                  return "Descrição deve ter no máximo que 20 caracters";
                                }
                              },
                              decoration:
                                  _inputDecoration(textStyle, "Descrição"),
                            ),
                          ),
                        ),
                        Container(
                          width: 270,
                          height: 50,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(bottom: 15.0, right: 6.0),
                            child: TextFormField(
                              controller: _caminhoController,
                              //keyboardType: TextInputType.phone,
                              autocorrect: false,
                              textInputAction: TextInputAction.next,
                              focusNode: _caminhoFocus,
                              onFieldSubmitted: (term) {
                                _caminhoFocus.unfocus();
                                FocusScope.of(context)
                                    .requestFocus(_caminhoFocus);
                              },
                              style: TextStyle(fontSize: 16.0),
                              validator: (String value) {
                                _bordado.caminho = _caminhoController.text;
                                if (value.length > 19) {
                                  return "Caminho deve ter no máximo 20 caracters";
                                }
                              },
                              decoration:
                                  _inputDecoration(textStyle, "Caminho"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 133,
                          height: 50,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(bottom: 15.0, left: 6.0),
                            child: TextFormField(
                              controller: _disqueteController,
                              //keyboardType: TextInputType.number,
                              autocorrect: false,
                              textInputAction: TextInputAction.next,
                              focusNode: _disqueteFocus,
                              onFieldSubmitted: (term) {
                                _disqueteFocus.unfocus();
                                FocusScope.of(context)
                                    .requestFocus(_disqueteFocus);
                              },
                              style: TextStyle(fontSize: 16.0),
                              validator: (String value) {
                                _bordado.disquete = _disqueteController.text;
                                if (value.length > 19) {
                                  return "Telefone deve ter no máximo que 20 caracters";
                                }
                              },
                              decoration:
                                  _inputDecoration(textStyle, "Disquete"),
                            ),
                          ),
                        ),
                        Container(
                          width: 133,
                          height: 50,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(bottom: 15.0, right: 6.0),
                            child: TextFormField(
                              controller: _bastidorController,
                              //keyboardType: TextInputType.phone,
                              autocorrect: false,
                              textInputAction: TextInputAction.next,
                              focusNode: _bastidorFocus,
                              onFieldSubmitted: (term) {
                                _bastidorFocus.unfocus();
                                FocusScope.of(context)
                                    .requestFocus(_bastidorFocus);
                              },
                              style: TextStyle(fontSize: 16.0),
                              validator: (String value) {
                                _bordado.bastidor = _bastidorController.text;
                                if (value.length > 19) {
                                  return "Bastidor deve ter no máximo 20 caracters";
                                }
                              },
                              decoration:
                                  _inputDecoration(textStyle, "Bastidor"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Notes
                    Padding(
                      padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                      child: RaisedButton(
                        color: Theme.of(context).accentColor,
                        textColor: Theme.of(context).primaryColorDark,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        child: Text(
                          'Save',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          setState(() {
                            if (_formKey.currentState.validate()) {
                              _saveorUpdateContact();
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

  void _saveorUpdateContact() async {
    if (_appBarTitle != "Adicionar Bordado") {
      try {
        await _model.updateBordado(_bordado);
        _returnToHomePage(true);
      } catch (e) {
        print(e);
        showAlertDialog(context, 'Status', 'Error updating contact.');
      }
    } else {
      try {
        await _model.insertBordado(_bordado);
        _returnToHomePage(true);
      } catch (e) {
        print(e);
        showAlertDialog(context, 'Status', 'Error adding contact.');
      }
    }
  }

  void _returnToHomePage(bool refreshListDisplay) {
    Navigator.pop(context, refreshListDisplay);
  }
}

void showAlertDialog(BuildContext context, String title, String message) {
  AlertDialog alertDialog = AlertDialog(
    title: Text(title),
    content: Text(message),
  );
  showDialog(context: context, builder: (_) => alertDialog);
}
