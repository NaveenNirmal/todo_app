import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/Db/completed_tasks/completed_data.dart';
import 'package:todo_app/Db/pending_tasks/pending_data.dart';
import 'package:todo_app/data_process/data_flow/state_library.dart';

class AppCrud extends Cubit<AppStates> {
  AppCrud() : super(AppInitialState());

  static AppCrud get(context) => BlocProvider.of(context);

  Database database;
  int selectedIndex = 1;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];

  List<Widget> pages = [
    DoneTasksScreen(),
    NewTasksScreen(),
  ];

  List<String> appBarTitle = [
    'Completed Tasks',
    'Pending Tasks',
  ];

  void changeIndex(int index) {
    selectedIndex = index;
    emit(AppBottomNavBarChangeIndexState());
  }

  void createDataBase() {
    openDatabase(
      'todolist.db',
      version: 1,
      onCreate: (db, version) {
        print('database created');
        db
            .execute(
                'CREATE TABLE TASKS (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time Text, status TEXT)')
            .then((value) => print('table Created'));
      },
      onOpen: (db) {
        getDataFromDataBase(db);
        print('database opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDataBseState());
    });
  }

  Future insertIntoDataBase({
    @required String title,
    @required String time,
    @required String date,
  }) async {
    await database.transaction(
      (txn) => txn
          .rawInsert(
        'INSERT INTO TASKS(title, date, time, status) VALUES("$title", "$date", "$time", "new")',
      )
          .then((value) {
        print('$value Raw Inserted');
        emit(AppInsertIntoDataBseState());

        getDataFromDataBase(database);
      }),
    );
  }

  void getDataFromDataBase(database) {
    newTasks = [];
    doneTasks = [];

    emit(AppGetDataLoadingState());

    database.rawQuery("SELECT * FROM TASKS").then((value) {
      value.forEach((element) {
        if (element['status'] == 'new')
          newTasks.add(element);
        else if (element['status'] == 'done') doneTasks.add(element);
      });

      emit(AppGetDataFromDataBseState());
    });
  }

  void updateData({
    @required String status,
    @required int id,
  }) {
    database.rawUpdate('UPDATE TASKS SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      print('$value updated');
      getDataFromDataBase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteData({
    @required int id,
  }) {
    database.rawDelete('DELETE FROM TASKS WHERE id = ?', [id]).then((value) {
      getDataFromDataBase(database);

      emit(AppGetDataFromDataBseState());

      emit(AppDeleteDatabaseState());
    });
  }
}
