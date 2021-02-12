import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:todo/app/repository/todos_repository.dart';

class NewTaskController extends ChangeNotifier {
  final TodoRepository repository;
  DateTime daySelected;
  TextEditingController taskDescricao = TextEditingController();
  var formkey = GlobalKey<FormState>();
  final dateformat = DateFormat('dd/MM/yyyy');
  String get dayFormat => dateformat.format(daySelected);
  bool loading = false;
  bool saved = false;
  String error;

  NewTaskController({this.repository, String day}) {
    daySelected = dateformat.parse(day);
  }

  Future<void> toSave() async {
    try {
      if (formkey.currentState.validate()) {
        loading = true;
        saved = false;
        await repository.saveToList(daySelected, taskDescricao.text);
        saved = true;
        loading = false;
      }
    } on Exception catch (e) {
      print(e);
      error = 'Erro ao salvar todo';
    }
    notifyListeners();
  }
}
