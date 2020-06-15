import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Data/Cliente_Model.dart';

import 'clienteDetailScreen.dart';

const _MAX_LINES = 12;

class ClienteListPage extends StatefulWidget {
  static const routeName = '/cliente-list';
  @override
  State<StatefulWidget> createState() {
    return ListPageState();
  }
}

class ListPageState extends State<ClienteListPage> {
  ScrollController _scrollController = ScrollController();
  int _offset = 0;
  int _currentMax = _MAX_LINES;

  Model _model = Model();
  bool carregado = false;

  List<Cliente> _clienteList;
  var _filter = "";

  var _totItens = 0;

  TextEditingController _textController = TextEditingController();

  onItemChanged(String value) {
    setState(() {
      _filter = _textController.text;
      _clienteList = null;
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
    if (_clienteList == null) {
      _clienteList = List<Cliente>();
      _getMoreData();
      //_totItens = _clienteList.length;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Clientes (${_totItens})"),
      ),
      body: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _textController,
            decoration: InputDecoration(
              hintText: 'digite para filtrar por nome ou contato...',
            ),
            onChanged: onItemChanged,
          ),
        ),
        Expanded(
          child: carregado
              ? SafeArea(
                  child: _getClientesListView(),
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
                builder: (context) => ClienteDetail(
                    Cliente(0, '', '', '', '', '', '', '', '', '', '', '', '',
                        '', '', 0),
                    'Novo Cliente')),
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

  ListView _getClientesListView() {
    return ListView.builder(
      controller: _scrollController,
      itemExtent: 80,
      itemBuilder: (context, position) {
        if (position == _clienteList.length) {
          return CupertinoActivityIndicator();
        }

        var st = '';

        if (this._clienteList[position].telefone1 != '') {
          st += 'Tel.: ${this._clienteList[position].telefone1}  ';
        }

        if (this._clienteList[position].email != '') {
          st += 'Email.: ${this._clienteList[position].email}';
        }

        return Card(
          elevation: 3.0,
          borderOnForeground: true,
          color: Colors.blue[100],
          semanticContainer: true,
          child: ListTile(
            contentPadding: EdgeInsets.only(left: 8),
            title: Text(
              this._clienteList[position].nome,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(st),
            trailing: GestureDetector(
              child: Icon(
                Icons.delete,
                color: Colors.redAccent,
              ),
              onTap: () {
                _deleteCliente(context, _clienteList[position]);
              },
            ),
            onTap: () {
              _showDetailPage(this._clienteList[position], 'Alterar Cliente');
            },
          ),
        );
      },
      itemCount: this._clienteList.length,
    );
  }

  void _deleteCliente(BuildContext context, Cliente cliente) async {
    Future<void> clienteDeleteFuture = _model.deleteCliente(cliente);
    clienteDeleteFuture.then((foo) {
      _showSnackBar(context, "O Cliente foi apagado.");
      _getMoreData();
    }).catchError((e) {
      print(e.toString());
      _showSnackBar(context, "Erro ao tentar apagar o cliente!");
    });
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void _showDetailPage(Cliente cliente, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ClienteDetail(cliente, title);
    }));

    if (result == true) {
      _getMoreData();
    }
  }

  _getMoreData() {
    carregado = false;
    setState(() {
      _model.getTotItens(_filter).then((value) {
        _totItens = value;
      });
    });

    Future<List<Cliente>> clienteListFuture =
        _model.getClientesList(_filter, _offset, _currentMax);
    clienteListFuture.then((clienteList) {
      setState(() {
        this._clienteList = [..._clienteList, ...clienteList];
        carregado = true;
        _offset = _currentMax;
        _currentMax += _MAX_LINES;
      });
    }).catchError((e) async {
      print(e.toString());
      showAlertDialog(context, "Database error",
          e.toString()); // this is for me, so showing actual exception. suggest something more user-friendly in a real app.
    });
  }
}
