import 'Linha_Db_Helper.dart';

class Model {
  static final Model _model = new Model._internal();

  factory Model() {
    return _model;
  }

  Model._internal();

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<void> insertClient(Client client) async {
    return _databaseHelper.insertClient(client);
  }

  Future<int> updateClient(Client client) async {
    return _databaseHelper.updateClient(client);
  }

  Future<void> deleteClient(Client client) async {
    return _databaseHelper.deleteClient(client);
  }

  Future<List<Client>> getClientsList() async {
    return _databaseHelper.getClientsList();
  }
}

class Client {
  int _id;
  String _nome;
  String _material_nome;
  String _material_fabricante;
  String _material_tipo;
  int _cor;
  int _estoque1;
  int _estoque2;
  int _minimo;
  int _pedido;

  Client(
      this._id,
      this._nome,
      this._material_nome,
      this._material_fabricante,
      this._material_tipo,
      this._cor,
      this._estoque1,
      this._estoque2,
      this._minimo,
      this._pedido,

  int get id => _id;
  String get nome => _nome;
  String get material_nome => __material_nome;
  String get material_fabricante => __material_fabricante;
  String get material_tipo => __material_tipo;
  String get cor => _cor;
  String get estoque1 => _estoque1;
  String get estoque2 => _estoque2;
  String get minimo => _minimo;
  String get pedido => _pedido;


  set nome(String novoNome) {
    if (novoNome.length <= 80) {
      this._nome = novoNome;
    }
  }

  set material_nome(String novoMaterialNome) {
    if (novoMaterialNome.length <= 20) {
      this._material_nome = novoMaterialNome;
    }
  }
  set material_fabricante(String novoMaterialFabricante) {
    if (novoMaterialFabricante.length <= 20) {
      this._material_fabricante = novoMaterialFabricante;
    }
  }
  set material_tipo(String novoMaterialTipo) {
    if (novoMaterialTipo.length <= 20) {
      this._material_tipo = novoMaterialTipo;
    }
  }
  set cor(int novaCor) {
    if (novaCor >= 0) {
      this._cor = novaCor;
    }
  }
  set estoque1(int novoEstoque1) {
    if (novoEstoque1 >= 0) {
      this._estoque1 = novoEstoque1;
    }
  }
  set estoque2(int novoEstoque2) {
    if (novoEstoque2 >= 0) {
      this._estoque2 = novoEstoque2;
    }
  }
  set minimo(int novoMinimo) {
    if (novoMinimo >= 0) {
      this._minimo = novoMinimo;
    }
  }
  set pedido(int novoPedido) {
    if (novoPedido >= 0) {
      this._pedido = novoPedido;
    }
  }

}
