import 'package:flutter/material.dart';
import 'package:location/location.dart';
import '../classes.dart';
import 'listagem.dart';

class Cadastrar extends StatefulWidget {
  List<Item>? lista;
  Cadastrar({super.key, this.lista});
  @override
  State<Cadastrar> createState() => _CadastrarState();
}

class _CadastrarState extends State<Cadastrar> {
  DateTime dateTime = DateTime.now();
  double latitude = 0.0;
  double longitude = 0.0;
  List<Item> listaItens = [];
  final controllerTarefa = TextEditingController();

  @override
  void dispose() {
    controllerTarefa.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.lista != null)
    {
      listaItens = widget.lista!;
    }

    _initLocationService();
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text("Crie uma nova tarefa"),
          ),
          body:
          Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text("Digite a tarefa",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'insira a tarefa aqui...',
                    ),
                    controller: controllerTarefa,
                  ),
                  const SizedBox(height: 32),
                  const Text("Selecione a data e a hora",
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
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    ElevatedButton(onPressed: () {
                      Navigator.pop(context);
                    }, child: Text("Cancelar")),
                    const SizedBox(width: 16),
                    ElevatedButton(onPressed: () {
                      if (controllerTarefa.text == "") {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text("Digite uma tarefa antes de cadastrá-la."),
                              actions: [TextButton(onPressed: () {
                                Navigator.pop(context);
                              }, child: Text("Fechar"))],
                            );
                          },
                        );
                      } else {
                        listaItens.add(Item(
                            controllerTarefa.text,
                            dateTime,
                            latitude,
                            longitude
                        ));

                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Listagem(listaTarefas: listaItens,)),
                                (Route<dynamic> route) => false);
                      }
                    }, child: const Text("Cadastrar tarefa")),
                  ],)
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