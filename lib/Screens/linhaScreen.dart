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
  int _skip = 0;
  int _take = 10;

  var _filter = "";
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
        title: Text("Linhas: '${_numberOfLinhas}'"),
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
        var values = _linhaList;

        if (position >= _linhaList.length - 1) {
          _skip += _take + 1;
          _updateListView();
        }
        final cor = Color(values[position].cor);
        final luminancia =
            (0.299 * cor.red + 0.587 * cor.green + 0.114 * cor.blue) / 255;
        return new Stack(
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 3.0,
              borderOnForeground: true,
              color: Colors.white24,
              semanticContainer: true,
              child: ListTile(
                title: Center(
                  child: Text(values[position].nome),
                ),
                subtitle: Center(
                  child: Text(
                    "Estoque: " + values[position].estoque_1.toString(),
                  ),
                ),
                trailing: GestureDetector(
                  child: Icon(Icons.delete, color: Colors.red),
                  onTap: () {
                    _deleteLinha(context, _linhaList[position]);
                  },
                ),
                onTap: () {
                  _showDetailPage(values[position], 'Alterar Linha');
                },
              ),
            ),
            Container(
              width: 70,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.black, // border color
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: EdgeInsets.all(2), // border width
                child: InkWell(
                  onTap: () {
                    _showDetailPage(values[position], 'Alterar Linha');
                  },
                  child: Container(
                    // or ClipRRect if you need to clip the content
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(values[position].cor), // inner circle color
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        child: Text(
                          values[position].codigo,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: luminancia > 0.5
                                  ? Colors.black
                                  : Colors.white),
                        ),
                      ),
                    ), // inner content
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  void _deleteLinha(BuildContext context, Linha linha) async {
    Future<void> linhaDeleteFuture = _model.deleteLinha(linha);
    linhaDeleteFuture.then((foo) {
      _showSnackBar(context, "Linha foi apagada.");
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
    Future<List<Linha>> linhaListFuture =
        _model.getLinhasList(_filter, _skip, _take);
    linhaListFuture.then((linhaList) {
      setState(() {
        this._linhaList += linhaList;
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
