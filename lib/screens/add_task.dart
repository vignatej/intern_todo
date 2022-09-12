import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intern_todo/resources/widgets.dart';

import '../resources/models.dart' as model;

class addTaskPage extends StatefulWidget {
  const addTaskPage({Key? key}) : super(key: key);

  @override
  State<addTaskPage> createState() => _addTaskPageState();
}

class _addTaskPageState extends State<addTaskPage> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _description = TextEditingController();
  DateTime dateTime = DateTime.now();

  Future<DateTime?> pickDate(context) => showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(2022),
      lastDate: DateTime(2030));
  Future<TimeOfDay?> pickTime(context) => showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute));
  bool _sending = false;
  Future<String> Submit(context) async {
    setState(() {
      _sending = true;
    });
    model.Task ta = model.Task(
        Name: _name.text,
        Description: _description.text,
        endDateTime: dateTime,
        comp: false);
    String u = await ta.UploadTask();

    if (u != "sucess") {
      showSnackBar(" no0000000 sucess", context);
    } else {
      showSnackBar("sucess", context);
    }
    setState(() {
      _sending = false;
    });
    return u;
  }

  @override
  Widget build(BuildContext context) {
    if (_sending == true) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final hours = dateTime.hour.toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.close,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: () async {
              String result = await Submit(context);
              if (result == "sucess") {
                Navigator.pop(context);
              }
            },
            child: Icon(
              Icons.done,
              color: Colors.black,
            ),
          ),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 4 / 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Container(),
                flex: 1,
              ),
              Text("enter name of task"),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 30),
                child: TextFieldInput(
                    textEditingController: _name,
                    hintText: "Name please",
                    textInputType: TextInputType.name),
              ),
              Text("enter description"),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 30),
                child: TextFieldInput(
                  textEditingController: _description,
                  hintText: "Description here",
                  textInputType: TextInputType.text,
                  maxLines: 6,
                ),
              ),
              Text("enter date and time"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        final date = await pickDate(context);
                        if (date == null) {
                          return;
                        }
                        final newDateTime = DateTime(date.year, date.month,
                            date.day, dateTime.hour, dateTime.minute);
                        setState(() {
                          dateTime = newDateTime;
                        });
                      },
                      child: Text(
                          "${dateTime.day}/${dateTime.month}/${dateTime.year}")),
                  ElevatedButton(
                      onPressed: () async {
                        final time = await pickTime(context);
                        if (time == null) {
                          return;
                        }
                        final newDateTime = DateTime(
                            dateTime.year,
                            dateTime.month,
                            dateTime.day,
                            time.hour,
                            time.minute);
                        setState(() {
                          dateTime = newDateTime;
                        });
                      },
                      child: Text("${hours}:${minutes}")),
                ],
              ),
              Flexible(
                child: Container(),
                flex: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
