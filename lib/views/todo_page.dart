import 'package:flutter/material.dart';
import 'package:flutter_study_todo/models/todo.dart';

// StatefulWidget: 상태(화면)를 변화시킬 수 있는 위젯
class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final List<Todo> _todos = []; // TODO들을 담는 리스트
  final List<TextEditingController> _controllers = []; // TODO의 텍스트를 편집하기 위한 컨트롤러를 담는 리스트

  @override
  Widget build(BuildContext context) {
    // Scaffold: 마테리얼 디자인(구글의 디자인 가이드 라인)에 맞추어
    // 앱 화면을 구성하기 위한 기본 뼈대를 구성해 주는 위젯
    return Scaffold(
      // AppBar: Scaffold의 머리, 현재 페이지의 제목을 표시하거나 뒤로가기, 설정 버튼 등을 보여 줌
      appBar: AppBar(title: const Text("Flutter Todo")),
      // body: Scaffold의 몸통, 현재 페이지의 본문, html의 <body></body>
      body: ListView.builder(
        // ListView.builder: 원하는 위젯을 여러개 그릴 때 사용
        // 아래의 경우 for(int i = 0; i < todos.length; i++) Card(...) 와 유사함!
        itemCount: _todos.length, // 위젯을 그릴 횟수
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
                    onPressed: () {
                      // setState: (StatfulWidget에서) 값이 변했으니 화면을 다시 그리라고 명령!
                      setState(() {
                        // 특정 TODO가 완료되었을 경우, 해당 TODO가 완료 된 것으로 설정(isDone = true)
                        _todos[i].isDone = !_todos[i].isDone; // true일 경우 false로, false일 경우 true로
                      });
                    },
                    // 3항 연산자 이용,
                    // 조건문 ? 참일때 실행 : 거짓일 때 실행
                    // 아래의 경우 특정 TODO 완료 시 -> 체크 아이콘 / 미완료 시 -> 빈 동그라미 아이콘
                    icon: _todos[i].isDone ? const Icon(Icons.check_circle) : const Icon(Icons.circle_outlined),
                  ),
                  if (_todos[i].isEditing) ...[
                    // TODO가 수정 상태일 때

                    // Expanded: Row나 Column 안에서 빈 여백을 채우라고 명령하는 위젯
                    Expanded(
                      // TextField: 텍스트를 수정하기 위한 입력창 위젯
                      child: TextField(
                        // controller: TextField의 텍스트를 조정(control)하는 녀석
                        // TextField "외부"에서 controller를 통해 TextField의 값을 받아오거나 수정 할 수 있음
                        controller: _controllers[i],
                      ),
                    ),
                  ] else ...[
                    Expanded(
                      // 특정 TODO의 title에서 값을 받아 옴
                      child: Text(_todos[i].title,
                          style: TextStyle(
                            fontSize: 18.0,
                            // TODO가 완료(isDone == true)일 경우 취소선, 아닐 경우(isDone == false) 일반 텍스트
                            decoration: _todos[i].isDone ? TextDecoration.lineThrough : TextDecoration.none,
                          )),
                    ),
                  ],
                  // 수정 버튼
                  IconButton(
                    onPressed: () {
                      setState(() {
                        // TODO의 수정 상태 변경
                        _todos[i].isEditing = !_todos[i].isEditing; // true일 경우 false로, false일 경우 true로

                        // TextField의 값을 TODO의 title에서 가져옴
                        _controllers[i].text = _todos[i].title;
                      });
                    },
                    // TODO가 수정 상태일 경우 -> check 아이콘, 수정 상태가 아닐 경우 연필(수정 가능) 아이콘 표시
                    icon: _todos[i].isEditing ? const Icon(Icons.check) : const Icon(Icons.edit),
                  ),
                  // 삭제 버튼
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _todos.removeAt(i); // TODO를 모아놓은 리스트에서 특정 TODO를 삭제
                        _controllers.removeAt(i); // Controller를 모아놓은 리스트에서 특정 Controller를 삭제
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
      // FloatingActionButton: body 위젯 위에 떠있는(Floating) 버튼
      // 항상 최상단에 표출 되어있다고 생각하시면 됩니다..
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // FAB 버튼을 눌렀을 때 새로운 TODO 인스턴스 및 TextField 컨트롤러 추가
          setState(() {
            _todos.add(Todo());
            _controllers.add(TextEditingController());
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
