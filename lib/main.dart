import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc/bloc/todos/todos_bloc.dart';
import 'package:todo_bloc/bloc/todos_filter/todos_filter_bloc.dart';
import 'package:todo_bloc/screens/add_todo.dart';

import 'models/todo_model.dart';
import 'screens/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => TodosBloc()
              ..add(const LoadTodos(
                todos: [
                  Todo(
                      id: "1",
                      title: 'Buy Milk',
                      description: 'Sample todo',
                      completed: false,
                      cancelled: false),
                  Todo(
                      id: "2",
                      title: 'Buy Eggs',
                      description: 'Second sample todo',
                      completed: false,
                      cancelled: false),
                ],
              ))),
        BlocProvider(
            create: (context) => TodosFilterBloc(
                  todosBloc: BlocProvider.of<TodosBloc>(context),
                )),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          'add_todo': (context) => const AddTodoScreen(),
        },
        home: const HomePage(),
      ),
    );
  }
}
