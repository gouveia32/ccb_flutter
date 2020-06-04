import 'dart:async';
import '../Data/Contact_Model.dart';
import '../Screens/contact_detail_page.dart';
import 'package:flutter/material.dart';

class ContactListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListPageState();
  }
}

class ListPageState extends State<ContactListPage> {
  Model _model = Model();

  List<Contact> _contactList;
  int _numberOfContacts = 0;
  
  static const routeName = '/contact-list';

  @override
  Widget build(BuildContext context) {
    //mostraBotao = true;

    //corBotao = Colors.green;
    if (_contactList == null) {
      _contactList = List<Contact>();
      _updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Address Book',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: _getContactsListView(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black26,
        onPressed: () {
          _showDetailPage(Contact('', '', '', '', '', ''), 'Add Contact');
        },
        tooltip: 'Add Contact',
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation:    
      FloatingActionButtonLocation.endTop,      
    );
  }

  ListView _getContactsListView() {
    
    return ListView.builder(
      itemCount: _numberOfContacts,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          elevation: 2.0,
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
              _showDetailPage(this._contactList[position], 'Edit Contact');
              //Navigator.push(
              //    context,
              //    MaterialPageRoute(builder: (context) => ContactDetail(
              //      this._contactList[position], 'Alterar Contato'  
              //    )),
              //  );
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
      });
    }).catchError((e) {
      print(e.toString());
      showAlertDialog(context, "Database error", e.toString()); // this is for me, so showing actual exception. suggest something more user-friendly in a real app.
    });
  }

}
