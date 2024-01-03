// Todo 클래스를 정의하는 파일
class Todo {
  int id = 0; // DB상 TODO의 id
  String title = ""; // 각 TODO의 본문 저장
  bool isDone = false; // 각 TODO의 완료 여부

  // Todo 생성자
  // Todo()로 생성 시 title은 빈 값, isDone은 false, isEditing은 true로 지정된
  // 새로운 인스턴스 생성
  // Named Parameter
  Todo({
    this.id = 0,
    this.title = "",
    this.isDone = false,
  });

  @override
  String toString() => 'Todo(id: $id, title: $title, isDone: $isDone)';
}
