import 'dart:async';
import './Cliente_Model.dart';
import 'package:mysql1/mysql1.dart';

import 'Db_Connection.dart';

class DatabaseHelper {
  final DbHelper _dbHelper = DbHelper();

  Future<void> insertCliente(Cliente cliente) async {
    MySqlConnection connection = await _dbHelper.databaseConnection;

    if (connection != null) {
      try {
        await connection.query(
            "INSERT INTO Clientes (nome,contato_funcao,contato_nome,cgc_cpf," +
                "inscr_estadual,endereco,cidade,estado,telefone1,telefone2," +
                "telefone3,email,obs,preco_base) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)",
            [
              cliente.nome,
              cliente.contatoFuncao,
              cliente.contatoNome,
              cliente.cgcCpf,
              cliente.endereco,
              cliente.cidade,
              cliente.estado,
              cliente.cep,
              cliente.telefone1,
              cliente.telefone2,
              cliente.telefone3,
              cliente.email,
              cliente.obs,
              cliente.precoBase
            ]);
        connection.close();
      } catch (e) {
        print(e.toString());
        rethrow;
      }
    }
  }

  Future<int> updateCliente(Cliente cliente) async {
    MySqlConnection connection = await _dbHelper.databaseConnection;

    if (connection != null) {
      try {
        // Update query format is: Update <table> Set Address = 'New Address', Zip = 'New Zip' where Name is 'Pete'
        String queryString = "UPDATE clientes set nome = '${cliente.nome}'," +
            " contato_funcao = '${cliente.contatoFuncao}'," +
            " contato_nome = '${cliente.contatoNome}', " +
            " endereco = '${cliente.endereco}'," +
            " cidade = '${cliente.cidade}'," +
            " estado = '${cliente.estado}'," +
            " cep = '${cliente.cep}'," +
            " telefone1 = '${cliente.telefone1}'," +
            " telefone2 = '${cliente.telefone2}'," +
            " telefone3 = '${cliente.telefone3}'," +
            " email = '${cliente.email}'," +
            " obs = '${cliente.obs}'," +
            " preco_base = '${cliente.precoBase}'" +
            " WHERE id = '${cliente.id}'";
        await connection.query(queryString);
        connection.close();
      } catch (e) {
        print(e.toString());
      }
    }
    return 0;
  }

  Future<void> deleteCliente(Cliente cliente) async {
    MySqlConnection connection = await _dbHelper.databaseConnection;

    if (connection != null) {
      try {
        // Delete also requires quotes around strings
        String queryString = "DELETE from clientes WHERE id = '${cliente.id}'";
        await connection.query(queryString);
        connection.close();
      } catch (e) {
        print(e.toString());
        rethrow;
      }
    }
  }

  Future<List<Cliente>> getClientesList(
      [String filter, int offset = 0, int limit = 10]) async {
    MySqlConnection connection = await _dbHelper.databaseConnection;

    List<Cliente> listResults = List();
    var sql = "SELECT id, nome,contato_funcao,contato_nome,cgc_cpf," +
        "inscr_estadual,endereco,cidade,estado,cep,telefone1,telefone2," +
        "telefone3,email,obs,preco_base FROM clientes ";

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
        listResults.add(Cliente(
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

  Future<int> getTotItens([String filter]) async {
    MySqlConnection connection = await _dbHelper.databaseConnection;

    var sql = "SELECT COUNT(*) AS totItens " + "FROM Clientes ";
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
