import './Contact_Db_helper.dart';

class Model {
  static final Model _model = new Model._internal();

  factory Model() {
    return _model;
  }

  Model._internal();

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<void> insertContact(Contact contact) async {
    return _databaseHelper.insertContact(contact);
  }

  Future<int> updateContact(Contact contact) async {
    return _databaseHelper.updateContact(contact);
  }

  Future<void> deleteContact(Contact contact) async {
    return _databaseHelper.deleteContact(contact);
  }

  Future<List<Contact>> getContactsList(
      [String filter, int offset = 0, int limit = 10]) async {
    return _databaseHelper.getContactsList(filter, offset, limit);
  }
}

class Contact {
  int _id;
  String _name;
  String _address;
  String _homePhone;
  String _mobilePhone;
  String _email;
  String _notes;

  Contact(this._id, this._name, this._address, this._homePhone,
      this._mobilePhone, this._email, this._notes);

  int get id => _id;
  String get name => _name;
  String get homePhone => _homePhone;
  String get mobilePhone => _mobilePhone;
  String get email => _email;
  String get address => _address;
  String get notes => _notes;

  set id(int newId) {
    if (newId >= 0) {
      this._id = newId;
    }
  }

  set name(String newName) {
    if (newName.length <= 80) {
      this._name = newName;
    }
  }

  set homePhone(String newHomePhone) {
    if (newHomePhone.length <= 30) {
      this._homePhone = newHomePhone;
    }
  }

  set mobilePhone(String newMobilePhone) {
    if (newMobilePhone.length <= 30) {
      this._mobilePhone = newMobilePhone;
    }
  }

  set email(String newEmail) {
    if (newEmail.length <= 60) {
      this._email = newEmail;
    }
  }

  set address(String newAddress) {
    if (newAddress.length <= 255) {
      this._address = newAddress;
    }
  }

  set notes(String newNotes) {
    if (newNotes.length <= 255) {
      this._notes = newNotes;
    }
  }
}
