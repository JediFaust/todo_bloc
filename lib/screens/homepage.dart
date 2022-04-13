import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc/models/todos_filter_model.dart';

import '../bloc/todos/todos_bloc.dart';
import '../bloc/todos_filter/todos_filter_bloc.dart';
import '/models/todo_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home Page'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () => Navigator.of(context).pushNamed('add_todo'),
                icon: const Icon(Icons.add))
          ],
          bottom: TabBar(
            onTap: (tabIndex) {
              switch (tabIndex) {
                case 0:
                  BlocProvider.of<TodosFilterBloc>(context)
                      .add(const UpdateTodos(todosFilter: TodosFilter.pending));
                  break;
                case 1:
                  BlocProvider.of<TodosFilterBloc>(context).add(
                      const UpdateTodos(todosFilter: TodosFilter.completed));
                  break;
              }
            },
            tabs: const [
              Tab(icon: Icon(Icons.pending)),
              Tab(icon: Icon(Icons.add_task)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _todos('Pending To Dos'),
            _todos('Completed To Dos'),
          ],
        ),
      ),
    );
  }

  BlocConsumer<TodosFilterBloc, TodosFilterState> _todos(String title) {
    return BlocConsumer<TodosFilterBloc, TodosFilterState>(
      listener: (context, state) {
        if (state is TodosFilterLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'There is ${state.filteredTodos.length} To Dos in your ${state.todosFilter.toString().split('.').last} list'),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is TodosFilterLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is TodosFilterLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.filteredTodos.length,
                  itemBuilder: (context, index) =>
                      _todoCard(context, state.filteredTodos[index])),
            ],
          );
        } else {
          return const Center(
            child: Text('Something went wrong!'),
          );
        }
      },
    );
  }

  Card _todoCard(BuildContext context, Todo todo) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("#${todo.id}: ${todo.title}"),
            Row(
              children: [
                IconButton(
                  icon: Icon(todo.completed
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked),
                  onPressed: () {
                    context.read<TodosBloc>().add(UpdateTodo(
                        todo: todo.copyWith(completed: !todo.completed)));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.cancel),
                  onPressed: () {
                    context.read<TodosBloc>().add(DeleteTodo(todo: todo));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
