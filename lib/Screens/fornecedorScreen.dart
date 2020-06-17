import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Data/Fornecedor_Model.dart';

import 'fornecedorDetailScreen.dart';

const _MAX_LINES = 12;

class FornecedorListPage extends StatefulWidget {
  static const routeName = '/fornecedor-list';
  @override
  State<StatefulWidget> createState() {
    return ListPageState();
  }
}

class ListPageState extends State<FornecedorListPage> {
  ScrollController _scrollController = ScrollController();
  int _offset = 0;
  int _currentMax = _MAX_LINES;

  Model _model = Model();
  bool carregado = false;

  List<Fornecedor> _fornecedorList;
  var _filter = "";
  var _totItens = 0;

  TextEditingController _textController = TextEditingController();

  onItemChanged(String value) {
    setState(() {
      _filter = _textController.text;
      _fornecedorList = null;
      _offset = 0;
    });
  }

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_fornecedorList == null) {
      _fornecedorList = List<Fornecedor>();
      _getMoreData();
      //_totItens = _fornecedorList.length;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Fornecedores (${_totItens})"),
      ),
      body: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _textController,
            decoration: InputDecoration(
              hintText: 'digite para filtrar por nome ou contato...',
            ),
            //onChanged: onItemChanged,
            onEditingComplete: () {
              onItemChanged(_textController.text);
            },
          ),
        ),
        Expanded(
          child: carregado
              ? SafeArea(
                  child: _getFornecedoresListView(),
                )
              : Center(child: new CircularProgressIndicator()),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[300],
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FornecedorDetail(
                    Fornecedor(0, '', '', '', '', '', '', '', '', '', '', '',
                        '', '', ''),
                    'Novo V')),
          );
        },
        tooltip: 'Adicionar Linha',
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
    );
  }

  ListView _getFornecedoresListView() {
    return ListView.builder(
      controller: _scrollController,
      itemExtent: 80,
      itemBuilder: (context, position) {
        if (position == _fornecedorList.length) {
          return CupertinoActivityIndicator();
        }

        var st = '';

        if (this._fornecedorList[position].telefone1 != '') {
          st += 'Tel.: ${this._fornecedorList[position].telefone1}  ';
        }

        if (this._fornecedorList[position].email != '') {
          st += 'Email.: ${this._fornecedorList[position].email}';
        }

        return Card(
          elevation: 3.0,
          borderOnForeground: true,
          color: Colors.blue[100],
          semanticContainer: true,
          child: ListTile(
            contentPadding: EdgeInsets.only(left: 8),
            title: Text(
              this._fornecedorList[position].nome,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(st),
            trailing: GestureDetector(
              child: Icon(
                Icons.delete,
                color: Colors.redAccent,
              ),
              onTap: () {
                _deleteFornecedor(context, _fornecedorList[position]);
              },
            ),
            onTap: () {
              _showDetailPage(
                  this._fornecedorList[position], 'Alterar Fornecedor');
            },
          ),
        );
      },
      itemCount: this._fornecedorList.length,
    );
  }

  void _deleteFornecedor(BuildContext context, Fornecedor fornecedor) async {
    Future<void> fornecedorDeleteFuture = _model.deleteFornecedor(fornecedor);
    fornecedorDeleteFuture.then((foo) {
      _showSnackBar(context, "O Fornecedor foi apagado.");
      _getMoreData();
    }).catchError((e) {
      print(e.toString());
      _showSnackBar(context, "Erro ao tentar apagar o fornecedor!");
    });
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void _showDetailPage(Fornecedor fornecedor, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return FornecedorDetail(fornecedor, title);
    }));

    if (result == true) {
      _getMoreData();
    }
  }

  _getTotItens() {
    Future<int> totItemFuture = _model.getTotItens(_filter);
    totItemFuture.then((value) {
      setState(() {
        _totItens = value;
      });
    });
  }

  _getMoreData() {
    carregado = false;
    setState(() {
      _model.getTotItens(_filter).then((value) {
        _totItens = value;
      });
    });

    Future<List<Fornecedor>> fornecedorListFuture =
        _model.getFornecedoresList(_filter, _offset, _currentMax);
    fornecedorListFuture.then((fornecedorList) {
      setState(() {
        this._fornecedorList = [..._fornecedorList, ...fornecedorList];
        carregado = true;
        _offset = _currentMax;
        _currentMax += _MAX_LINES;
        _getTotItens();
      });
    }).catchError((e) async {
      print(e.toString());
      showAlertDialog(context, "Database error",
          e.toString()); // this is for me, so showing actual exception. suggest something more user-friendly in a real app.
    });
  }
}
