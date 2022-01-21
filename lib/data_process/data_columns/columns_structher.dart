import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/data_process/data_flow/crud_data.dart';

Widget defaultButton({
  @required Widget child,
  @required Function onPressed,
  Color backgroundColor,
  Color textColor,
  ShapeBorder shape,
}) =>
    MaterialButton(
      child: child,
      color: backgroundColor,
      textColor: textColor,
      shape: shape,
      onPressed: onPressed,
    );

Widget buildTask({
  @required BuildContext context,
  @required Map model,
}) =>
    Dismissible(
      key: Key(model['id'].toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        AppCrud.get(context).deleteData(id: model['id']);
      },
      background: Container(
        alignment: Alignment.centerRight,
        child: Icon(
          Icons.delete,
          color: Colors.black,
          size: 35,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Container(
                  height: 10,
                  width: 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${model['date']}'),
                    SizedBox(height: 10),
                    Text('${model['time']}'),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            flex: 2,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        child: Text(
                          '${model['title']}',
                          textAlign: TextAlign.start,
                          softWrap: true,
                        ),
                        width: 95,
                        margin: EdgeInsets.only(
                          left: 1.0,
                          top: 10,
                          bottom: 10,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                        onPressed: () {
                          AppCrud.get(context)
                              .updateData(status: 'done', id: model['id']);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

Widget taskBuilder({
  @required List<Map> tasks,
}) =>
    ConditionalBuilder(
      condition: tasks.length > 0,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: ListView.separated(
          itemBuilder: (context, index) {
            return buildTask(context: context, model: tasks[index]);
          },
          separatorBuilder: (context, index) => SizedBox(height: 40),
          itemCount: tasks.length,
        ),
      ),
      fallback: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'There are no task available',
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
