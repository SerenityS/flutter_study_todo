import 'package:dio/dio.dart';
import 'package:flutter_study_todo/models/todo.dart';

// API 주소
final String _baseUrl = 'http://todo.qwertycvb.com:8000/api/v1/todos';

// JWT 토큰(임시)
final String _token =
    "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiNGMyM2QzZjktNGU1OC00ZjJkLWFlM2UtMGVmYzk4MTY4MGM1IiwiYXVkIjpbImZhc3RhcGktdXNlcnM6YXV0aCIsImZhc3RhcGktdXNlcnM6dmVyaWZ5Il0sImVtYWlsIjoidXNlckBleGFtcGxlLmNvbSIsImlzU3VwZXJ1c2VyIjpmYWxzZSwiZXhwIjoxNzA0MjM0NjM4fQ.hvW-dFatUxfCtyR6pfVqUupP_T6M7Zsnw56KM1vyofc";

class TodoUtil {
  // Dio 라이브러리를 활용한 RESTful
  final Dio _dio = Dio();

  Future<void> postTodos(String content) async {
    // POST 요청
    await _dio.post(
      _baseUrl,
      options: Options(
          // 헤더를 통한 JWT 토큰 전달        headers: {'Authorization': "Bearer $_token"},
          ),
      // Request Body
      data: {'content': content},
    );
  }

  Future<List<Todo>> getTodos() async {
    List<Todo> todos = [];

    // GET 요청
    final response = await _dio.get(
      _baseUrl,
      options: Options(
        // 헤더를 통한 JWT 토큰 전달
        headers: {'Authorization': "Bearer $_token"},
      ),
      queryParameters: {
        'skip': 0,
        'limit': 100,
      },
    );

    // 응답받은 json을 순회하여 새로운 TODO 인스턴스 생성
    response.data.forEach((todo) {
      // 인스턴스를 리스트에 저장
      todos.add(Todo(
        id: todo['id'],
        title: todo['content'],
        isDone: todo['is_completed'],
      ));
    });

    return todos;
  }

  Future<void> updateTodos(Todo todo) async {
    // PUT 요청
    await _dio.put(
      '$_baseUrl/${todo.id}',
      options: Options(
        // 헤더를 통한 JWT 토큰 전달
        headers: {'Authorization': "Bearer $_token"},
      ),
      data: {
        'content': todo.title,
        'is_completed': todo.isDone,
      },
    );
  }

  Future<void> deleteTodo(Todo todo) async {
    // DELETE 요청
    await _dio.delete(
      '$_baseUrl/${todo.id}',
      options: Options(
        // 헤더를 통한 JWT 토큰 전달
        headers: {'Authorization': "Bearer $_token"},
      ),
    );
  }
}
