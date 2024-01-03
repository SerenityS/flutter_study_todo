import 'package:flutter/material.dart';
import 'package:flutter_study_todo/models/todo.dart';
import 'package:flutter_study_todo/utils/todo_util.dart';

// StatefulWidget: 상태(화면)를 변화시킬 수 있는 위젯
class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  Widget build(BuildContext context) {
    // Scaffold: 마테리얼 디자인(구글의 디자인 가이드 라인)에 맞추어
    // 앱 화면을 구성하기 위한 기본 뼈대를 구성해 주는 위젯
    return Scaffold(
      // AppBar: Scaffold의 머리, 현재 페이지의 제목을 표시하거나 뒤로가기, 설정 버튼 등을 보여 줌
      appBar: AppBar(title: const Text("Flutter Todo")),
      // body: Scaffold의 몸통, 현재 페이지의 본문, html의 <body></body>
      // FutureBuilder: 비동기로 데이터를 받아올 때 사용하는 위젯
      body: FutureBuilder(
          // 비동기로 데이터를 받아올 함수 정의
          future: TodoUtil().getTodos(),
          // snapshot: 비동기로 받아온 데이터를 저장하는 변수
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            // snapshot.connectionState: 데이터를 받아오는 상태를 저장하는 변수
            // ConnectionState.waiting: 데이터를 받아오는 중
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.data.isEmpty) {
              return const Center(child: Text("Todo가 비어있습니다.\nTodo를 추가해주세요!"));
            }

            return ListView.builder(
              // ListView.builder: 원하는 위젯을 여러개 그릴 때 사용
              // 아래의 경우 for(int i = 0; i < todos.length; i++) Card(...) 와 유사함!
              itemCount: snapshot.data.length, // 위젯을 그릴 횟수
              itemBuilder: (BuildContext context, int i) {
                // ListView를 통해 그리고 싶은 위젯 정의
                // Card: 둥근 모서리와 그림자 효과가 포함된 박스를 제공하는 위젯 / 대충 이쁜 외관을 만들어 줌..
                return Card(
                  // margin: CSS의 margin과 동일, 위젯 바깥쪽 여백
                  margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0), // EdgeInsets: margin / padding을 넣기 위한 함수
                  // padding: CSS의 padding과 동일, 위젯 안쪽 여백
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    // Row: 가로 방향으로 위젯들을 배치하기 위한 위젯 <-> Column: 세로 방향으로 배치
                    child: Row(
                      // Row는 여러 위젯(child)을 담을 수 있으므로 child의 복수형인 children 속성 사용
                      children: [
                        // TODO 완료 표시 버튼
                        // IconButton: Icon을 눌렀을 때 특정 함수(onPressed)가 동작하는 버튼을 만드는 위젯
                        IconButton(
                          // onPressed: 버튼을 눌렀을 때(press) 동작 할 콜백함수 정의
                          onPressed: () async {
                            // setState: (StatfulWidget에서) 값이 변했으니 화면을 다시 그리라고 명령!
                            Todo todo = snapshot.data[i];
                            todo.isDone = !todo.isDone;

                            // TODO 완료 여부를 업데이트
                            await TodoUtil().updateTodos(todo);
                            setState(() {});
                          },
                          // 3항 연산자 이용,
                          // 조건문 ? 참일때 실행 : 거짓일 때 실행
                          // 아래의 경우 특정 TODO 완료 시 -> 체크 아이콘 / 미완료 시 -> 빈 동그라미 아이콘
                          icon: snapshot.data[i].isDone ? const Icon(Icons.check_circle) : const Icon(Icons.circle_outlined),
                        ),

                        Expanded(
                          // 특정 TODO의 title에서 값을 받아 옴
                          child: Text(snapshot.data[i].title,
                              style: TextStyle(
                                fontSize: 18.0,
                                // TODO가 완료(isDone == true)일 경우 취소선, 아닐 경우(isDone == false) 일반 텍스트
                                decoration: snapshot.data[i].isDone ? TextDecoration.lineThrough : TextDecoration.none,
                              )),
                        ),

                        // 수정 버튼
                        IconButton(
                          onPressed: () async {
                            // TODO 수정
                            await _updateTodoDialog(snapshot.data[i]);
                            setState(() {});
                          },
                          // TODO가 수정 상태일 경우 -> check 아이콘, 수정 상태가 아닐 경우 연필(수정 가능) 아이콘 표시
                          icon: const Icon(Icons.edit),
                        ),
                        // 삭제 버튼
                        IconButton(
                          onPressed: () async {
                            // TODO 삭제
                            await TodoUtil().deleteTodo(snapshot.data[i]);
                            setState(() {});
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
      // FloatingActionButton: body 위젯 위에 떠있는(Floating) 버튼
      // 항상 최상단에 표출 되어있다고 생각하시면 됩니다..
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // FAB 버튼을 눌렀을 때 새로운 TODO 인스턴스 및 TextField 컨트롤러 추가
          await _showPostDialog();
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showPostDialog() async {
    TextEditingController textController = TextEditingController();

    // showDialog: 다이얼로그를 띄우는 함수
    // showDialog의 context는 현재 TodoPage의 context를 사용
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("TODO 추가하기"),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(
              hintText: "TODO 내용을 입력해주세요",
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("취소")),
            TextButton(
                onPressed: () async {
                  // TODO 추가
                  await TodoUtil().postTodos(textController.text);

                  if (mounted) Navigator.pop(context);
                  setState(() {});
                },
                child: const Text("추가")),
          ],
        );
      },
    );
  }

  Future<void> _updateTodoDialog(Todo todo) async {
    TextEditingController textController = TextEditingController(
      text: todo.title,
    );

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("TODO 수정하기"),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(
              hintText: "TODO 내용을 입력해주세요",
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("취소")),
            TextButton(
                onPressed: () async {
                  // TODO 수정
                  todo.title = textController.text;
                  await TodoUtil().updateTodos(todo);

                  if (mounted) Navigator.pop(context);
                  setState(() {});
                },
                child: const Text("추가")),
          ],
        );
      },
    );
  }
}
