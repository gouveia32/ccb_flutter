import 'Fornecedor_Db_Helper.dart';

class Model {
  static final Model _model = new Model._internal();

  factory Model() {
    return _model;
  }

  Model._internal();

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<void> insertFornecedor(Fornecedor fornecedor) async {
    return _databaseHelper.insertFornecedor(fornecedor);
  }

  Future<int> updateFornecedor(Fornecedor fornecedor) async {
    return _databaseHelper.updateFornecedor(fornecedor);
  }

  Future<void> deleteFornecedor(Fornecedor fornecedor) async {
    return _databaseHelper.deleteFornecedor(fornecedor);
  }

  Future<List<Fornecedor>> getFornecedoresList(
      [String filter, int offset = 0, int limit = 10]) async {
    return _databaseHelper.getFornecedoresList(filter, offset, limit);
  }

  Future<int> getTotItens([String filter]) async {
    return _databaseHelper.getTotItens(filter);
  }
}

class Fornecedor {
  int _id;
  String _nome;
  String _contatoFuncao;
  String _contatoNome;
  String _cgcCpf;
  String _inscrEstadual;
  String _endereco;
  String _cidade;
  String _estado;
  String _cep;
  String _telefone1;
  String _telefone2;
  String _telefone3;
  String _email;
  String _obs;

  Fornecedor(
      this._id,
      this._nome,
      this._contatoFuncao,
      this._contatoNome,
      this._cgcCpf,
      this._inscrEstadual,
      this._endereco,
      this._cidade,
      this._estado,
      this._cep,
      this._telefone1,
      this._telefone2,
      this._telefone3,
      this._email,
      this._obs);

  int get id => _id;
  String get nome => _nome;
  String get contatoFuncao => _contatoFuncao;
  String get contatoNome => _contatoNome;
  String get cgcCpf => _cgcCpf;
  String get inscrEstadual => _inscrEstadual;
  String get endereco => _endereco;
  String get cidade => _cidade;
  String get estado => _estado;
  String get cep => _cep;
  String get telefone1 => _telefone1;
  String get telefone2 => _telefone2;
  String get telefone3 => _telefone3;
  String get email => _email;
  String get obs => _obs;

  set nome(String novoNome) {
    if (novoNome.length <= 80) {
      this._nome = novoNome;
    }
  }

  set contatoFuncao(String novoContatoFuncao) {
    if (novoContatoFuncao.length <= 20) {
      this._contatoFuncao = novoContatoFuncao;
    }
  }

  set contatoNome(String novoContatoNome) {
    if (novoContatoNome.length <= 30) {
      this._contatoNome = novoContatoNome;
    }
  }

  set cgcCpf(String novoCgcCpf) {
    if (novoCgcCpf.length <= 30) {
      this._cgcCpf = novoCgcCpf;
    }
  }

  set inscrEstadual(String novainscrEstadual) {
    if (novainscrEstadual.length <= 30) {
      this._inscrEstadual = novainscrEstadual;
    }
  }

  set endereco(String novoEndereco) {
    if (novoEndereco.length <= 255) {
      this._endereco = novoEndereco;
    }
  }

  set cidade(String novaCidade) {
    if (novaCidade.length <= 30) {
      this._cidade = novaCidade;
    }
  }

  set estado(String novoEstado) {
    if (novoEstado.length <= 20) {
      this._estado = novoEstado;
    }
  }

  set cep(String novoCep) {
    if (novoCep.length <= 10) {
      this._cep = novoCep;
    }
  }

  set telefone1(String novoTelefone1) {
    if (novoTelefone1.length <= 30) {
      this._telefone1 = novoTelefone1;
    }
  }

  set telefone2(String novoTelefone2) {
    if (novoTelefone2.length <= 30) {
      this._telefone2 = novoTelefone2;
    }
  }

  set telefone3(String novoTelefone3) {
    if (novoTelefone3.length <= 30) {
      this._telefone3 = novoTelefone3;
    }
  }

  set email(String novoEmail) {
    if (novoEmail.length <= 60) {
      this._email = novoEmail;
    }
  }

  set obs(String novoObs) {
    if (novoObs.length <= 100) {
      this._obs = novoObs;
    }
  }
}
