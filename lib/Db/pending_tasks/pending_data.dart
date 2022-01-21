import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/data_process/data_columns/columns_structher.dart';
import 'package:todo_app/data_process/data_flow/crud_data.dart';
import 'package:todo_app/data_process/data_flow/state_library.dart';

class NewTasksScreen extends StatelessWidget {
  var _formKey = GlobalKey<FormState>();
  TextEditingController _textController = TextEditingController();
  String selectedDate = 'Select Date';
  String selectedTime = 'Select Time';

  Widget build(BuildContext context) {
    return BlocConsumer<AppCrud, AppStates>(
      listener: (context, state) {
        if (state is AppInsertIntoDataBseState) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        AppCrud cubit = AppCrud.get(context);

        return Scaffold(
          backgroundColor: Colors.grey[300],
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => Dialog(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Add Task Area',
                            style: TextStyle(fontSize: 25),
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: _textController,
                            keyboardType: TextInputType.text,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Values can\'t be empty';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Enter task hear',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          defaultButton(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.date_range,
                                  color: Theme.of(context).primaryColor,
                                ),
                                const SizedBox(width: 10),
                                Text(selectedDate),
                              ],
                            ),
                            onPressed: () => showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate:
                                  DateTime.now().add(Duration(days: -365)),
                              lastDate: DateTime.now().add(Duration(days: 365)),
                            ).then((value) {
                              selectedDate = DateFormat()
                                  .add_yMMMd()
                                  .format(value)
                                  .toString();
                            }),
                          ),
                          const SizedBox(height: 15),
                          defaultButton(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.access_time_rounded,
                                  color: Theme.of(context).primaryColor,
                                ),
                                const SizedBox(width: 10),
                                Text(selectedTime),
                              ],
                            ),
                            onPressed: () => showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            ).then((value) {
                              selectedTime = value.format(context).toString();
                            }),
                          ),
                          const SizedBox(height: 25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancel'),
                              ),
                              defaultButton(
                                child: Text('Add'),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: Theme.of(context).primaryColor,
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    cubit.insertIntoDataBase(
                                      title: _textController.text,
                                      time: selectedTime,
                                      date: selectedDate,
                                    );
                                    _textController.text = '';
                                    selectedTime = 'Pick Date';
                                    selectedDate = 'Pick Time';
                                  }
                                },
                                textColor: Colors.white,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            child: Icon(Icons.add),
          ),
          body: taskBuilder(tasks: cubit.newTasks),
        );
      },
    );
  }
}
