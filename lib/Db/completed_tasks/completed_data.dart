import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/data_process/data_columns/columns_structher.dart';
import 'package:todo_app/data_process/data_flow/crud_data.dart';
import 'package:todo_app/data_process/data_flow/state_library.dart';

class DoneTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCrud, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppCrud.get(context).doneTasks;

        return taskBuilder(tasks: tasks);
      },
    );
  }
}
