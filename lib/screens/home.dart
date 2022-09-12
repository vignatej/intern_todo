import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intern_todo/resources/models.dart';
import 'package:intern_todo/resources/playingWithTasks.dart';
import 'package:intern_todo/screens/add_task.dart';
import 'package:intern_todo/screens/profile.dart';
import 'package:intern_todo/screens/task_page.dart';

class Hello extends StatefulWidget {
  const Hello({Key? key}) : super(key: key);

  @override
  State<Hello> createState() => _HelloState();
}

class _HelloState extends State<Hello> {
  List<Task> list_of_tasks = [];
  bool isloading = false;

  Future<String> Refresh() async {
    setState(() {
      isloading = true;
    });
    list_of_tasks = await get_tasks();
    print("list of tasks are:");
    print(list_of_tasks.toString());
    list_of_tasks.sort((a, b) => a.endDateTime.compareTo(b.endDateTime));
    setState(() {
      isloading = false;
    });
    return "sucess in refresh";
  }

  String _profileImg = "";

  Future<String?> a(_auth, _firestore, CurrentUser) async {
    try {
      await _firestore
          .collection('Users')
          .doc(CurrentUser.uid)
          .get()
          .then((value) {
        setState(() {
          _profileImg = value["photoUrl"];
        });
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Refresh();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    User CurrentUser = _auth.currentUser!;
    a(_auth, _firestore, CurrentUser);
  }

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isloading == true) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    List<Widget> expired = [];
    List<Widget> not_yet = [];
    List<Widget> comp_let = [];
    for (var i in list_of_tasks) {
      if ((i.comp == false) && (i.endDateTime.isBefore(DateTime.now()))) {
        not_yet.add(ListTile(
          onTap: () async {
            String? a = await Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => TaskPage(t: i)));
            Refresh();
          },
          title: Text("${i.Name}"),
          subtitle: Container(
            child: Text("${i.Description}"),
            height: 20,
          ),
        ));
      } else if (i.comp == false) {
        expired.add(ListTile(
          onTap: () async {
            String? b = await Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => TaskPage(t: i)));
            Refresh();
          },
          title: Text("${i.Name}"),
          subtitle: Container(
            child: Text("${i.Description}"),
            height: 20,
          ),
        ));
      } else {
        comp_let.add(ListTile(
          onTap: () async {
            String? c = await Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => TaskPage(t: i)));
            Refresh();
          },
          title: Text("${i.Name}"),
          subtitle: Container(
            child: Text("${i.Description}"),
            height: 20,
          ),
        ));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Tasks"),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () async {
              String? d = await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => profile()));
              Refresh();
            },
            child: ClipOval(
              child: Image(
                image: NetworkImage(_profileImg),
              ),
            ),
          ),
        ),
        actions: [
          GestureDetector(
            child: Icon(Icons.refresh),
            onTap: () {
              Refresh();
            },
          ),
          SizedBox(
            width: 15,
          ),
          GestureDetector(
            child: Icon(Icons.add),
            onTap: () async {
              String? d = await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => addTaskPage()));
              Refresh();
            },
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: Column(
        children: [expired, not_yet, comp_let].elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.pending),
            label: 'todo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explicit),
            label: 'expired',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.done),
            label: 'completed',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
