import 'dart:async';
import './Cliente_Model.dart';
import 'package:mysql1/mysql1.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static MySqlConnection _databaseConnection;

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<MySqlConnection> get databaseConnection async {
    try {
      var host = '10.0.2.2'; //e.g. 196.70.125.43
      var user = 'root';
      var db = 'my_store';
      var password = 'ebtaju';

      assert(host != 'ebtaju');

      _databaseConnection = await MySqlConnection.connect(ConnectionSettings(
          host: host, port: 3306, user: user, db: db, password: password));
    } catch (e) {
      print(e.toString());
      rethrow;
    }
    return _databaseConnection;
  }

  Future<void> insertClient(Client client) async {
    MySqlConnection connection = await this.databaseConnection;

    if (connection != null) {
      try {
        await connection.query(
            "INSERT INTO Clientes (nome,contato_funcao,contato_nome,cgc_cpf," +
                "inscr_estadual,endereco,cidade,estado,telefone1,telefone2," +
                "telefone3,email,obs,preco_base) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)",
            [
              client.nome,
              client.contato_funcao,
              client.contato_nome,
              client.cgc_cpf,
              client.endereco,
              client.cidade,
              client.estado,
              client.cep,
              client.telefone1,
              client.telefone2,
              client.telefone3,
              client.email,
              client.obs,
              client.preco_base
            ]);
        connection.close();
      } catch (e) {
        print(e.toString());
        rethrow;
      }
    }
  }

  Future<int> updateClient(Client client) async {
    MySqlConnection connection = await this.databaseConnection;

    if (connection != null) {
      try {
        // Update query format is: Update <table> Set Address = 'New Address', Zip = 'New Zip' where Name is 'Pete'
        String queryString = "UPDATE clientes set nome = '${client.nome}'," +
            " contato_funcao = '${client.contato_funcao}'," +
            " contato_nome = '${client.contato_nome}', " +
            " endereco = '${client.endereco}'," +
            " cidade = '${client.cidade}'," +
            " estado = '${client.estado}'," +
            " cep = '${client.cep}'," +
            " telefone1 = '${client.telefone1}'," +
            " telefone2 = '${client.telefone2}'," +
            " telefone3 = '${client.telefone3}'," +
            " email = '${client.email}'," +
            " obs = '${client.obs}'," +
            " preco_base = '${client.preco_base}'" +
            " WHERE id = '${client.id}'";
        await connection.query(queryString);
        connection.close();
      } catch (e) {
        print(e.toString());
      }
    }
    return 0;
  }

  Future<void> deleteClient(Client client) async {
    MySqlConnection connection = await this.databaseConnection;

    if (connection != null) {
      try {
        // Delete also requires quotes around strings
        String queryString = "DELETE from clientes WHERE id = '${client.id}'";
        await connection.query(queryString);
        connection.close();
      } catch (e) {
        print(e.toString());
        rethrow;
      }
    }
  }

  Future<List<Client>> getClientsList() async {
    MySqlConnection connection = await this.databaseConnection;

    List<Client> listResults = List();
    var sql = "SELECT id, nome,contato_funcao,contato_nome,cgc_cpf," +
        "inscr_estadual,endereco,cidade,estado,cep,telefone1,telefone2," +
        "telefone3,email,obs,preco_base FROM clientes ORDER BY nome";

    if (connection != null) {
      Results results = await connection.query(sql);

      connection.close();

      for (var row in results) {
        listResults.add(Client(
            row[0],
            row[1],
            row[2],
            row[3],
            row[4],
            row[5],
            row[6],
            row[7],
            row[8],
            row[9],
            row[10],
            row[11],
            row[12],
            row[13],
            row[14],
            row[15]));
      }
    }
    return listResults;
  }
}
