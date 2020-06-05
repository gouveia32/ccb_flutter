import 'Cliente_Db_Helper.dart';

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
  String _contato_funcao;
  String _contato_nome;
  String _cgc_cpf;
  String _inscr_estadual;
  String _endereco;
  String _cidade;
  String _estado;
  String _cep;
  String _telefone1;
  String _telefone2;
  String _telefone3;
  String _email;
  String _obs;
  double _preco_base;

  Client(
      this._id,
      this._nome,
      this._contato_funcao,
      this._contato_nome,
      this._cgc_cpf,
      this._inscr_estadual,
      this._endereco,
      this._cidade,
      this._estado,
      this._cep,
      this._telefone1,
      this._telefone2,
      this._telefone3,
      this._email,
      this._obs,
      this._preco_base);

  int get id => _id;
  String get nome => _nome;
  String get contato_funcao => _contato_funcao;
  String get contato_nome => _contato_nome;
  String get cgc_cpf => _cgc_cpf;
  String get inscr_estadual => _inscr_estadual;
  String get endereco => _endereco;
  String get cidade => _cidade;
  String get estado => _estado;
  String get cep => _cep;
  String get telefone1 => _telefone1;
  String get telefone2 => _telefone2;
  String get telefone3 => _telefone3;
  String get email => _email;
  String get obs => _obs;
  double get preco_base => _preco_base;

  set nome(String novoNome) {
    if (novoNome.length <= 80) {
      this._nome = novoNome;
    }
  }

  set contato_funcao(String novoContatoFuncao) {
    if (novoContatoFuncao.length <= 20) {
      this._contato_funcao = novoContatoFuncao;
    }
  }

  set contato_nome(String novoContatoNome) {
    if (novoContatoNome.length <= 30) {
      this._contato_nome = novoContatoNome;
    }
  }

  set cgc_cpf(String novoCgcCpf) {
    if (novoCgcCpf.length <= 30) {
      this._cgc_cpf = novoCgcCpf;
    }
  }

  set inscr_estadual(String novainscrEstadual) {
    if (novainscrEstadual.length <= 30) {
      this._inscr_estadual = novainscrEstadual;
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

  set preco_base(double novoPrecoBase) {
    if (novoPrecoBase < 0.0) {
      this._preco_base = novoPrecoBase;
    }
  }
}
