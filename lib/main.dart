import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import "./models/todo.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo app',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(title: 'Todo List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<ToDo> _todos = [];
  int _currId = 0;
  late TextEditingController _titleController;
  late TextEditingController _detailsController;
  int _selectedIdx = 0;
  DateTime _selectedDate = DateTime.now().add(const Duration(hours: 2));

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _detailsController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  void showEditModal() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setBottomSheetState) {
            return Container(
                padding: EdgeInsets.fromLTRB(
                    8, 8, 8, MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      autofocus: true,
                      controller: _titleController,
                      decoration: const InputDecoration(hintText: "Title"),
                    ),
                    TextField(
                      autofocus: true,
                      keyboardType: TextInputType.multiline,
                      minLines: 5,
                      maxLines: 8,
                      controller: _detailsController,
                      decoration: const InputDecoration(
                        hintText: "Details",
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              DateFormat.yMMMMd('en_US').format(_selectedDate)),
                          ElevatedButton(
                              onPressed: () async {
                                showDatePicker(
                                        context: context,
                                        initialDate: _selectedDate,
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime(2100))
                                    .then((value) {
                                  if (value != null) {
                                    setBottomSheetState(() {
                                      print("value: $value");
                                      _selectedDate = DateTime(
                                          value.year,
                                          value.month,
                                          value.day,
                                          _selectedDate.hour,
                                          _selectedDate.minute);
                                    });
                                  }
                                });
                              },
                              child: const Text("Choose"))
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(DateFormat.jm().format(_selectedDate)),
                          ElevatedButton(
                              onPressed: () {
                                showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now())
                                    .then((value) {
                                  if (value != null) {
                                    print(value);
                                    setBottomSheetState(() {
                                      _selectedDate = DateTime(
                                        _selectedDate.year,
                                        _selectedDate.month,
                                        _selectedDate.day,
                                        value.hour,
                                        value.minute,
                                      );
                                    });
                                  }
                                });
                              },
                              child: const Text("Choose"))
                        ],
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          ToDo newTodo = ToDo(_currId++, _titleController.text,
                              _detailsController.text, false);
                          setState(() {
                            _todos.add(newTodo);
                            _titleController.clear();
                            _detailsController.clear();
                          });
                          Navigator.pop(context);
                        },
                        child: const Text("Save"))
                  ],
                ));
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIdx == 0 ? "My Todos" : "Calendar"),
        centerTitle: true,
      ),
      body: Container(
        color: const Color.fromARGB(255, 22, 22, 22),
        padding: const EdgeInsets.all(8),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Column(
              children: _todos
                  .map((todo) => GestureDetector(
                      onTap: () {},
                      child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 46, 46, 46),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          margin: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 0),
                          child: Row(
                            children: [
                              Checkbox(
                                  value: todo.done,
                                  onChanged: (value) {
                                    setState(() {
                                      for (int i = 0; i < _todos.length; i++) {
                                        if (_todos[i].id == todo.id) {
                                          _todos[i].done = value!;
                                        }
                                      }
                                    });
                                  }),
                              Expanded(
                                  child: Text(
                                todo.title,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.white),
                              )),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      for (int i = 0; i < _todos.length; i++) {
                                        if (_todos[i].id == todo.id) {
                                          _todos.removeAt(i);
                                        }
                                      }
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ))
                            ],
                          ))))
                  .toList(),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            showEditModal();
          }),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 46, 46, 46),
        currentIndex: _selectedIdx,
        onTap: (value) => setState(() {
          _selectedIdx = value;
        }),
        selectedItemColor: Theme.of(context).textSelectionTheme.selectionColor,
        unselectedItemColor: const Color.fromARGB(255, 172, 172, 172),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month), label: "Calandar"),
        ],
      ),
    );
  }
}
