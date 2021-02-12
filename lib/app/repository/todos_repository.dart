import 'package:todo/app/database/connection.dart';
import 'package:todo/app/models/todo_model.dart';

class TodoRepository {
  Future<List<TodoModel>> findByPeriod(DateTime start, DateTime end) async {
    var startFilter = DateTime(start.year, start.month, start.day, 0, 0, 0);
    var endFilter = DateTime(end.year, end.month, end.day, 23, 59, 59);

    var connect = await Connection().instance;
    var result = await connect.rawQuery(
      "select * from todo where data_hora between ? and ? order by data_hora",
      [startFilter.toIso8601String(), endFilter.toIso8601String()],
    );
    return result.map((e) => TodoModel.fromMap(e)).toList();
  }

  Future<void> saveToList(DateTime dateTimeTask, String descricao) async {
    var connect = await Connection().instance;

    await connect.rawInsert(
      'insert into todo values(?,?,?,?)',
      [null, descricao, dateTimeTask.toIso8601String(), 0],
    );
  }

  Future<void> checkOrUncheckTodo(TodoModel todo) async {
    var connect = await Connection().instance;

    await connect.rawUpdate(
      'update todo set finalizado = ? where id = ?',
      [todo.finalizado ? 1 : 0, todo.id],
    );
  }

  Future<void> removeTodo(TodoModel model) async {
    var connect = await Connection().instance;
    await connect.rawDelete('delete from todo where id = ?', [model.id]);
  }
}
