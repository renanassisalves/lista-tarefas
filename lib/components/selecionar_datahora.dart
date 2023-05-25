import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/tarefa_provider.dart';

Widget SelecionarDataHora(context) {
  final tarefas = Provider.of<TarefaProvider>(context);
  DateTime dataHora = tarefas.dataHoraAtual;

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      ElevatedButton(
        onPressed: () async {
          _selecionarData(context, dataHora, tarefas);
        },
        child: Text('${tarefas.dataHoraAtual.day.toString().padLeft(2, "0")}/'
            '${tarefas.dataHoraAtual.month.toString().padLeft(2, "0")}/'
            '${tarefas.dataHoraAtual.year.toString().padLeft(2, "0")}'),
      ),
      const SizedBox(width: 10),
      ElevatedButton(
          onPressed: () async {
            _selecionarHorario(context, dataHora, tarefas);
          },
          child: Text('${tarefas.dataHoraAtual.hour.toString().padLeft(2, "0")}:'
              '${tarefas.dataHoraAtual.minute.toString().padLeft(2, "0")}'))
    ],
  );
}

_selecionarData(context, dataHora, tarefas) async {
  final data = await pegarData(context, dataHora);
  if (data == null) return;

  final novaDataHora = DateTime(
      data.year,
      data.month,
      data.day,
      dataHora.hour,
      dataHora.minute
  );

  tarefas.atualizarDataHora(novaDataHora);
}

_selecionarHorario(context, dataHora, tarefas) async {
  final horario = await pegarHorario(context, dataHora);
  if (horario == null) return;

  final novaDataHora = DateTime(
      dataHora.year,
      dataHora.month,
      dataHora.day,
      horario.hour,
      horario.minute
  );

  tarefas.atualizarDataHora(novaDataHora);
}

Future<DateTime?> pegarData(context, dateTime) => showDatePicker(
    context: context,
    initialDate: dateTime,
    firstDate: DateTime(2023),
    lastDate: DateTime(2100));

Future<TimeOfDay?> pegarHorario(context, dateTime) => showTimePicker(
    context: context,
    initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute));
