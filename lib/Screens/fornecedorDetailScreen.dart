import '../Data/Fornecedor_Model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class FornecedorDetail extends StatefulWidget {
  final String _appBarTitle;
  final Fornecedor _fornecedor;

  FornecedorDetail(this._fornecedor, this._appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return FornecedorDetailState(this._fornecedor, this._appBarTitle);
  }
}

class FornecedorDetailState extends State<FornecedorDetail> {
  Model _model = Model();

  static const routeName = '/fornecedor-detail-list';

  final String _appBarTitle;
  Fornecedor _fornecedor;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _contatoFuncaoController =
      TextEditingController();
  final TextEditingController _contatoNomeController = TextEditingController();
  final TextEditingController _cgcCpfController = TextEditingController();
  final TextEditingController _inscrEstadualController =
      TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _telefone1Controller = TextEditingController();
  final TextEditingController _telefone2Controller = TextEditingController();
  final TextEditingController _telefone3Controller = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _obsController = TextEditingController();
  final TextEditingController _precoBaseController = TextEditingController();

  final FocusNode _nomeFocus = FocusNode();
  final FocusNode _contatoFuncaoFocus = FocusNode();
  final FocusNode _contatoNomeFocus = FocusNode();
  final FocusNode _enderecoFocus = FocusNode();
  final FocusNode _cidadeFocus = FocusNode();
  final FocusNode _estadoFocus = FocusNode();
  final FocusNode _cepFocus = FocusNode();
  final FocusNode _telefone1Focus = FocusNode();
  final FocusNode _telefone2Focus = FocusNode();
  final FocusNode _telefone3Focus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _obsFocus = FocusNode();
  final FocusNode _precoBaseFocus = FocusNode();

  FornecedorDetailState(this._fornecedor, this._appBarTitle);

