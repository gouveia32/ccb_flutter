import 'Bordado_Db_Helper.dart';

class Model {
  static final Model _model = new Model._internal();

  factory Model() {
    return _model;
  }

  Model._internal();

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<void> insertBordado(Bordado bordado) async {
    return _databaseHelper.insertBordado(bordado);
  }

  Future<int> updateBordado(Bordado bordado) async {
    return _databaseHelper.updateBordado(bordado);
  }

  Future<void> deleteBordado(Bordado bordado) async {
    return _databaseHelper.deleteBordado(bordado);
  }

  Future<List<Bordado>> getBordadosList(
      [String filter, int offset = 0, int limit = 10]) async {
    return _databaseHelper.getBordadosList(filter, offset, limit);
  }

  Future<int> getTotItens([String filter]) async {
    return _databaseHelper.getTotItens(filter);
  }
}

class Bordado {
  int _id;
  String _arquivo;
  String _descricao;
  String _caminho;
  String _disquete;
  String _bastidor;
  int _grupoId;
  double _preco;
  int _pontos;
  int _cores;
  int _largura;
  int _altura;
  bool _aprovado;
  bool _alerta;
  int _metragem;
  String _imagem;
  int _corFundo;
  String _obsPublica;
  String _obsRestrita;

  Bordado(
      this._id,
      this._arquivo,
      this._descricao,
      this._caminho,
      this._disquete,
      this._bastidor,
      this._grupoId,
      this._preco,
      this._pontos,
      this._cores,
      this._largura,
      this._altura,
      this._aprovado,
      this._alerta,
      this._metragem,
      this._imagem,
      this._corFundo,
      this._obsPublica,
      this._obsRestrita);

  int get id => _id;
  String get arquivo => _arquivo;
  String get descricao => _descricao;
  String get caminho => _caminho;
  String get disquete => _disquete;
  String get bastidor => _bastidor;
  int get grupoId => _grupoId;
  double get preco => _preco;
  int get pontos => _pontos;
  int get cores => _cores;
  int get largura => _largura;
  int get altura => _altura;
  bool get aprovado => _aprovado;
  bool get alerta => _alerta;
  int get metragem => _metragem;
  String get imagem => _imagem;
  int get corFundo => _corFundo;
  String get obsPublica => _obsPublica;
  String get obsRestrita => _obsRestrita;

  set arquivo(String novoArquivo) {
    if (novoArquivo.length <= 80) {
      this._arquivo = novoArquivo;
    }
  }

  set descricao(String novnovaDescricao) {
    if (novnovaDescricao.length <= 20) {
      this._descricao = novnovaDescricao;
    }
  }

  set caminho(String novoCaminho) {
    if (novoCaminho.length <= 30) {
      this._caminho = novoCaminho;
    }
  }

  set disquete(String novoDisquete) {
    if (novoDisquete.length <= 30) {
      this._disquete = novoDisquete;
    }
  }

  set bastidor(String novoBastidor) {
    if (novoBastidor.length <= 30) {
      this._bastidor = novoBastidor;
    }
  }

  set grupoId(int novoGrupoId) {
    if (novoGrupoId <= 0) {
      this._grupoId = novoGrupoId;
    }
  }

  set preco(double novPreco) {
    if (novPreco <= 0) {
      this._preco = novPreco;
    }
  }

  set pontos(int novoPontos) {
    if (novoPontos <= 0) {
      this._pontos = novoPontos;
    }
  }

  set cores(int novaCores) {
    if (novaCores <= 0) {
      this._cores = novaCores;
    }
  }

  set largura(int novaLargura) {
    if (novaLargura <= 0) {
      this._largura = novaLargura;
    }
  }

  set altura(int novaAltura) {
    if (novaAltura <= 0) {
      this._altura = novaAltura;
    }
  }

  set aprovado(bool novoAprovado) {
    this._aprovado = novoAprovado;
  }

  set alerta(bool novoAlerta) {
    this._alerta = novoAlerta;
  }

  set metragem(int novaMetragem) {
    if (novaMetragem <= 0) {
      this._metragem = novaMetragem;
    }
  }

  set imagem(String novaImagem) {
    if (novaImagem.length <= 20) {
      this._imagem = novaImagem;
    }
  }

  set corFundo(int novaCorFundo) {
    if (novaCorFundo <= 0) {
      this._corFundo = novaCorFundo;
    }
  }

  set obsPublica(String novaObsPublica) {
    if (novaObsPublica.length <= 10) {
      this._obsPublica = novaObsPublica;
    }
  }

  set obsRestrita(String novaObsRestrita) {
    if (novaObsRestrita.length <= 10) {
      this._obsRestrita = novaObsRestrita;
    }
  }
}
