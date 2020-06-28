import 'dart:async';
import 'dart:typed_data';
import './Bordado_Model.dart';
import 'package:mysql1/mysql1.dart';

import 'dart:convert';
import 'Db_Connection.dart';

class DatabaseHelper {
  final DbHelper _dbHelper = DbHelper();

  Future<void> insertBordado(Bordado bordado) async {
    MySqlConnection connection = await _dbHelper.databaseConnection;

    if (connection != null) {
      try {
        await connection.query(
            "INSERT INTO Bordados (arquivo,descricao,caminho,disquete," +
                "bastidor,grupoId,preco,pontos,cores,largura,altura," +
                "aprovado,alerta,metragem,imagem,cor_fundo,obs_publica," +
                "obs_restrita) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
            [
              bordado.arquivo,
              bordado.descricao,
              bordado.caminho,
              bordado.disquete,
              bordado.bastidor,
              bordado.grupoId,
              bordado.preco,
              bordado.pontos,
              bordado.cores,
              bordado.largura,
              bordado.altura,
              bordado.aprovado,
              bordado.alerta,
              bordado.metragem,
              bordado.imagem,
              bordado.corFundo,
              bordado.obsPublica,
              bordado.obsRestrita
            ]);
        connection.close();
      } catch (e) {
        print(e.toString());
        rethrow;
      }
    }
  }

  Future<int> updateBordado(Bordado bordado) async {
    MySqlConnection connection = await _dbHelper.databaseConnection;

    if (connection != null) {
      try {
        // Update query format is: Update <table> Set Address = 'New Address', Zip = 'New Zip' where Name is 'Pete'
        String queryString =
            "UPDATE bordados set arquivo = '${bordado.arquivo}'," +
                " descricao = '${bordado.descricao}'," +
                " caminho = '${bordado.caminho}', " +
                " disquete = '${bordado.disquete}'," +
                " bastidor = '${bordado.bastidor}'," +
                " grupo_id = '${bordado.grupoId}'," +
                " preco = '${bordado.preco}'," +
                " pontos = '${bordado.pontos}'," +
                " cores = '${bordado.cores}'," +
                " largura = '${bordado.largura}'," +
                " altura = '${bordado.altura}'," +
                " aprovado = '${bordado.aprovado}'," +
                " alerta = '${bordado.alerta}'," +
                " metragem = '${bordado.metragem}'," +
                " imagem = '${bordado.imagem}'," +
                " cor_fundo = '${bordado.corFundo}'," +
                " obs_publica = '${bordado.obsPublica}'," +
                " obs_restrita = '${bordado.obsRestrita}'" +
                " WHERE id = '${bordado.id}'";
        await connection.query(queryString);
        connection.close();
      } catch (e) {
        print(e.toString());
      }
    }
    return 0;
  }

  Future<void> deleteBordado(Bordado bordado) async {
    MySqlConnection connection = await _dbHelper.databaseConnection;

    if (connection != null) {
      try {
        // Delete also requires quotes around strings
        String queryString = "DELETE from bordados WHERE id = '${bordado.id}'";
        await connection.query(queryString);
        connection.close();
      } catch (e) {
        print(e.toString());
        rethrow;
      }
    }
  }

  Future<List<Bordado>> getBordadosList(
      [String filter, int offset = 0, int limit = 10]) async {
    MySqlConnection connection = await _dbHelper.databaseConnection;

    List<Bordado> listResults = List();
    var sql = "SELECT id, arquivo,descricao,caminho,disquete," +
        "bastidor,grupo_id,preco,pontos,cores,largura,altura," +
        "aprovado,alerta,metragem,imagem,cor_fundo,obs_publica," +
        "obs_restrita FROM Bordados ";

    if (filter == null) {
      sql += " ORDER BY arquivo LIMIT " +
          offset.toString() +
          "," +
          limit.toString();
    } else {
      sql +=
          " WHERE arquivo like '%${filter}%' OR descricao like '%${filter}%' ORDER BY arquivo LIMIT " +
              offset.toString() +
              "," +
              limit.toString();
    }

    if (connection != null) {
      Results results = await connection.query(sql);

      connection.close();

      for (var row in results) {
        Uint8List bytesImage1;
        try {
          bytesImage1 = base64Decode(row[15]);
        } catch (err) {}

        listResults.add(Bordado(
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
            bytesImage1,
            row[16],
            row[17],
            row[18]));
      }
    }
    return listResults;
  }

  Future<int> getTotItens([String filter]) async {
    MySqlConnection connection = await _dbHelper.databaseConnection;

    var sql = "SELECT COUNT(*) AS totItens " + "FROM Bordados ";
    if (filter == "") {
      sql += ";";
    } else {
      sql +=
          " WHERE arquivo LIKE '%${filter}%' OR descricao LIKE '%${filter}%';";
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
