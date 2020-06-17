import 'dart:async';
import './Fornecedor_Model.dart';
import 'package:mysql1/mysql1.dart';

import 'Constants.dart';

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
      _databaseConnection = await MySqlConnection.connect(ConnectionSettings(
          host: host, port: 3306, user: user, db: db, password: password));
    } catch (e) {
      print(e.toString());
      rethrow;
    }
    return _databaseConnection;
  }

  Future<void> insertFornecedor(Fornecedor fornecedor) async {
    MySqlConnection connection = await this.databaseConnection;

    if (connection != null) {
      try {
        await connection.query(
            "INSERT INTO Fornecedores (nome,contato_funcao,contato_nome,cgc_cpf," +
                "inscr_estadual,endereco,cidade,estado,telefone1,telefone2," +
                "telefone3,email,obs) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)",
            [
              fornecedor.nome,
              fornecedor.contatoFuncao,
              fornecedor.contatoNome,
              fornecedor.cgcCpf,
              fornecedor.endereco,
              fornecedor.cidade,
              fornecedor.estado,
              fornecedor.cep,
              fornecedor.telefone1,
              fornecedor.telefone2,
              fornecedor.telefone3,
              fornecedor.email,
              fornecedor.obs
            ]);
        connection.close();
      } catch (e) {
        print(e.toString());
        rethrow;
      }
    }
  }

  Future<int> updateFornecedor(Fornecedor fornecedor) async {
    MySqlConnection connection = await this.databaseConnection;

    if (connection != null) {
      try {
        // Update query format is: Update <table> Set Address = 'New Address', Zip = 'New Zip' where Name is 'Pete'
        String queryString =
            "UPDATE fornecedors set nome = '${fornecedor.nome}'," +
                " contato_funcao = '${fornecedor.contatoFuncao}'," +
                " contato_nome = '${fornecedor.contatoNome}', " +
                " endereco = '${fornecedor.endereco}'," +
                " cidade = '${fornecedor.cidade}'," +
                " estado = '${fornecedor.estado}'," +
                " cep = '${fornecedor.cep}'," +
                " telefone1 = '${fornecedor.telefone1}'," +
                " telefone2 = '${fornecedor.telefone2}'," +
                " telefone3 = '${fornecedor.telefone3}'," +
                " email = '${fornecedor.email}'," +
                " obs = '${fornecedor.obs}'" +
                " WHERE id = '${fornecedor.id}'";
        await connection.query(queryString);
        connection.close();
      } catch (e) {
        print(e.toString());
      }
    }
    return 0;
  }

  Future<void> deleteFornecedor(Fornecedor fornecedor) async {
    MySqlConnection connection = await this.databaseConnection;

    if (connection != null) {
      try {
        // Delete also requires quotes around strings
        String queryString =
            "DELETE from fornecedors WHERE id = '${fornecedor.id}'";
        await connection.query(queryString);
        connection.close();
      } catch (e) {
        print(e.toString());
        rethrow;
      }
    }
  }

  Future<List<Fornecedor>> getFornecedoresList(
      [String filter, int offset = 0, int limit = 10]) async {
    MySqlConnection connection = await this.databaseConnection;

    List<Fornecedor> listResults = List();
    var sql = "SELECT id, nome,contato_funcao,contato_nome,cgc_cpf," +
        "inscr_estadual,endereco,cidade,estado,cep,telefone1,telefone2," +
        "telefone3,email,obs FROM fornecedores ";

    if (filter == null) {
      sql +=
          " ORDER BY nome LIMIT " + offset.toString() + "," + limit.toString();
    } else {
      sql +=
          " WHERE contato_nome like '%${filter}%' OR nome like '%${filter}%' ORDER BY nome LIMIT " +
              offset.toString() +
              "," +
              limit.toString();
    }

    if (connection != null) {
      Results results = await connection.query(sql);

      connection.close();

      for (var row in results) {
        listResults.add(Fornecedor(
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
            row[14]));
      }
    }
    return listResults;
  }

  Future<int> getTotItens([String filter]) async {
    MySqlConnection connection = await this.databaseConnection;

    var sql = "SELECT COUNT(*) AS totItens " + "FROM fornecedores ";
    if (filter == "") {
      sql += ";";
    } else {
      sql +=
          " WHERE nome LIKE '%${filter}%' OR contato_nome LIKE '%${filter}%';";
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
