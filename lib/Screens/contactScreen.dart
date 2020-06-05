import 'dart:async';
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
      itemCount: _numberOfContacts,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          elevation: 3.0,
          borderOnForeground: true,
          color: Colors.green[100],
          semanticContainer: true,
          child: ListTile(
            title: Text(
              this._contactList[position].name,
            ),
            subtitle: Text(this._contactList[position].mobilePhone),
            trailing: GestureDetector(
              child: Icon(
                Icons.delete,
                color: Colors.grey,
              ),
              onTap: () {
                _deleteContact(context, _contactList[position]);
              },
            ),
            onTap: () {
              //_showDetailPage(this._contactList[position], 'Edit Contact');
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ContactDetail(
                        this._contactList[position], 'Alterar Contato')),
              );
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
