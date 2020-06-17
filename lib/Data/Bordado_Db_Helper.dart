import 'dart:async';
import './Bordado_Model.dart';
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

  Future<void> insertBordado(Bordado bordado) async {
    MySqlConnection connection = await this.databaseConnection;

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
    MySqlConnection connection = await this.databaseConnection;

    if (connection != null) {
      try {
        // Update query format is: Update <table> Set Address = 'New Address', Zip = 'New Zip' where Name is 'Pete'
        String queryString = "UPDATE bordados set nome = '${bordado.nome}'," +
            " contato_funcao = '${bordado.contatoFuncao}'," +
            " contato_nome = '${bordado.contatoNome}', " +
            " endereco = '${bordado.endereco}'," +
            " cidade = '${bordado.cidade}'," +
            " estado = '${bordado.estado}'," +
            " cep = '${bordado.cep}'," +
            " telefone1 = '${bordado.telefone1}'," +
            " telefone2 = '${bordado.telefone2}'," +
            " telefone3 = '${bordado.telefone3}'," +
            " email = '${bordado.email}'," +
            " obs = '${bordado.obs}'," +
            " preco_base = '${bordado.precoBase}'" +
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
    MySqlConnection connection = await this.databaseConnection;

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
    MySqlConnection connection = await this.databaseConnection;

    List<Bordado> listResults = List();
    var sql = "SELECT id, nome,contato_funcao,contato_nome,cgc_cpf," +
        "inscr_estadual,endereco,cidade,estado,cep,telefone1,telefone2," +
        "telefone3,email,obs,preco_base FROM Bordados ";

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
            row[15]));
      }
    }
    return listResults;
  }

  Future<int> getTotItens([String filter]) async {
    MySqlConnection connection = await this.databaseConnection;

    var sql = "SELECT COUNT(*) AS totItens " + "FROM Bordados ";
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
