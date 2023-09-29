import 'package:flutter/material.dart';
import 'package:flutter_study_todo/views/todo_page.dart';

void main() {
  // C언어의 main 함수와 같음, Dart의 main 함수에서 Flutter App을 실행
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp: 항상 runApp의 최상단에 감싸줘야 하는 위젯
    // theme(앱 전체에 적용되는 테마 설정), home(맨 처음 보여줄 화면),
    // locale(언어 설정) 등을 설정하는데 사용
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      // 맨 처음 보여줄 화면은 TodoPage!
      // views/todo_page.dart의 위젯을 가져옴 -> import 필수
      home: const TodoPage(),
    );
  }
}
