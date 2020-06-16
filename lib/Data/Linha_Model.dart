import 'Linha_Db_Helper.dart';

class Model {
  static final Model _model = new Model._internal();

  factory Model() {
    return _model;
  }

  Model._internal();

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<void> insertLinha(Linha linha) async {
    return _databaseHelper.insertLinha(linha);
  }

  Future<int> updateLinha(Linha linha) async {
    return _databaseHelper.updateLinha(linha);
  }

  Future<void> deleteLinha(Linha linha) async {
    return _databaseHelper.deleteLinha(linha);
  }

  Future<List<Linha>> getLinhasList(
      [String filter, bool estoqueMinimo = false, int offset = 0, int limit = 10]) async {
    return _databaseHelper.getLinhasList(filter, estoqueMinimo, offset, limit);
  }

  Future<int> getTotItens([String filter, bool mostraEstoqueMinimo = false]) async {
    return _databaseHelper.getTotItens(filter, mostraEstoqueMinimo);
  }
}

class Linha {
  String _codigo;
  String _nome;
  String _materialNome;
  String _materialFabricante;
  String _materialTipo;
  int _cor;
  int _estoque1;
  int _estoque2;
  int _minimo;
  int _pedido;

  Linha(
      this._codigo,
      this._nome,
      this._materialNome,
      this._materialFabricante,
      this._materialTipo,
      this._cor,
      this._estoque1,
      this._estoque2,
      this._minimo,
      this._pedido);

  String get codigo => _codigo;
  String get nome => _nome;
  String get materialNome => _materialNome;
  String get materialFabricante => _materialFabricante;
  String get materialTipo => _materialTipo;
  int get cor => _cor;
  int get estoque_1 => _estoque1;
  int get estoque_2 => _estoque2;
  int get minimo => _minimo;
  int get pedido => _pedido;

  set codigo(String novoCodigo) {
    if (novoCodigo.length <= 5) {
      this._nome = novoCodigo;
    }
  }

  set nome(String novoNome) {
    if (novoNome.length <= 80) {
      this._nome = novoNome;
    }
  }

  set materialNome(String novoMaterialNome) {
    if (novoMaterialNome.length <= 20) {
      this._materialNome = novoMaterialNome;
    }
  }

  set materialFabricante(String novoMaterialFabricante) {
    if (novoMaterialFabricante.length <= 20) {
      this._materialFabricante = novoMaterialFabricante;
    }
  }

  set materialTipo(String novoMaterialTipo) {
    if (novoMaterialTipo.length <= 20) {
      this._materialTipo = novoMaterialTipo;
    }
  }

  set cor(int novaCor) {
    if (novaCor >= 0) {
      this._cor = novaCor;
    }
  }

  set estoque_1(int novoEstoque1) {
    if (novoEstoque1 >= 0) {
      this._estoque1 = novoEstoque1;
    }
  }

  set estoque_2(int novoEstoque2) {
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
