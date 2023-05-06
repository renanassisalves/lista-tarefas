import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../classes.dart';
import 'cadastrar.dart';
import 'editar.dart';

class Listagem extends StatelessWidget {
  final List<Item>? listaTarefas;
  const Listagem({super.key, this.listaTarefas});

  @override
  Widget build(BuildContext context) {
    adicionarNovaTarefa() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Cadastrar(lista: listaTarefas))
      );
    }

    editarTarefa(itemAtual, index) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Editar(lista: listaTarefas, itemAtual: itemAtual, index: index,))
      );
    }

    if ((listaTarefas == null) || listaTarefas?.length == 0) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Listagem de tarefas"),
        ),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("Não há tarefas cadastradas")
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: adicionarNovaTarefa,
          tooltip: 'Adicionar nova tarefa',
          label: Text("Adicionar nova tarefa"),
          icon: Icon(Icons.add),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Listagem de tarefas"),
      ),
      body: ListView.builder(
        itemCount: listaTarefas?.length,
        itemBuilder: (BuildContext context, int index) {
            final tarefa = listaTarefas![index];
            return Card(
              child: ListTile(
                title: Text(tarefa.nome),
                subtitle: Text("${tarefa.datahora.day}/${tarefa.datahora.month}/${tarefa.datahora.year} - ${tarefa.datahora.hour}:${tarefa.datahora.minute}"),
                trailing: const Icon(Icons.arrow_forward_ios_outlined),
                onTap: () {
                  editarTarefa(tarefa, index);
                },
              ),
            );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: adicionarNovaTarefa,
        tooltip: 'Adicionar nova tarefa',
        label: Text("Adicionar nova tarefa"),
        icon: Icon(Icons.add),
        ),
    );
  }
}
