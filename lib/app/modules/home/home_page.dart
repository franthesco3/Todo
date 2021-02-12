import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo/app/modules/home/home_controller.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (BuildContext context, HomeController controller, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              'Atividades',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            backgroundColor: Colors.white,
          ),
          bottomNavigationBar: FFNavigationBar(
            selectedIndex: controller.selectIndex,
            onSelectTab: (index) => controller.changeIndex(context, index),
            items: [
              FFNavigationBarItem(
                iconData: Icons.check,
                label: 'Finalizados',
              ),
              FFNavigationBarItem(
                iconData: Icons.view_week,
                label: 'Semanal',
              ),
              FFNavigationBarItem(
                iconData: Icons.calendar_today,
                label: 'Selecionar data',
              ),
            ],
            theme: FFNavigationBarTheme(
                itemWidth: 60,
                barHeight: 70,
                barBackgroundColor: Theme.of(context).primaryColor,
                unselectedItemIconColor: Colors.white,
                unselectedItemLabelColor: Colors.white,
                selectedItemBorderColor: Colors.white,
                selectedItemIconColor: Colors.white,
                selectedItemBackgroundColor: Theme.of(context).primaryColor,
                selectedItemLabelColor: Colors.black),
          ),
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              itemCount: controller.listTodos?.keys?.length ?? 0,
              itemBuilder: (_, index) {
                var dateFormat = DateFormat('dd/MM/yyyy');
                var listTodos = controller.listTodos;
                var dayKey = controller.listTodos.keys.elementAt(index);
                var day = dayKey;
                var todos = listTodos[dayKey];

                if (todos.isEmpty && controller.selectIndex == 0) {
                  return SizedBox.shrink();
                }

                var today = DateTime.now();
                if (dayKey == dateFormat.format(today)) {
                  day = "hoje".toUpperCase();
                } else if (dayKey ==
                    dateFormat.format(today.add(Duration(days: 1)))) {
                  day = "amamhã".toUpperCase();
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: Text(day,
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold))),
                          InkWell(
                            onTap: () async {
                              await Navigator.of(context)
                                  .pushNamed('/new', arguments: dayKey);
                              controller.update();
                            },
                            child: Icon(
                              Icons.add_circle,
                              color: Theme.of(context).primaryColor,
                              size: 30,
                            ),
                          )
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: todos.length,
                      itemBuilder: (context, index) {
                        var todo = todos[index];
                        return Dismissible(
                          key: Key(todo.id.toString()),
                          onDismissed: (value) {
                            controller.remover(todo);
                            todos.removeAt(index);
                          },
                          background: Container(
                            color: Colors.red,
                            child: Icon(Icons.cancel),
                          ),
                          child: ListTile(
                            leading: Checkbox(
                              value: todo.finalizado,
                              onChanged: (value) =>
                                  controller.changCheckBox(todo),
                            ),
                            title: Text(
                              todo.descricao,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  decoration: todo.finalizado
                                      ? TextDecoration.lineThrough
                                      : null),
                            ),
                            trailing: Text(
                              '${todo.dataHora.hour.toString().padLeft(2, '0')}:${todo.dataHora.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  decoration: todo.finalizado
                                      ? TextDecoration.lineThrough
                                      : null),
                            ),
                          ),
                        );
                      },
                    )
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
