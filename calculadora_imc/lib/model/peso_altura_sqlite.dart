class PesoAlturaModel {
  int _id = 0;
  double _peso = 0;
  double _altura = 0;
  double _resultado = 0;

  PesoAlturaModel(this._id, this._peso, this._altura, this._resultado);

//get
  int get id => _id;

  double get peso => _peso;

  double get altura => _altura;

  double get resultado => _resultado;

//set
  set id(id) => _id = id;

  set peso(peso) => _peso = peso;

  set altura(altura) => _altura = altura;

  set resultado(resultado) => _resultado = resultado;
}
