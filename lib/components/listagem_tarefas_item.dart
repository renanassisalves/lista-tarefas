import 'package:flutter/material.dart';
import 'package:lista_tarefas/models/tarefa.dart';
import 'package:lista_tarefas/routes/rotas.dart';
import 'package:provider/provider.dart';

import '../providers/tarefa_provider.dart';

class ListagemTarefasItem extends StatelessWidget {
  final Tarefa tarefa;
  final int index;
  const ListagemTarefasItem(this.tarefa, this.index, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _tarefas = Provider.of<TarefaProvider>(context);

    editarTarefa() {
      _tarefas.tarefaEditando = tarefa;
      _tarefas.indexEditando = index;
      Navigator.of(context).pushNamed(Rotas.EDITAR_TAREFA);
    }

    return Card(
      child: ListTile(
        title: Text(tarefa.nome),
        subtitle: Text("${tarefa.datahora.day.toString().padLeft(2, "0")}/"
            "${tarefa.datahora.month.toString().padLeft(2, "0")}/"
            "${tarefa.datahora.year}"
            " - ${tarefa.datahora.hour.toString().padLeft(2, "0")}:${tarefa.datahora.minute.toString().padLeft(2, "0")}"
            "\nCoordenadas: lat ${tarefa.latitude.toStringAsFixed(4)} lon ${tarefa.longitude.toStringAsFixed(4)}"),
        trailing: const Icon(Icons.arrow_forward_ios_outlined),
        onTap: () {
          editarTarefa();
        },
      ),
    );
  }
}
