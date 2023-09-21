import 'package:flutter/material.dart';
import 'package:flutter_study_todo/models/todo.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final List<Todo> _todos = [];
  final List<TextEditingController> _controllers = [];
  final List<FocusNode> _focusNodes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Flutter Todo")),
      body: ListView.builder(
        itemCount: _todos.length,
        itemBuilder: (BuildContext context, int i) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      setState(() {
                        _todos[i].isDone = !_todos[i].isDone;
                      });
                    },
                    icon: _todos[i].isDone ? const Icon(Icons.check_circle) : const Icon(Icons.circle_outlined),
                  ),
                  if (_todos[i].isEditing) ...[
                    Expanded(
                      child: TextField(
                        controller: _controllers[i],
                        focusNode: _focusNodes[i],
                        decoration: const InputDecoration(
                          hintText: "할 일을 입력하세요",
                          hintStyle: TextStyle(fontSize: 18.0),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ] else ...[
                    Text(_todos[i].title,
                        style: TextStyle(
                          fontSize: 18.0,
                          decoration: _todos[i].isDone ? TextDecoration.lineThrough : TextDecoration.none,
                        )),
                    const Spacer(),
                  ],
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _todos[i].isEditing = !_todos[i].isEditing;

                        if (_todos[i].isEditing) {
                          _controllers[i].text = _todos[i].title;
                          _focusNodes[i].requestFocus();
                        } else {
                          _todos[i].title = _controllers[i].text;
                        }
                      });
                    },
                    icon: _todos[i].isEditing ? const Icon(Icons.check) : const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _todos.removeAt(i);
                        _controllers.removeAt(i);
                      });
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _todos.add(Todo(title: ""));
            _controllers.add(TextEditingController());
            _focusNodes.add(FocusNode());
            _focusNodes[_focusNodes.length - 1].requestFocus();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
