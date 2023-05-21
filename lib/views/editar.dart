import 'package:flutter/material.dart';
import 'package:lista_tarefas/utils/utils.dart';
import 'package:location/location.dart';
import '../models/item.dart';
import '/views/listagem.dart';

class Editar extends StatefulWidget {
  Item? itemAtual;
  List<Item>? lista;
  int index;
  Editar({super.key, required this.lista, required this.itemAtual, required this.index});
  @override
  State<Editar> createState() => _EditarState();
}

class _EditarState extends State<Editar> {
  double latitude = 0.0;
  double longitude = 0.0;
  List<Item> listaItens = [];

  var controllerTarefa = TextEditingController();

  @override
  Widget build(BuildContext context) {
    int index = widget.index;

    if (widget.lista != null) {
      listaItens = widget.lista!;
    }

    Item tarefa = widget.itemAtual!;
    DateTime dateTime = tarefa.datahora;

    controllerTarefa.text = tarefa.nome;

    inicializarServicoLocalizacao();

    _selecionarData() async {
      final data = await pegarData(context, dateTime);
      if (data == null) return;

      final novaDataHora = DateTime(
          data.year,
          data.month,
          data.day,
          dateTime.hour,
          dateTime.minute
      );

      setState(() {
        tarefa.datahora = novaDataHora;
      });
    }

    _selecionarHorario() async {
      final horario = await pegarHorario(context, dateTime);
      if (horario == null) return;

      final novaDataHora = DateTime(
          dateTime.year,
          dateTime.month,
          dateTime.day,
          horario.hour,
          horario.minute
      );

      setState(() {
        tarefa.datahora = novaDataHora;
      });
    }

    Widget _selecionarDataHora() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {_selecionarData();},
            child: Text('${dateTime.day}/${dateTime.month}/${dateTime.year}'),
          ),
          const SizedBox(width: 10),
          ElevatedButton(onPressed: () async {_selecionarHorario();},
              child: Text('${dateTime.hour.toString().padLeft(2, "0")}:${dateTime.minute.toString().padLeft(2, "0")}'))
        ],
      );
    }

    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text("Editando tarefa"),
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
                  _selecionarDataHora(),
                  const SizedBox(height: 32,),
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(onPressed: () {
                        Navigator.pop(context);
                      }, child: Text("Cancelar")),
                      SizedBox(width: 16),
                      ElevatedButton(onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text("Deseja mesmo deletar essa tarefa?"),
                              actions: [ElevatedButton(
                                onPressed: () => Navigator.pop(context, false), // passing false
                                child: Text('Não'),
                              ),
                                ElevatedButton(
                                  onPressed: () {
                                    listaItens.removeAt(index);
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Listagem(listaTarefas: listaItens)),
                                            (Route<dynamic> route) => false);
                                  }, // passing true
                                  child: Text('Sim'),
                                ),],
                            );
                          },
                        );
                      }, child: Text("Deletar")),
                      SizedBox(width: 16),
                      ElevatedButton(onPressed: () {
                        if (controllerTarefa.text == "") {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text("Digite um novo texto para a tarefa antes de editá-la."),
                                actions: [TextButton(onPressed: () {
                                  Navigator.pop(context);
                                }, child: Text("Fechar"))],
                              );
                            },
                          );
                        } else {
                          Item tarefaEditando = listaItens[index];
                          tarefaEditando.nome = controllerTarefa.text;
                          tarefaEditando.datahora = dateTime;
                          tarefa.longitude = longitude;
                          tarefa.latitude = latitude;

                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Listagem(listaTarefas: listaItens)),
                                  (Route<dynamic> route) => false);
                        }
                      }, child: const Text("Salvar")
                      ),
                    ],),
                ],)
          ),
        )
    );
  }
  Future<DateTime?> pegarData(context, dateTime) => showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(2023),
      lastDate: DateTime(2100)
  );

  Future<TimeOfDay?> pegarHorario(context, dateTime) => showTimePicker(
      context: context,
      initialTime: TimeOfDay(
          hour: dateTime.hour,
          minute: dateTime.minute)
  );

  Future inicializarServicoLocalizacao() async {
    var location = Location();

    if (!await location.serviceEnabled()) {
      if (!await location.requestService()) {
        return;
      }
    }

    var permission = await location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await location.requestPermission();
      if (permission != PermissionStatus.granted) {
        return;
      }
    }

    var loc = await location.getLocation();

    latitude = loc.latitude ?? 0.0;
    longitude = loc.longitude ?? 0.0;
  }
}
