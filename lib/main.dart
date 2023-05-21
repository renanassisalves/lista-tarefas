import 'package:flutter/material.dart';
import 'package:lista_tarefas/views/cadastrar.dart';
import 'package:lista_tarefas/views/editar.dart';
import 'views/listagem.dart';
import 'routes/rotas.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplicativo de cadastro de tarefas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Listagem(),
      debugShowCheckedModeBanner: false,
      // routes: {
      //   Rotas.LISTAGEM_TAREFAS: (context) => const Listagem(),
      //   Rotas.CADASTRAR_TAREFA: (context) => Cadastrar(),
      //   Rotas.EDITAR_TAREFA: (context) => Editar();
      // }

    );
  }
}