import 'package:calculadora_imc/model/peso_altura_sqlite.dart';
import 'package:calculadora_imc/repository/sqlite/database.dart';

class PesoAlturaSqliteRepository {
  Future<List<PesoAlturaModel>> obterDados() async {
    List<PesoAlturaModel> pesoAltura = [];
    var db = await SqliteDataBase().obterDatabase();
    var result = await db
        .rawQuery('SELECT id, peso, altura, resultado FROM calculadora');
    for (var element in result) {
      pesoAltura.add(PesoAlturaModel(
          int.parse(element["id"].toString()),
          double.parse(element["peso"].toString()),
          double.parse(element["altura"].toString()),
          double.parse(element["resultado"].toString())));
    }

    return pesoAltura;
  }

  Future<void> salvar(PesoAlturaModel pesoAlturaModel) async {
    var db = await SqliteDataBase().obterDatabase();
    db.rawInsert(
        "INSERT INTO calculadora (peso, altura, resultado) values(?,?,?)", [
      pesoAlturaModel.peso,
      pesoAlturaModel.altura,
      pesoAlturaModel.resultado
    ]);
  }

  Future<void> atualizar(PesoAlturaModel pesoAlturaModel) async {
    var db = await SqliteDataBase().obterDatabase();
    db.rawInsert(
        "UPDATE calculadora SET peso = ?, altura = ?, resultado = ? WHERE id = ?",
        [
          pesoAlturaModel.peso,
          pesoAlturaModel.altura,
          pesoAlturaModel.resultado,
          pesoAlturaModel.id
        ]);
  }

  Future<void> remover(int id) async {
    var db = await SqliteDataBase().obterDatabase();
    db.rawInsert("DELETE FROM calculadora WHERE id = ?", [id]);
  }
}
