import 'package:flutter/material.dart';
import 'package:intern_todo/resources/models.dart';

class TaskPage extends StatefulWidget {
  final Task t;
  const TaskPage({
    Key? key,
    required Task this.t,
  }) : super(key: key);

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  bool _isloading = false;
  @override
  Widget build(BuildContext context) {
    if (_isloading)
      return Center(
        child: CircularProgressIndicator(),
      );

    final String name = widget.t.Name;
    final String description = widget.t.Description;
    final DateTime end = widget.t.endDateTime;
    final bool comp = widget.t.comp;

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: Icon(Icons.close),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          GestureDetector(
            child: Icon(Icons.edit),
            onTap: () {},
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width * 4 / 5,
          child: Column(
            children: [
              Flexible(
                child: Container(),
                flex: 1,
              ),
              Text(
                "${name}",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              Text("deadline: ${end}"),
              SizedBox(
                height: 20,
              ),
              Text("Description->", style: TextStyle(fontSize: 15)),
              Text("${description}"),
              SizedBox(
                height: 40,
              ),
              (comp == false)
                  ? Container(
                      child: Column(
                      children: [
                        Text("please compete the task asap"),
                        ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                _isloading = true;
                              });
                              widget.t.comp = true;
                              await widget.t.UploadTask();
                              setState(() {
                                _isloading = false;
                              });
                            },
                            child: Text("completed"))
                      ],
                    ))
                  : Text("Task has been Completed"),
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
