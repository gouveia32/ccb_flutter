import 'dart:async';
import 'package:flutter/material.dart';
import '../Data/Linha_Model.dart';
import 'linhaDetailScreen.dart';

class LinhaListPage extends StatefulWidget {
  static const routeName = '/linha-list';
  @override
  State<StatefulWidget> createState() {
    return ListPageState();
  }
}

class ListPageState extends State<LinhaListPage> {
  Model _model = Model();
  bool carregado = false;

  List<Linha> _linhaList;
  int _numberOfLinhas = 0;

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
    if (_linhaList == null) {
      _linhaList = List<Linha>();
      _updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Linhas'),
      ),
      body: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _textController,
            decoration: InputDecoration(
              hintText: 'Filtre por código ou nome da linha...',
            ),
            onChanged: onItemChanged,
          ),
        ),
        Expanded(
          child: carregado
              ? SafeArea(
                  child: _getLinhasListView(),
                )
              : Center(child: new CircularProgressIndicator()),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[300],
        onPressed: () {
          //_showDetailPage(Linha('', '', '', '', '', ''), 'Adicionar Contato');

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LinhaDetail(
                    Linha('', '', '', '', '', 0, 0, 0, 0, 0), 'Nova Linha')),
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

  ListView _getLinhasListView() {
    return ListView.builder(
      itemCount: _numberOfLinhas,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          elevation: 3.0,
          borderOnForeground: true,
          color: Color(this._linhaList[position].cor),
          semanticContainer: true,
          child: ListTile(
            title: Text(this._linhaList[position].codigo,
                style: (this._linhaList[position].cor < -16000000)
                    ? TextStyle(color: Colors.white)
                    : TextStyle(color: Colors.black)),
            subtitle: Text(
                this._linhaList[position].nome +
                    "          Estoque: " +
                    this._linhaList[position].estoque_1.toString(),
                style: (this._linhaList[position].cor < -16000000)
                    ? TextStyle(color: Colors.white)
                    : TextStyle(color: Colors.black)),
            trailing: GestureDetector(
              child: this._linhaList[position].nome.contains('ermelho')
                  ? Icon(Icons.delete, color: Colors.white)
                  : Icon(Icons.delete, color: Colors.red),
              onTap: () {
                _deleteLinha(context, _linhaList[position]);
              },
            ),
            onTap: () {
              _showDetailPage(this._linhaList[position], 'Alterar Linha');
            },
          ),
        );
      },
    );
  }

  void _deleteLinha(BuildContext context, Linha linha) async {
    Future<void> linhaDeleteFuture = _model.deleteLinha(linha);
    linhaDeleteFuture.then((foo) {
      _showSnackBar(context, "Linha was deleted.");
      _updateListView();
    }).catchError((e) {
      print(e.toString());
      _showSnackBar(context, "Error trying to delete linha");
    });
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void _showDetailPage(Linha linha, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return LinhaDetail(linha, title);
    }));

    if (result == true) {
      _updateListView();
    }
  }

  void _updateListView() {
    Future<List<Linha>> linhaListFuture = _model.getLinhasList(_filter);
    linhaListFuture.then((linhaList) {
      setState(() {
        this._linhaList = linhaList;
        this._numberOfLinhas = linhaList.length;
        carregado = true;
      });
    }).catchError((e) async {
      print(e.toString());
      showAlertDialog(context, "Database error",
          e.toString()); // this is for me, so showing actual exception. suggest something more user-friendly in a real app.
    });
  }
}
