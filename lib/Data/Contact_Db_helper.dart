import 'dart:async';
import './Contact_Model.dart';
import 'package:mysql1/mysql1.dart';

import 'Db_Connection.dart';

class DatabaseHelper {
  final DbHelper _dbHelper = DbHelper();

  Future<void> insertContact(Contact contact) async {
    MySqlConnection connection = await _dbHelper.databaseConnection;

    if (connection != null) {
      try {
        await connection.query(
            'insert into Contacts (Name, Address, Phone, Phone_mobile, Email, Notes) values (?, ?, ?, ?, ?, ?)',
            [
              contact.name,
              contact.address,
              contact.homePhone,
              contact.mobilePhone,
              contact.email,
              contact.notes
            ]);
        connection.close();
      } catch (e) {
        print(e.toString());
        rethrow;
      }
    }
  }

  Future<int> updateContact(Contact contact) async {
    MySqlConnection connection = await _dbHelper.databaseConnection;

    if (connection != null) {
      try {
        // Update query format is: Update <table> Set Address = 'New Address', Zip = 'New Zip' where Name is 'Pete'
        String queryString =
            "update Contacts set Name='${contact.name}',Address='${contact.address}', Phone = '${contact.homePhone}', Phone_mobile = '${contact.mobilePhone}', Email='${contact.email}', Notes='${contact.notes}' where id='${contact.id}'";
        await connection.query(queryString);
        connection.close();
      } catch (e) {
        print(e.toString());
      }
    }
    return 0;
  }

  Future<void> deleteContact(Contact contact) async {
    MySqlConnection connection = await _dbHelper.databaseConnection;

    if (connection != null) {
      try {
        // Delete also requires quotes around strings
        String queryString = "delete from Contacts where id = '${contact.id}'";
        await connection.query(queryString);
        connection.close();
      } catch (e) {
        print(e.toString());
        rethrow;
      }
    }
  }

  Future<List<Contact>> getContactsList(
      [String filter, int offset = 0, int limit = 10]) async {
    MySqlConnection connection = await _dbHelper.databaseConnection;

    List<Contact> listResults = List();
    var sql =
        "SELECT Id, Name, Address, Phone, Phone_mobile, Email, Notes FROM Contacts ";

    if (filter == null) {
      sql += " ORDER BY Id LIMIT " + offset.toString() + "," + limit.toString();
    } else {
      sql +=
          " WHERE Name LIKE '%${filter}%' OR Email LIKE '%${filter}%' ORDER BY Id  LIMIT " +
              offset.toString() +
              "," +
              limit.toString();
    }

    if (connection != null) {
      Results results = await connection.query(sql);

      connection.close();

      for (var row in results) {
        listResults.add(
            Contact(row[0], row[1], row[2], row[3], row[4], row[5], row[6]));
      }
    }
    return listResults;
  }

  Future<int> getTotItens([String filter]) async {
    MySqlConnection connection = await _dbHelper.databaseConnection;

    var sql = "SELECT COUNT(*) AS totItens " + "FROM contacts ";

    if (filter == "") {
      sql += ";";
    } else {
      sql += " WHERE nome LIKE '%${filter}%' OR email LIKE '%${filter}%';";
    }

    if (connection != null) {
      Results results = await connection.query(sql);
      connection.close();

      for (var row in results) {
        return row[0];
      }
    }
    return 0;
  }
}
