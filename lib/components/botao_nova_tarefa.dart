import 'package:flutter/material.dart';

import '../routes/rotas.dart';

class BotaoAdicionarTarefa extends StatelessWidget {
  const BotaoAdicionarTarefa({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    adicionarNovaTarefa() {
      Navigator.of(context).pushNamed(Rotas.CADASTRAR_TAREFA);
    }

    return FloatingActionButton.extended(
        onPressed: adicionarNovaTarefa,
        tooltip: 'Adicionar nova tarefa',
        label: const Text("Adicionar nova tarefa"),
    icon: const Icon(Icons.add)
    );
  }
}
