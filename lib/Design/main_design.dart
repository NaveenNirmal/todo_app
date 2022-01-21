import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/data_process/data_flow/crud_data.dart';
import 'package:todo_app/data_process/data_flow/state_library.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCrud()..createDataBase(),
      child: BlocConsumer<AppCrud, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AppCrud crud = AppCrud.get(context);

          return Scaffold(
            backgroundColor: Colors.grey[300],
            appBar: AppBar(
              title: Text(crud.appBarTitle[crud.selectedIndex]),
            ),
            bottomNavigationBar: CurvedNavigationBar(
              items: [
                Icon(
                  Icons.check_circle_outline,
                  size: 40,
                  color: Colors.black,
                ),
                Icon(
                  Icons.menu,
                  size: 40,
                  color: Colors.black,
                ),
              ],
              index: crud.selectedIndex,
              onTap: (value) => crud.changeIndex(value),
              color: Theme.of(context).primaryColor,
              backgroundColor: Colors.grey[800],
            ),
            body: crud.pages[crud.selectedIndex],
          );
        },
      ),
    );
  }
}
