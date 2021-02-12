import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/app/modules/new_task/new_task_controller.dart';
import 'package:todo/app/shared/time.dart';

class NewTaskPage extends StatefulWidget {
  @override
  _NewTaskPageState createState() => _NewTaskPageState();
}

class _NewTaskPageState extends State<NewTaskPage> {
  var _scafoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((
      timeStamp,
    ) {
      Provider.of<NewTaskController>(context, listen: false).addListener(() {
        var controller = context.read<NewTaskController>();
        if (controller.error != null) {
          _scafoldKey.currentState
              .showSnackBar(SnackBar(content: Text(controller.error)));
        }

        if (controller.saved) {
          _scafoldKey.currentState.showSnackBar(
              SnackBar(content: Text('Todo cadastrado com sucesso')));
          Future.delayed(Duration(seconds: 1), () => Navigator.pop(context));
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    Provider.of<NewTaskController>(context, listen: false)
        .removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NewTaskController>(
      builder: (context, NewTaskController controller, child) {
        return Scaffold(
          key: _scafoldKey,
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            elevation: 0,
            backgroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            child: Form(
              key: controller.formkey,
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Nova Task',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Data',
                      style: TextStyle(
                          color: Colors.grey[800], fontWeight: FontWeight.bold),
                    ),
                    Text(
                      controller.dayFormat,
                      style: TextStyle(
                          color: Colors.grey[800], fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Nome da Task',
                      style: TextStyle(
                          color: Colors.grey[800], fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: controller.taskDescricao,
                      decoration: InputDecoration(border: OutlineInputBorder()),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Nome da task obrigatória';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Hora',
                      style: TextStyle(
                          color: Colors.grey[800], fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TimeComponent(
                        date: controller.daySelected,
                        onSelectedTime: (value) {
                          controller.daySelected = value;
                        }),
                    SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(0),
                              // boxShadow: [
                              //   BoxShadow(
                              //       blurRadius: 30,
                              //       color: Theme.of(context).primaryColor),
                              // ],
                              color: Theme.of(context).primaryColor),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () => controller.toSave(),
                              child: Container(
                                child: Center(
                                  child: Text(
                                    'Salvar',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          )),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
