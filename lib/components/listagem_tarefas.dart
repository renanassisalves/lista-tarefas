import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lista_tarefas/components/listagem_tarefas_item.dart';
import 'package:provider/provider.dart';
import 'package:lista_tarefas/providers/tarefa_provider.dart';

class ListagemTarefas extends StatelessWidget {
  const ListagemTarefas({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _tarefas = Provider.of<TarefaProvider>(context);

    // List<Widget> _gerarListaProdutos() {
    //   return _tarefas.listaTarefas
    //       .map((tarefa) => ListagemTarefasItem(tarefa))
    //       .toList();
    // }

    List<Widget> _gerarListaProdutos() {
      return _tarefas.listaTarefas.asMap().entries.map((valor) {
        return ListagemTarefasItem(valor.value, valor.key);
      }).toList();
    }

    return _tarefas.listaTarefas.isNotEmpty
        ? ListView(
            children: _gerarListaProdutos(),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Center(
                child: Text("Não há tarefas cadastradas"),
              )
            ],
          );
  }
}
