import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/app/models/todo_model.dart';
import 'package:todo/app/repository/todos_repository.dart';
import 'package:collection/collection.dart';

class HomeController extends ChangeNotifier {
  final TodoRepository repository;
  int selectIndex = 1;
  DateTime daySelected;
  DateTime startFilter;
  DateTime endFilter;
  bool loading = false;
  String error;
  Map<String, List<TodoModel>> listTodos;
  var dateFormat = DateFormat('dd/MM/yyyy');
  HomeController({@required this.repository}) {
    findAllForWeek();
  }

  Future<void> findAllForWeek() async {
    daySelected = DateTime.now();

    startFilter = DateTime.now();
    if (startFilter.weekday != DateTime.monday) {
      startFilter =
          startFilter.subtract(Duration(days: startFilter.weekday - 1));
    }

    endFilter = startFilter.add(Duration(days: 6));
    var todos = await repository.findByPeriod(startFilter, endFilter);
    if (todos.isEmpty) {
      listTodos = {dateFormat.format(DateTime.now()): []};
    } else {
      listTodos =
          groupBy(todos, (TodoModel todo) => dateFormat.format(todo.dataHora));
    }
    this.notifyListeners();
  }

  Future<void> changeIndex(BuildContext context, int index) async {
    selectIndex = index;
    switch (index) {
      case 0:
        todoFinalizados();
        break;
      case 1:
        findAllForWeek();
        break;
      case 2:
        var day = await showDatePicker(
          context: context,
          initialDate: daySelected,
          firstDate: DateTime.now().subtract(Duration(days: 360 * 3)),
          lastDate: DateTime.now().add(Duration(days: 360 * 10)),
        );
        if (day != null) {
          daySelected = day;
          findTodosBySelectedDay();
        }
    }
    notifyListeners();
  }

  void changCheckBox(TodoModel model) {
    model.finalizado = !model.finalizado;
    notifyListeners();
    repository.checkOrUncheckTodo(model);
  }

  void todoFinalizados() {
    listTodos = listTodos.map((key, value) {
      var todoFinalizados =
          value.where((element) => element.finalizado).toList();
      return MapEntry(key, todoFinalizados);
    });
    notifyListeners();
  }

  Future<void> findTodosBySelectedDay() async {
    var todos = await repository.findByPeriod(daySelected, daySelected);
    if (todos.isEmpty) {
      listTodos = {dateFormat.format(daySelected): []};
    } else {
      listTodos =
          groupBy(todos, (TodoModel todo) => dateFormat.format(todo.dataHora));
    }
    notifyListeners();
  }

  void update() {
    if (selectIndex == 1) {
      this.findAllForWeek();
    } else if (selectIndex == 2) {
      this.findTodosBySelectedDay();
    }
  }

  Future<void> remover(TodoModel model) async {
    try {
      await repository.removeTodo(model);
    } catch (e) {
      this.error = 'Error ao deletar todo';
    }
    notifyListeners();
  }
}
