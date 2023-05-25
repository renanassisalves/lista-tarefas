import 'package:flutter/material.dart';
import 'package:lista_tarefas/providers/tarefa_provider.dart';
import 'package:lista_tarefas/views/cadastrar_view.dart';
import 'package:lista_tarefas/views/editar_view.dart';
import 'package:provider/provider.dart';
import 'views/listagem_view.dart';
import 'routes/rotas.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TarefaProvider(),
      child: MaterialApp(
        title: 'Aplicativo de cadastro de tarefas',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: const Listagem(),
        debugShowCheckedModeBanner: false,
        routes: {
          Rotas.LISTAGEM_TAREFAS: (context) => const Listagem(),
          Rotas.CADASTRAR_TAREFA: (context) => const Cadastrar(),
          Rotas.EDITAR_TAREFA: (context) => Editar(),
        }

      ),
    );
  }
}