import 'package:calculadora_imc/model/peso_altura_sqlite.dart';

import 'package:calculadora_imc/repository/sqlite/peso_altura_sqlite_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  PesoAlturaSqliteRepository pesoAlturaRepository =
      PesoAlturaSqliteRepository();
  var pesoController = TextEditingController();
  var alturaController = TextEditingController();
  var _pesoAltura = const <PesoAlturaModel>[];

  late SharedPreferences storage;

  final String CHAVE_PESO = "CHAVE_PESO";
  final String CHAVE_ALTURA = "CHAVE_ALTURA";

  @override
  void initState() {
    super.initState();
    obterDados();
    carregarDados();
  }

  void obterDados() async {
    _pesoAltura = await pesoAlturaRepository.obterDados();
    setState(() {});
  }

  void carregarDados() async {
    storage = await SharedPreferences.getInstance();
    pesoController.text = storage.getDouble(CHAVE_PESO).toString();
    alturaController.text = storage.getDouble(CHAVE_ALTURA).toString();
    setState(() {});
  }

  resultado(imc) {
    if (imc < 16) {
      return Text("IMC: ${imc.toStringAsFixed(1)} - Magreza Grave");
    } else if ((imc >= 16) && (imc < 17)) {
      return Text("IMC: ${imc.toStringAsFixed(1)} - Magreza Moderada");
    } else if ((imc >= 17) && (imc < 18.5)) {
      return Text("IMC: ${imc.toStringAsFixed(1)} - Magreza Leve");
    } else if ((imc >= 18.5) && (imc < 25)) {
      return Text("IMC: ${imc.toStringAsFixed(1)} - Saudável");
    } else if ((imc <= 25) && (imc < 30)) {
      return Text("IMC: ${imc.toStringAsFixed(1)} - Sobrepeso");
    } else if ((imc <= 30) && (imc < 35)) {
      return Text("IMC: ${imc.toStringAsFixed(1)} - Obesidade Grau I");
    } else if ((imc <= 35) && (imc < 40)) {
      return Text(
          "IMC: ${imc.toStringAsFixed(1)} - Obesidade Grau II - (Severa)");
    } else {
      return Text(
          "IMC: ${imc.toStringAsFixed(1)} - Obesidade Grau III - (Mórbida)");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text(
              "Calculadora IMC",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            backgroundColor: Colors.greenAccent[400],
          ),
          floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.calculate),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext bc) {
                      return AlertDialog(
                        title: const Text(
                          "Calcule o seu IMC",
                          style: TextStyle(fontSize: 20),
                        ),
                        content: Wrap(
                          children: [
                            const Text("Peso"),
                            TextField(
                              controller: pesoController,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text("Altura"),
                            TextField(
                              controller: alturaController,
                            )
                          ],
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancelar")),
                          TextButton(
                              onPressed: () async {
                                double peso = double.parse(pesoController.text);
                                double altura =
                                    double.parse(alturaController.text);

                                double resultado = (peso / (altura * altura));
                                await pesoAlturaRepository.salvar(
                                    PesoAlturaModel(
                                        0, peso, altura, resultado));

                                storage.setDouble(CHAVE_PESO,
                                    double.parse(pesoController.text));
                                storage.setDouble(CHAVE_ALTURA,
                                    double.parse(alturaController.text));
                                Navigator.pop(context);
                                obterDados();
                                setState(() {});
                              },
                              child: const Text("Calcular"))
                        ],
                      );
                    });
              }),
          body: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListView.builder(
                itemCount: _pesoAltura.length,
                itemBuilder: (BuildContext bc, int index) {
                  var pesoAltura = _pesoAltura[index];
                  // String peso = pesoAltura.peso.toString();
                  // return Row(
                  //   children: [
                  //     Text("Peso: ${pesoAltura.peso.toString()}"),
                  //     Text("Altura: ${pesoAltura.altura.toString()}"),
                  //     Text("IMC: ${pesoAltura.resultado.toString()}")
                  //   ],
                  // );
                  return Dismissible(
                    key: Key(pesoAltura.id.toString()),
                    onDismissed: (DismissDirection dismissDirection) async {
                      pesoAlturaRepository.remover(pesoAltura.id);
                      obterDados();
                    },
                    child: Card(
                      child: ListTile(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext bc) {
                                return AlertDialog(
                                  title: resultado(pesoAltura.resultado),
                                );
                              });
                        },
                        title: Text("Peso: ${pesoAltura.peso.toString()} Kg"),
                        subtitle:
                            Text("Altura: ${pesoAltura.altura.toString()} M"),
                        trailing: Text(
                            "IMC: ${pesoAltura.resultado.toStringAsFixed(1)}"),
                      ),
                    ),
                  );
                }),
          )),
    );
  }
}
