import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:todo/app/database/adm_connection.dart';
import 'package:todo/app/database/connection.dart';
import 'package:todo/app/modules/home/home_controller.dart';
import 'package:todo/app/modules/home/home_page.dart';
import 'package:todo/app/modules/new_task/new_task.dart';
import 'package:todo/app/modules/new_task/new_task_controller.dart';
import 'package:todo/app/repository/todos_repository.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AdmConnection admConnection = AdmConnection();

  @override
  void initState() {
    super.initState();
    Connection().instance;
    WidgetsBinding.instance.addObserver(admConnection);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addObserver(admConnection);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => TodoRepository(),
        )
      ],
      child: MaterialApp(
        title: 'Todo List',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: GoogleFonts.robotoTextTheme(),
        ),
        routes: {
          '/new': (_) => ChangeNotifierProvider(
              create: (context) {
                var day = ModalRoute.of(_).settings.arguments;
                return NewTaskController(
                    repository: context.read<TodoRepository>(), day: day);
              },
              child: NewTaskPage())
        },
        home: ChangeNotifierProvider(
          create: (context) {
            var repository = context.read<TodoRepository>();
            return HomeController(repository: repository);
          },
          child: HomePage(),
        ),
      ),
    );
  }
}
