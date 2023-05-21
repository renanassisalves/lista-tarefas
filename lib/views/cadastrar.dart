import 'package:flutter/material.dart';
import 'package:lista_tarefas/utils/utils.dart';
import 'package:location/location.dart';
import '../models/item.dart';
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
  Widget build(BuildContext context) {
    if (widget.lista != null) {
      listaItens = widget.lista!;
    }

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
        dateTime = novaDataHora;
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
        dateTime = novaDataHora;
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
                  _selecionarDataHora(),
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