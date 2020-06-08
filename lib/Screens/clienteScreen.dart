import 'dart:async';
import 'package:flutter/material.dart';
import '../Data/Cliente_Model.dart';

import 'clienteDetailScreen.dart';

class ClienteListPage extends StatefulWidget {
  @override
  static const routeName = '/cliente-list';

  State<StatefulWidget> createState() {
    return ClienteListPageState();
  }
}

class ClienteListPageState extends State<ClienteListPage> {
  static const routeName = '/cliente-screen';
  Model _model = Model();
  bool carregado = false;

  List<Cliente> _clienteList;
  int _numberOfClientes = 0;

  var _filter = null;
  TextEditingController _textController = TextEditingController();

  onItemChanged(String value) {
    setState(() {
      _filter = _textController.text;
      _updateListView();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_clienteList == null) {
      _clienteList = List<Cliente>();
      _updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Clientes'),
      ),
      body: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _textController,
            decoration: InputDecoration(
              hintText: 'Filtre por nome ou contato da linha...',
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
        tooltip: 'Adicionar Cliente',
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
      itemCount: _numberOfClientes,
      itemBuilder: (BuildContext context, int position) {
        //var values = _clientList;

        return Card(
          elevation: 3.0,
          borderOnForeground: true,
          color: Colors.blue[100],
          semanticContainer: true,
          child: ListTile(
            title: Text(
              this._clienteList[position].nome,
            ),
            subtitle: Text(this._clienteList[position].telefone1),
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
    );
  }

  void _deleteCliente(BuildContext context, Cliente cliente) async {
    Future<void> clienteDeleteFuture = _model.deleteCliente(cliente);
    clienteDeleteFuture.then((foo) {
      _showSnackBar(context, "O Cliente foi apagado.");
      _updateListView();
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
      _updateListView();
    }
  }

  void _updateListView() {
    Future<List<Cliente>> clienteListFuture = _model.getClientesList(_filter);
    clienteListFuture.then((clienteList) {
      setState(() {
        this._clienteList = clienteList;
        this._numberOfClientes = clienteList.length;
        carregado = true;
      });
    }).catchError((e) {
      print(e.toString());
      showAlertDialog(context, "Erro na Base de dados",
          e.toString()); // this is for me, so showing actual exception. suggest something more user-friendly in a real app.
    });
  }
}
