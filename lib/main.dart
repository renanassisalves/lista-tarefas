import 'package:flutter/material.dart';
import 'views/listagem.dart';

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
    );
  }
}