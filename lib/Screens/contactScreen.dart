import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Data/Contact_Model.dart';
import 'contactDetailScreen.dart';

class ContactListPage extends StatefulWidget {
  static const routeName = '/contact-list';
  @override
  State<StatefulWidget> createState() {
    return ListPageState();
  }
}

class ListPageState extends State<ContactListPage> {
  List myList;
  ScrollController _scrollController = ScrollController();
  int _currentMax = 10;

  @override
  void initState() {
    super.initState();
    myList = List.generate(10, (i) => "Item : ${i + 1}");
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
  }

  _getMoreData() {
    for (int i = _currentMax; i < _currentMax + 10; i++) {
      myList.add("Item : ${i + 1}");
    }

    Future<List<Contact>> contactListFuture =
        _model.getContactsList(_currentMax, _currentMax + 10);
    contactListFuture.then((contactList) {
      setState(() {
        this._contactList = contactList;
        this._numberOfContacts = contactList.length;
        carregado = true;
      });
    }).catchError((e) async {
      print(e.toString());
      //showAlertDialog(context, "Database error", e.toString()); // this is for me, so showing actual exception. suggest something more user-friendly in a real app.
    });
    _currentMax = _currentMax + 10;

    setState(() {});
  }

  Model _model = Model();
  bool carregado = false;

  List<Contact> _contactList;
  int _numberOfContacts = 0;

  @override
  Widget build(BuildContext context) {
    if (_contactList == null) {
      _contactList = List<Contact>();
      _updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Contatos'),
      ),
      body: carregado
          ? SafeArea(
              child: _getContactsListView(),
            )
          : Center(child: new CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[300],
        onPressed: () {
          //_showDetailPage(Contact('', '', '', '', '', ''), 'Adicionar Contato');

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ContactDetail(
                    Contact(0, '', '', '', '', '', ''), 'Novo Contato')),
          );
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

  ListView _getContactsListView() {
    return ListView.builder(
      controller: _scrollController,
      itemExtent: 80,
      itemBuilder: (context, i) {
        if (i == myList.length) {
          return CupertinoActivityIndicator();
        }
        return ListTile(
          title: Text(myList[i]),
        );
      },
      itemCount: myList.length + 1,
    );
  }

  void _deleteContact(BuildContext context, Contact contact) async {
    Future<void> contactDeleteFuture = _model.deleteContact(contact);
    contactDeleteFuture.then((foo) {
      _showSnackBar(context, "Contact was deleted.");
      _updateListView();
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
      _updateListView();
    }
  }

  void _updateListView() {
    Future<List<Contact>> contactListFuture = _model.getContactsList();
    contactListFuture.then((contactList) {
      setState(() {
        this._contactList = contactList;
        this._numberOfContacts = contactList.length;
        carregado = true;
      });
    }).catchError((e) async {
      print(e.toString());
      //showAlertDialog(context, "Database error", e.toString()); // this is for me, so showing actual exception. suggest something more user-friendly in a real app.
    });
  }
}
