import 'dart:async';
import 'package:ccb_flutter/Screens/home_page.dart';

import '../Data/Client_Model.dart';
import '../Screens/client_detail_page.dart';
import 'package:flutter/material.dart';


class ClientListPage extends StatefulWidget {
  @override static const routeName = '/client-list';

  State<StatefulWidget> createState() {
    return ClientListPageState();
  }
}

class ClientListPageState extends State<ClientListPage> {
  Model _model = Model();
  bool carregado = false;

  List<Client> _clientList;
  int _numberOfClients = 0;

  @override
  Widget build(BuildContext context) {

    //corBotao = Colors.pink;
    if (_clientList == null) {
      _clientList = List<Client>();
      _updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text(
          'Cadastro de Clientes',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: carregado
            ? SafeArea(
                child: _getClientsListView(),
              )
            : Center(
                child: new CircularProgressIndicator()
              ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black26,
        onPressed: () {
          //_showDetailPage(Client(0, '', '', '', '', '', '', '', '', '', '', '', '', '', '', 0.0), 'Adicionar Cliente');
          Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
        },
        tooltip: 'Adicionar Cliente',
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation:    
      FloatingActionButtonLocation.endTop,
    );
  }

  ListView _getClientsListView() {
    return  ListView.builder(
      itemCount: _numberOfClients,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          elevation: 2.0,
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
              //Navigator.push(
              //    context,
              //    MaterialPageRoute(builder: (context) => ClientDetail(
              //      this._clientList[position], 'Alterar Cliente'  
              //    )),
              //  );
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

  void _showDetailPage(Client client, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return  ClientDetail(client, title);
    }));

    if (result == true) {
      _updateListView();
    }
  }
  void _updateListView() {
    Future<List<Client>> contactListFuture = _model.getClientsList();
    contactListFuture.then((clientList) {
      setState(() {
        this._clientList = clientList;
        this._numberOfClients = clientList.length;
        carregado = true;
      });
    }).catchError((e) {
      print(e.toString());
      showAlertDialog(context, "Database error", e.toString()); // this is for me, so showing actual exception. suggest something more user-friendly in a real app.
    });
  }

}
