import 'dart:async';
import './Linha_Model.dart';
import 'package:mysql1/mysql1.dart';

import 'Db_Connection.dart';

class DatabaseHelper {
  final DbHelper _dbHelper = DbHelper();

  Future<void> insertLinha(Linha linha) async {
    MySqlConnection connection = await _dbHelper.databaseConnection;

    if (connection != null) {
      try {
        await connection.query(
            "INSERT INTO Linhas (codigo,nome,material_nome,material_fabricante,material_tipo," +
                "cor,estoque_1,estoque_2,minimo,pedido) VALUES (?,?,?,?,?,?,?,?,?,?)",
            [
              linha.codigo,
              linha.nome,
              linha.materialNome,
              linha.materialFabricante,
              linha.materialTipo,
              linha.cor,
              linha.estoque_1,
              linha.estoque_2,
              linha.minimo,
              linha.pedido,
            ]);
        connection.close();
      } catch (e) {
        print(e.toString());
        rethrow;
      }
    }
  }

  Future<int> updateLinha(Linha linha) async {
    MySqlConnection connection = await _dbHelper.databaseConnection;

    if (connection != null) {
      try {
        // Update query format is: Update <table> Set Address = 'New Address', Zip = 'New Zip' where Name is 'Pete'
        String queryString = "UPDATE Linhas set nome = '${linha.nome}'," +
            " material_nome = '${linha.materialNome}'," +
            " material_fabricante = '${linha.materialFabricante}', " +
            " material_tipo = '${linha.materialTipo}'," +
            " cor = '${linha.cor}'," +
            " estoque_1 = '${linha.estoque_1}'," +
            " estoque_2 = '${linha.estoque_1}'," +
            " minimo = '${linha.minimo}'," +
            " pedido = '${linha.pedido}'" +
            " WHERE codigo = '${linha.codigo}'";
        await connection.query(queryString);
        connection.close();
      } catch (e) {
        print(e.toString());
      }
    }
    return 0;
  }

  Future<void> deleteLinha(Linha linha) async {
    MySqlConnection connection = await _dbHelper.databaseConnection;

    if (connection != null) {
      try {
        // Delete also requires quotes around strings
        String queryString =
            "DELETE from Linhas WHERE codigo = '${linha.codigo}'";
        await connection.query(queryString);
        connection.close();
      } catch (e) {
        print(e.toString());
        rethrow;
      }
    }
  }

  Future<List<Linha>> getLinhasList(
      [String filter,
      bool mostraEstoqueBaixo,
      int offset = 0,
      int limit = 10]) async {
    MySqlConnection connection = await _dbHelper.databaseConnection;

    List<Linha> listResults = List();
    var sql = "SELECT codigo, nome,material_nome,material_fabricante," +
        "material_tipo,cor,estoque_1,estoque_2,minimo,pedido " +
        "FROM Linhas";

    if (filter != "") {
      sql += " WHERE (codigo = '${filter}' OR nome like '%${filter}%')";
      if (mostraEstoqueBaixo) {
        sql += " AND estoque_1 <= minimo AND minimo > 0";
      }
    } else {
      if (mostraEstoqueBaixo) {
        sql += " WHERE estoque_1 < minimo AND minimo > 0";
      }
    }
    sql += " ORDER BY nome LIMIT ${offset.toString()},${limit.toString()};";

    if (connection != null) {
      Results results = await connection.query(sql);

      connection.close();

      for (var row in results) {
        listResults.add(Linha(row[0], row[1], row[2], row[3], row[4], row[5],
            row[6], row[7], row[8], row[9]));
      }
    }
    return listResults;
  }

  Future<int> getTotItens([
    String filter,
    bool mostraEstoqueBaixo = false,
  ]) async {
    MySqlConnection connection = await _dbHelper.databaseConnection;

    var sql = "SELECT COUNT(*) AS totItens " + "FROM Linhas ";
    if (filter != "") {
      sql += " WHERE (codigo = '${filter}' OR nome like '%${filter}%')";
      if (mostraEstoqueBaixo) {
        sql += " AND estoque_1 <= minimo AND minimo > 0";
      }
    } else {
      if (mostraEstoqueBaixo) {
        sql += " WHERE estoque_1 < minimo AND minimo > 0";
      }
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
