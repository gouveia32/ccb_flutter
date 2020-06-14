import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Data/Contact_Model.dart';
import 'contactDetailScreen.dart';

const _MAX_LINES = 12;

class ContactListPage extends StatefulWidget {
  static const routeName = '/contact-list';
  @override
  State<StatefulWidget> createState() {
    return ListPageState();
  }
}

class ListPageState extends State<ContactListPage> {
  ScrollController _scrollController = ScrollController();
  int _offset = 0;
  int _currentMax = _MAX_LINES;
  var _filter = "";

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

  Model _model = Model();
  bool carregado = false;

  List<Contact> _contactList;

  TextEditingController _textController = TextEditingController();

  onItemChanged(String value) {
    setState(() {
      _filter = _textController.text;
      _contactList = null;
      _offset = 0;
      //_getMoreData();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_contactList == null) {
      _contactList = List<Contact>();
      _getMoreData();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Contatos                               (${_contactList.length})"),
      ),
      body: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _textController,
            decoration: InputDecoration(
              hintText: 'digite para filtrar por nome ou email...',
            ),
            onChanged: onItemChanged,
          ),
        ),
        Expanded(
          child: carregado
              ? SafeArea(
                  child: _getContactsListView(),
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
                builder: (context) => ContactDetail(
                    Contact(0, '', '', '', '', '', ''), 'Novo Contato')),
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

  ListView _getContactsListView() {
    return ListView.builder(
      controller: _scrollController,
      itemExtent: 80,
      itemCount: this._contactList.length,
      itemBuilder: (context, position) {
        if (position == _contactList.length) {
          return CupertinoActivityIndicator();
        }
        return Card(
          elevation: 3.0,
          borderOnForeground: true,
          color: Colors.blue[100],
          semanticContainer: true,
          child: ListTile(
            title: Text(
              this._contactList[position].name,
            ),
            subtitle: Text(this._contactList[position].mobilePhone +
                "   eMail: " +
                this._contactList[position].email),
            trailing: GestureDetector(
              child: Icon(
                Icons.delete,
                color: Colors.redAccent,
              ),
              onTap: () {
                _deleteContact(context, _contactList[position]);
              },
            ),
            onTap: () {
              _showDetailPage(this._contactList[position], 'Alterar o Contato');
            },
          ),
        );
      },
    );
  }

  void _deleteContact(BuildContext context, Contact contact) async {
    Future<void> contactDeleteFuture = _model.deleteContact(contact);
    contactDeleteFuture.then((foo) {
      _showSnackBar(context, "Contact was deleted.");
      _getMoreData();
    }).catchError((e) {
      print(e.toString());
      _showSnackBar(context, "Error trying to delete contact");
    });
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void _showDetailPage(Contact contact, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ContactDetail(contact, title);
    }));

    if (result == true) {
      _getMoreData();
    }
  }

  _getMoreData() {
    carregado = false;

    Future<List<Contact>> contactListFuture =
        _model.getContactsList(_filter, _offset, _currentMax);
    contactListFuture.then((contactList) {
      setState(() {
        this._contactList = [..._contactList, ...contactList];
        carregado = true;
        _offset = _currentMax;
        _currentMax += _MAX_LINES;
        if (_offset > _contactList.length) _offset = _contactList.length;
      });
    }).catchError((e) async {
      print(e.toString());
      //showAlertDialog(context, "Database error", e.toString()); // this is for me, so showing actual exception. suggest something more user-friendly in a real app.
    });

    //setState(() {});
  }
}