  @override
  void initState() {
    super.initState();

    if (_appBarTitle == "Alterar Fornecedor") {
      _nomeController.text = _fornecedor.nome;
      _contatoFuncaoController.text = _fornecedor.contatoFuncao;
      _contatoNomeController.text = _fornecedor.contatoNome;

      _cgcCpfController.text = _fornecedor.cgcCpf;
      _inscrEstadualController.text = _fornecedor.inscrEstadual;
      _enderecoController.text = _fornecedor.endereco;
      _cidadeController.text = _fornecedor.cidade;
      _estadoController.text = _fornecedor.estado;
      _cepController.text = _fornecedor.cep;
      _telefone1Controller.text = _fornecedor.telefone1;
      _telefone2Controller.text = _fornecedor.telefone2;
      _telefone3Controller.text = _fornecedor.telefone3;
      _emailController.text = _fornecedor.email;
      _obsController.text = _fornecedor.obs;
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _contatoFuncaoController.dispose();
    _contatoNomeController.dispose();
    _cgcCpfController.dispose();
    _inscrEstadualController.dispose();
    _enderecoController.dispose();
    _cidadeController.dispose();
    _estadoController.dispose();
    _cepController.dispose();
    _telefone1Controller.dispose();
    _telefone2Controller.dispose();
    _telefone3Controller.dispose();
    _emailController.dispose();
    _obsController.dispose();
    _precoBaseController.dispose();

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
                        controller: _nomeController,
                        autocorrect: false,
                        textInputAction: TextInputAction.next,
                        focusNode: _nomeFocus,
                        enabled: (_appBarTitle ==
                            'Add Contact'), // name is the key. can't change it. must delete and re-create.
                        onFieldSubmitted: (term) {
                          _nomeFocus.unfocus();
                          FocusScope.of(context).requestFocus(_telefone1Focus);
                        },
                        onSaved: (String value) {
                          print("OnSaved: $value");
                          _fornecedor.nome = value;
                        },
                        validator: (String value) {
                          _fornecedor.nome = _nomeController.text;
                          if (value.isEmpty) {
                            return 'Nome é obrigatório';
                          } else if (value.length > 119) {
                            return 'Nome deve ter no máximo 120 caracters';
                          }
                        },
                        style: textStyle,
                        decoration: _inputDecoration(textStyle, "Name"),
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
                              controller: _contatoNomeController,
                              //keyboardType: TextInputType.number,
                              autocorrect: false,
                              textInputAction: TextInputAction.next,
                              focusNode: _contatoFuncaoFocus,
                              onFieldSubmitted: (term) {
                                _contatoFuncaoFocus.unfocus();
                                FocusScope.of(context)
                                    .requestFocus(_contatoFuncaoFocus);
                              },
                              style: TextStyle(fontSize: 16.0),
                              validator: (String value) {
                                _fornecedor.contatoNome =
                                    _contatoFuncaoController.text;
                                if (value.length > 19) {
                                  return "Telefone deve ter no máximo que 20 caracters";
                                }
                              },
                              decoration: _inputDecoration(textStyle, "Função"),
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
                              controller: _contatoNomeController,
                              //keyboardType: TextInputType.phone,
                              autocorrect: false,
                              textInputAction: TextInputAction.next,
                              focusNode: _contatoNomeFocus,
                              onFieldSubmitted: (term) {
                                _contatoNomeFocus.unfocus();
                                FocusScope.of(context)
                                    .requestFocus(_contatoNomeFocus);
                              },
                              style: TextStyle(fontSize: 16.0),
                              validator: (String value) {
                                _fornecedor.contatoNome =
                                    _contatoNomeController.text;
                                if (value.length > 19) {
                                  return "Telefone deve ter no máximo 20 caracters";
                                }
                              },
                              decoration:
                                  _inputDecoration(textStyle, "Contato"),
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
                              controller: _telefone1Controller,
                              //keyboardType: TextInputType.number,
                              autocorrect: false,
                              textInputAction: TextInputAction.next,
                              focusNode: _telefone1Focus,
                              onFieldSubmitted: (term) {
                                _telefone2Focus.unfocus();
                                FocusScope.of(context)
                                    .requestFocus(_telefone2Focus);
                              },
                              style: TextStyle(fontSize: 16.0),
                              validator: (String value) {
                                _fornecedor.telefone1 =
                                    _telefone1Controller.text;
                                if (value.length > 19) {
                                  return "Telefone deve ter no máximo que 20 caracters";
                                }
                              },
                              decoration:
                                  _inputDecoration(textStyle, "Telefone 1"),
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
                              controller: _telefone2Controller,
                              //keyboardType: TextInputType.phone,
                              autocorrect: false,
                              textInputAction: TextInputAction.next,
                              focusNode: _telefone2Focus,
                              onFieldSubmitted: (term) {
                                _telefone2Focus.unfocus();
                                FocusScope.of(context)
                                    .requestFocus(_telefone3Focus);
                              },
                              style: TextStyle(fontSize: 16.0),
                              validator: (String value) {
                                _fornecedor.telefone2 =
                                    _telefone2Controller.text;
                                if (value.length > 19) {
                                  return "Telefone deve ter no máximo 20 caracters";
                                }
                              },
                              decoration:
                                  _inputDecoration(textStyle, "Telefone 2"),
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
                              controller: _telefone3Controller,
                              //keyboardType: TextInputType.phone,
                              autocorrect: false,
                              textInputAction: TextInputAction.next,
                              focusNode: _telefone3Focus,
                              onFieldSubmitted: (term) {
                                _telefone2Focus.unfocus();
                                FocusScope.of(context)
                                    .requestFocus(_emailFocus);
                              },
                              style: TextStyle(fontSize: 16.0),
                              validator: (String value) {
                                _fornecedor.telefone3 =
                                    _telefone2Controller.text;
                                if (value.length > 19) {
                                  return "Telefone deve ter no máximo 20 caracters";
                                }
                              },
                              decoration:
                                  _inputDecoration(textStyle, "Telefone 3"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Email
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 5.0, bottom: 5.0, left: 6.0, right: 6.0),
                      child: TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        textInputAction: TextInputAction.next,
                        focusNode: _emailFocus,
                        onFieldSubmitted: (term) {
                          _emailFocus.unfocus();
                          FocusScope.of(context).requestFocus(_enderecoFocus);
                        },
                        validator: (String value) {
                          _fornecedor.email = _emailController.text;
                          if (value.length > 59) {
                            return 'Email deve ter no máximo 60 caracters';
                          }
                        },
                        style: TextStyle(fontSize: 16.0),
                        decoration: _inputDecoration(textStyle, "Email"),
                      ),
                    ),
                    // Address
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 10.0, left: 6.0, right: 6.0),
                      child: TextFormField(
                        controller: _enderecoController,
                        autocorrect: false,
                        maxLines: 3,
                        textInputAction: TextInputAction.newline,
                        focusNode: _enderecoFocus,
                        onEditingComplete: () {
                          _enderecoFocus.unfocus();
                          FocusScope.of(context).requestFocus(_obsFocus);
                        },
                        validator: (String value) {
                          _fornecedor.endereco = _enderecoController.text;
                          if (value.length > 254) {
                            return 'Endereço deve ser menos que 255 caracteres';
                          }
                        },
                        style: TextStyle(fontSize: 16.0),
                        decoration: _inputDecoration(textStyle, "Endereço"),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: 220,
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: 15.0, left: 6.0, right: 6.0),
                            child: TextFormField(
                              controller: _cidadeController,
                              //keyboardType: TextInputType.phone,
                              autocorrect: false,
                              textInputAction: TextInputAction.next,
                              focusNode: _cidadeFocus,
                              onFieldSubmitted: (term) {
                                _emailFocus.unfocus();
                                FocusScope.of(context)
                                    .requestFocus(_estadoFocus);
                              },
                              style: TextStyle(fontSize: 16.0),
                              validator: (String value) {
                                _fornecedor.cidade = _cidadeController.text;
                                if (value.length > 19) {
                                  return "O nome da cidade pode ter no máximo 20 caracters";
                                }
                              },
                              decoration: _inputDecoration(textStyle, "Cidade"),
                            ),
                          ),
                        ),
                        Container(
                          width: 60,
                          height: 50,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(bottom: 15.0, right: 6.0),
                            child: TextFormField(
                              controller: _estadoController,
                              //keyboardType: TextInputType.phone,
                              autocorrect: false,
                              textInputAction: TextInputAction.next,
                              focusNode: _estadoFocus,
                              onFieldSubmitted: (term) {
                                _cidadeFocus.unfocus();
                                FocusScope.of(context).requestFocus(_cepFocus);
                              },
                              style: TextStyle(fontSize: 16.0),
                              validator: (String value) {
                                _fornecedor.estado = _estadoController.text;
                                if (value.length > 19) {
                                  return "O nome do estado pode ter no máximo 20 caracters";
                                }
                              },
                              decoration: _inputDecoration(textStyle, "UF"),
                            ),
                          ),
                        ),
                        Container(
                          width: 120,
                          height: 50,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(bottom: 15.0, right: 6.0),
                            child: TextFormField(
                              controller: _cepController,
                              keyboardType: TextInputType.number,
                              autocorrect: false,
                              textInputAction: TextInputAction.next,
                              focusNode: _cepFocus,
                              onFieldSubmitted: (term) {
                                _cidadeFocus.unfocus();
                                FocusScope.of(context).requestFocus(_obsFocus);
                              },
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
                              validator: (String value) {
                                _fornecedor.cep = _cepController.text;
                                if (value.length > 11) {
                                  return "O CEP pode ter no máximo 12 caracters";
                                }
                              },
                              decoration: _inputDecoration(textStyle, "CEP"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Notes
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 15.0, left: 6.0, right: 6.0),
                      child: TextFormField(
                        controller: _obsController,
                        autocorrect: false,
                        maxLines: 3,
                        textInputAction: TextInputAction.newline,
                        focusNode: _obsFocus,
                        onFieldSubmitted: (term) {
                          _obsFocus.unfocus();
                          //FocusScope.of(context).requestFocus(_nameFocus);
                        },
                        validator: (String value) {
                          _fornecedor.obs = _obsController.text;
                          if (value.length > 254) {
                            return 'A obs deve ser ter no máximo 1024.';
                          }
                        },
                        style: textStyle,
                        decoration: _inputDecoration(textStyle, "Obs"),
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
    if (_appBarTitle != "Adicionar Fornecedor") {
      try {
        await _model.updateFornecedor(_fornecedor);
        _returnToHomePage(true);
      } catch (e) {
        print(e);
        showAlertDialog(context, 'Status', 'Error updating contact.');
      }
    } else {
      try {
        await _model.insertFornecedor(_fornecedor);
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
