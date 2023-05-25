import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';

import '../models/tarefa.dart';

class TarefaProvider with ChangeNotifier {
 final List<Tarefa> listaTarefas = [];
 DateTime dataHoraAtual = DateTime.now();

 //Informações de edição
 late Tarefa tarefaEditando;
 late int indexEditando;

 Future<LocationData> retornarLocalizacao() async {
  var location = Location();

  if (!await location.serviceEnabled()) {
   if (!await location.requestService()) {
    return location.getLocation();
   }
  }

  var permission = await location.hasPermission();
  if (permission == PermissionStatus.denied) {
   permission = await location.requestPermission();
   if (permission != PermissionStatus.granted) {
    return location.getLocation();
   }
  }

  return await location.getLocation();
 }

 void atualizarDataHora(novaDataHora) {
  dataHoraAtual = novaDataHora;
  try {
   tarefaEditando.datahora = novaDataHora;
  } catch(e) {}
  notifyListeners();
 }

}