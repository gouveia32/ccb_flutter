import '../Data/Linha_Model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class LinhaDetail extends StatefulWidget {
  final String _appBarTitle;
  final Linha _linha;

  LinhaDetail(this._linha, this._appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return LinhaDetailState(this._linha, this._appBarTitle);
  }
}

class LinhaDetailState extends State<LinhaDetail> {
  Model _model = Model();

  final String _appBarTitle;
  Linha _linha;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _codigoController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _materialNomeController = TextEditingController();
  final TextEditingController _materialFabricanteController =
      TextEditingController();
  final TextEditingController _materialTipoController = TextEditingController();
  final TextEditingController _corController = TextEditingController();
  final TextEditingController _estoque1Controller = TextEditingController();
  final TextEditingController _estoque2Controller = TextEditingController();
  final TextEditingController _minimoController = TextEditingController();
  final TextEditingController _pedidoController = TextEditingController();

  final FocusNode _codigoFocus = FocusNode();
  final FocusNode _nomeFocus = FocusNode();
  final FocusNode _materialNomeFocus = FocusNode();
  final FocusNode _materialFabricanteFocus = FocusNode();
  final FocusNode _materialTipoFocus = FocusNode();
  final FocusNode _corFocus = FocusNode();
  final FocusNode _estoque1Focus = FocusNode();
  final FocusNode _estoque2Focus = FocusNode();
  final FocusNode _minimoFocus = FocusNode();
  final FocusNode _pedidoFocus = FocusNode();

  LinhaDetailState(this._linha, this._appBarTitle);

  @override
  void initState() {
    super.initState();

    if (_appBarTitle == "Alterar Linha") {
      _codigoController.text = _linha.codigo;
      _nomeController.text = _linha.nome;
      _materialNomeController.text = _linha.materialNome;
      _materialFabricanteController.text = _linha.materialFabricante;
      _materialTipoController.text = _linha.materialTipo;
      _corController.text = _linha.cor.toString();
      _estoque1Controller.text = _linha.estoque_1.toString();
      _estoque2Controller.text = _linha.estoque_2.toString();
      _minimoController.text = _linha.minimo.toString();
      _pedidoController.text = _linha.pedido.toString();
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _materialNomeController.dispose();
    _materialFabricanteController.dispose();
    _materialTipoController.dispose();
    _corController.dispose();
    _estoque1Controller.dispose();
    _estoque2Controller.dispose();
    _minimoController.dispose();
    _pedidoController.dispose();

    _nomeFocus.dispose();
    _materialNomeFocus.dispose();
    _materialFabricanteFocus.dispose();
    _materialTipoFocus.dispose();
    _corFocus.dispose();
    _estoque1Focus.dispose();
    _estoque2Focus.dispose();
    _minimoFocus.dispose();
    _pedidoFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline5;
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
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                child: ListView(
                  children: <Widget>[
                    // Codigo
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 30.0, bottom: 15.0, left: 6.0, right: 6.0),
                      child: TextFormField(
                        controller: _codigoController,
                        autocorrect: false,
                        textInputAction: TextInputAction.next,
                        focusNode: _codigoFocus,
                        //enabled: (_appBarTitle == 'Add Linha'), // name is the key. can't change it. must delete and re-create.
                        onFieldSubmitted: (term) {
                          _codigoFocus.unfocus();
                          FocusScope.of(context).requestFocus(_nomeFocus);
                        },
                        onSaved: (String value) {
                          print("OnSaved: $value");
                          _linha.codigo = value;
                        },
                        validator: (String value) {
                          _linha.codigo = _codigoController.text;
                          if (value.isEmpty) {
                            return 'Gotta have a name';
                          } else if (value.length > 79) {
                            return 'Name must be less than 80 characters';
                          }
                        },
                        style: textStyle,
                        decoration: _inputDecoration(textStyle, "Código"),
                      ),
                    ),
                    // Name
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 30.0, bottom: 15.0, left: 6.0, right: 6.0),
                      child: TextFormField(
                        controller: _nomeController,
                        autocorrect: false,
                        textInputAction: TextInputAction.next,
                        focusNode: _nomeFocus,
                        //enabled: (_appBarTitle == 'Add Linha'), // name is the key. can't change it. must delete and re-create.
                        onFieldSubmitted: (term) {
                          _nomeFocus.unfocus();
                          FocusScope.of(context)
                              .requestFocus(_materialNomeFocus);
                        },
                        onSaved: (String value) {
                          print("OnSaved: $value");
                          _linha.nome = value;
                        },
                        validator: (String value) {
                          _linha.nome = _nomeController.text;
                          if (value.isEmpty) {
                            return 'Gotta have a name';
                          } else if (value.length > 79) {
                            return 'Name must be less than 80 characters';
                          }
                        },
                        style: textStyle,
                        decoration: _inputDecoration(textStyle, "Name"),
                      ),
                    ),

                    // Material Nome
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 30.0, bottom: 15.0, left: 6.0, right: 6.0),
                      child: TextFormField(
                        controller: _materialNomeController,
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        textInputAction: TextInputAction.next,
                        focusNode: _materialNomeFocus,
                        onFieldSubmitted: (term) {
                          _materialNomeFocus.unfocus();
                          FocusScope.of(context)
                              .requestFocus(_materialFabricanteFocus);
                        },
                        validator: (String value) {
                          _linha.materialNome = _materialNomeController.text;
                          if (value.length > 59) {
                            return 'O nome do fabricante de ser menor do que 30 characteres';
                          }
                        },
                        style: textStyle,
                        decoration: _inputDecoration(textStyle, "Material"),
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
                          'Save',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          setState(() {
                            if (_formKey.currentState.validate()) {
                              _saveorUpdateLinha();
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

  void _saveorUpdateLinha() async {
    if (_appBarTitle != "Nova Linha") {
      try {
        await _model.updateLinha(_linha);
        _returnToHomePage(true);
      } catch (e) {
        print(e);
        showAlertDialog(context, 'Status', 'Error updating linha.');
      }
    } else {
      try {
        await _model.insertLinha(_linha);
        _returnToHomePage(true);
      } catch (e) {
        print(e);
        showAlertDialog(context, 'Status', 'Error adding linha.');
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
