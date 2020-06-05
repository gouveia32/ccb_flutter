import 'dart:async';
import 'package:flutter/material.dart';
import '../Data/Cliente_Model.dart';

import 'clienteDetailScreen.dart';

class ClientListPage extends StatefulWidget {
  @override
  static const routeName = '/client-list';

  State<StatefulWidget> createState() {
    return ClientListPageState();
  }
}

class ClientListPageState extends State<ClientListPage> {
  static const routeName = '/client-screen';
  Model _model = Model();
  bool carregado = false;
  int _skip = 0;
  int _take = 10;

  List<Client> _clientList;
  int _numberOfClients = 0;

  @override
  Widget build(BuildContext context) {
    if (_clientList == null) {
      _clientList = List<Client>();
      _updateListView(_skip, _take);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Clientes'),
      ),
      body: carregado
          ? SafeArea(
              child: _getClientsListView(),
            )
          : Center(child: new CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          _showDetailPage(
              Client(0, '', '', '', '', '', '', '', '', '', '', '', '', '', '',
                  0.0),
              'Adicionar Cliente');
        },
        tooltip: 'Adicionar Cliente',
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }

  ListView _getClientsListView() {
    return ListView.builder(
      itemCount: _numberOfClients,
      itemBuilder: (BuildContext context, int position) {
        //var values = _clientList;
        if (position >= _clientList.length - 1) {
          _skip++;
          //_updateListView(_skip, _take);
        }

        return Card(
          elevation: 3.0,
          borderOnForeground: true,
          color: Colors.blue[100],
          semanticContainer: true,
          child: ListTile(
            title: Text(
              this._clientList[position].nome,
            ),
            subtitle: Text(this._clientList[position].telefone1),
            trailing: GestureDetector(
              child: Icon(
                Icons.delete,
                color: Colors.grey,
              ),
              onTap: () {
                _deleteClient(context, _clientList[position]);
              },
            ),
            onTap: () {
              _showDetailPage(this._clientList[position], 'Alterar Cliente');
            },
          ),
        );
      },
    );
  }

  void _deleteClient(BuildContext context, Client client) async {
    Future<void> clientDeleteFuture = _model.deleteClient(client);
    clientDeleteFuture.then((foo) {
      _showSnackBar(context, "O Cliente foi apagado.");
      _updateListView(_skip, _take);
    }).catchError((e) {
      print(e.toString());
      _showSnackBar(context, "Erro ao tentar apagar o cliente!");
    });
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void _showDetailPage(Client client, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ClientDetail(client, title);
    }));

    if (result == true) {
      _updateListView(_skip, _take);
    }
  }

  void _updateListView(int offset, [int maxRec]) {
    Future<List<Client>> contactListFuture = _model.getClientsList();
    contactListFuture.then((clientList) {
      setState(() {
        this._clientList = clientList;
        this._numberOfClients = clientList.length;
        carregado = true;
      });
    }).catchError((e) {
      print(e.toString());
      showAlertDialog(context, "Database error",
          e.toString()); // this is for me, so showing actual exception. suggest something more user-friendly in a real app.
    });
  }
}
