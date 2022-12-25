import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import "../models/todo.dart";

class TodoPage extends StatelessWidget {
  const TodoPage({super.key, required this.todo});
  final ToDo todo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(todo.title)),
        body: Container(
          padding: const EdgeInsets.all(8),
          color: const Color.fromARGB(255, 22, 22, 22),
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 8, bottom: 16),
                child: Text(
                  DateFormat('EEEE, MMMM d, y, h:mm a', 'en_US')
                      .format(todo.deadline),
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              Text(
                todo.details,
                style: const TextStyle(color: Colors.white, fontSize: 25),
              )
            ],
          ),
        ));
  }
}
