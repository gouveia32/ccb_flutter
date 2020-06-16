import 'dart:async';
import 'package:flutter/material.dart';
import '../Data/Linha_Model.dart';
import 'linhaDetailScreen.dart';
import 'package:flutter/cupertino.dart';

const _MAX_LINES = 12;

class LinhaListPage extends StatefulWidget {
  static const routeName = '/linha-list';
  @override
  State<StatefulWidget> createState() {
    return ListPageState();
  }
}

class ListPageState extends State<LinhaListPage> {
  ScrollController _scrollController = ScrollController();
  int _offset = 0;
  int _currentMax = _MAX_LINES;

  Model _model = Model();
  bool carregado = false;

  List<Linha> _linhaList;
  var _filter = "";
  var totItens = 0;

  TextEditingController _textController = TextEditingController();

  onItemChanged(String value) {
    setState(() {
      _filter = _textController.text;
      _linhaList = null;
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
    if (_linhaList == null) {
      _linhaList = List<Linha>();
      _getMoreData();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Linhas (${totItens})"),
      ),
      body: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _textController,
            decoration: InputDecoration(
              hintText: 'digite para filtrar por código ou nome...',
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
      controller: _scrollController,
      itemExtent: 70,
      itemCount: this._linhaList.length,
      itemBuilder: (context, position) {
        if (position == _linhaList.length) {
          return CupertinoActivityIndicator();
        }
        final cor = Color(_linhaList[position].cor);
        //luminancia para determinar a cor do texto do codigo
        final luminancia =
            (0.299 * cor.red + 0.587 * cor.green + 0.114 * cor.blue) / 255;
        return new Stack(
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 2.0,
              borderOnForeground: true,
              color: Colors.white24,
              semanticContainer: false,
              child: ListTile(
                contentPadding: EdgeInsets.only(left: 70),
                title: Text(
                  _linhaList[position].nome,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "Estoque: ${_linhaList[position].estoque_1.toString()}   Mínimo: ${_linhaList[position].minimo.toString()}",
                ),
                trailing: GestureDetector(
                  child: Icon(Icons.delete, color: Colors.red),
                  onTap: () {
                    _deleteLinha(context, _linhaList[position]);
                  },
                ),
                onTap: () {
                  _showDetailPage(_linhaList[position], 'Alterar Linha');
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
                padding: EdgeInsets.all(1), // border width
                child: InkWell(
                  onTap: () {
                    _showDetailPage(_linhaList[position], 'Alterar Linha');
                  },
                  child: Container(
                    // or ClipRRect if you need to clip the content
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          Color(_linhaList[position].cor), // inner circle color
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        child: Text(
                          _linhaList[position].codigo,
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
      _getMoreData();
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
      _getMoreData();
    }
  }

  _getTotItens() {
    Future<int> totItemFuture = _model.getTotItens(_filter);
    totItemFuture.then((value) {
      setState(() {
        totItens = value;
      });
    });
  }

  _getMoreData() {
    carregado = false;

    Future<List<Linha>> linhaListFuture =
        _model.getLinhasList(_filter, _offset, _currentMax);
    linhaListFuture.then((linhaList) {
      setState(() {
        this._linhaList = [..._linhaList, ...linhaList];
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

    //setState(() {});
  }
}
