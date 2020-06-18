import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Data/Bordado_Model.dart';

import 'bordadoDetailScreen.dart';

const _MAX_LINES = 4;

class BordadoListPage extends StatefulWidget {
  static const routeName = '/bordado-list';
  @override
  State<StatefulWidget> createState() {
    return ListPageState();
  }
}

class ListPageState extends State<BordadoListPage> {
  ScrollController _scrollController = ScrollController();
  int _offset = 0;
  int _currentMax = _MAX_LINES;

  Model _model = Model();
  bool carregado = false;

  List<Bordado> _bordadoList;
  var _filter = "";
  var _totItens = 0;

  TextEditingController _textController = TextEditingController();

  onItemChanged(String value) {
    setState(() {
      _filter = _textController.text;
      _bordadoList = null;
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
    if (_bordadoList == null) {
      _bordadoList = List<Bordado>();
      _getMoreData();
      //_totItens = _bordadoList.length;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Bordados (${_totItens})"),
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
                  child: _getBordadosListView(),
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
                builder: (context) => BordadoDetail(
                    Bordado(0, '', '', '', '', '', 0, 0.0, 0, 0, 0, 0, 0, 0, 0,
                        Uint8List(0), 0, '', ''),
                    'Novo Bordado')),
          );
        },
        tooltip: 'Adicionar Bordado',
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
    );
  }

  ListView _getBordadosListView() {
    return ListView.builder(
      controller: _scrollController,
      itemExtent: 80,
      itemBuilder: (context, position) {
        if (position == _bordadoList.length) {
          return CupertinoActivityIndicator();
        }

        return Card(
          elevation: 3.0,
          borderOnForeground: true,
          color: Colors.blue[100],
          semanticContainer: true,
          child: ListTile(
            contentPadding: EdgeInsets.only(left: 8),
            title: Text(
              this._bordadoList[position].descricao,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(this._bordadoList[position].arquivo),
            trailing: GestureDetector(
              child: Icon(
                Icons.delete,
                color: Colors.redAccent,
              ),
              onTap: () {
                _deleteBordado(context, _bordadoList[position]);
              },
            ),
            onTap: () {
              _showDetailPage(this._bordadoList[position], 'Alterar Bordado');
            },
          ),
        );
      },
      itemCount: this._bordadoList.length,
    );
  }

  void _deleteBordado(BuildContext context, Bordado bordado) async {
    Future<void> bordadoDeleteFuture = _model.deleteBordado(bordado);
    bordadoDeleteFuture.then((foo) {
      _showSnackBar(context, "O Bordado foi apagado.");
      _getMoreData();
    }).catchError((e) {
      print(e.toString());
      _showSnackBar(context, "Erro ao tentar apagar o bordado!");
    });
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void _showDetailPage(Bordado bordado, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return BordadoDetail(bordado, title);
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

    Future<List<Bordado>> bordadoListFuture =
        _model.getBordadosList(_filter, _offset, _currentMax);
    bordadoListFuture.then((bordadoList) {
      setState(() {
        this._bordadoList = [..._bordadoList, ...bordadoList];
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
