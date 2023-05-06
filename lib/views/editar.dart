import 'package:flutter/material.dart';
import 'package:location/location.dart';
import '../classes.dart';
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
  DateTime dateTime = DateTime.now();
  double latitude = 0.0;
  double longitude = 0.0;
  List<Item> listaItens = [];

  var controllerTarefa = TextEditingController();

  @override
  void dispose() {
    controllerTarefa.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int index = widget.index;

    if (widget.lista != null)
    {
      listaItens = widget.lista!;
    }

    Item tarefa = widget.itemAtual!;

    controllerTarefa.text = tarefa.nome;

    _initLocationService();

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          final date = await pickDate();
                          if (date == null) return;
                          setState(() {
                            dateTime = date;
                          });
                        },
                        child: Text('${dateTime.day}/${dateTime.month}/${dateTime.year}'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(onPressed: () async {
                        final time = await pickTime();
                        if (time == null) return;

                        final newDateTime = DateTime(
                            dateTime.year,
                            dateTime.month,
                            dateTime.day,
                            time.hour,
                            time.minute
                        );

                        setState(() {
                          dateTime = newDateTime;
                        });
                      },
                          child: Text('${dateTime.hour}:${dateTime.minute}'))
                    ],
                  ),
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

  Future<DateTime?> pickDate() => showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(2023),
      lastDate: DateTime(2100));

  Future<TimeOfDay?> pickTime() => showTimePicker(
      context: context,
      initialTime: TimeOfDay(
          hour: dateTime.hour,
          minute: dateTime.minute)
  );

  Future _initLocationService() async {
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
