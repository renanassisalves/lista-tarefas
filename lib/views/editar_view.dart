import 'package:flutter/material.dart';
import 'package:lista_tarefas/components/selecionar_datahora.dart';
import 'package:lista_tarefas/routes/rotas.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import '../models/tarefa.dart';

import '../providers/tarefa_provider.dart';
import '/views/listagem_view.dart';

class Editar extends StatefulWidget {
  Editar({super.key});
  @override
  State<Editar> createState() => _EditarState();
}

class _EditarState extends State<Editar> {
  double latitude = 0.0;
  double longitude = 0.0;

  var controllerTarefa = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final tarefaProvider = Provider.of<TarefaProvider>(context);

    Tarefa tarefa = tarefaProvider.tarefaEditando;
    int index = tarefaProvider.indexEditando;
    tarefaProvider.dataHoraAtual = tarefa.datahora;

    if (controllerTarefa.text == "") {
      controllerTarefa.text = tarefa.nome;
    }

    tarefaProvider.retornarLocalizacao().then((locationData) {
      latitude = locationData.latitude!;
      longitude = locationData.longitude!;
    });

    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: const Text("Editando tarefa"),
          ),
          body:
          Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Tarefa sendo editada...',
                    ),
                    controller: controllerTarefa,
                  ),
                  const SizedBox(height: 32),
                  const Text("Selecione a nova data e a hora",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 16),
                  SelecionarDataHora(context),
                  const SizedBox(height: 32,),
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(onPressed: () {
                        Navigator.pop(context);
                      }, child: const Text("Cancelar")),
                      const SizedBox(width: 16),
                      ElevatedButton(onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: const Text("Deseja mesmo deletar essa tarefa?"),
                              actions: [ElevatedButton(
                                onPressed: () => Navigator.pop(context, false), // passing false
                                child: const Text('Não'),
                              ),
                                ElevatedButton(
                                  onPressed: () {
                                    tarefaProvider.listaTarefas.remove(index);
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const Listagem()),
                                            (Route<dynamic> route) => false);
                                  }, // passing true
                                  child: const Text('Sim'),
                                ),],
                            );
                          },
                        );
                      }, child: const Text("Deletar")),
                      const SizedBox(width: 16),
                      ElevatedButton(onPressed: () {
                        if (controllerTarefa.text == "") {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: const Text("Digite um novo texto para a tarefa antes de editá-la."),
                                actions: [TextButton(onPressed: () {
                                  Navigator.pop(context);
                                }, child: const Text("Fechar"))],
                              );
                            },
                          );
                        } else {
                          Tarefa tarefaEditando = tarefa;
                          tarefaEditando.nome = controllerTarefa.text;
                          tarefaEditando.datahora = tarefaProvider.dataHoraAtual;
                          tarefaEditando.longitude = longitude;
                          tarefaEditando.latitude = latitude;
                          tarefaProvider.listaTarefas[index] = tarefaEditando;
                          Navigator.pushNamedAndRemoveUntil(context, Rotas.LISTAGEM_TAREFAS, (route) => false);
                        }
                      }, child: const Text("Salvar")
                      ),
                    ],),
                ],)
          ),
        )
    );
  }
}
