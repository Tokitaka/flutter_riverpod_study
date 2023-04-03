import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//1. 상태관리 창고 class
class Counter extends StateNotifier<int> {
  Counter(super.state);

  void increment() {
    state++;
  }
}

// 2. StateNotifierProvider 생성
final counterProvider =
StateNotifierProvider<Counter, int>((_) => Counter(0)); // 초기값 0

void main() {
  runApp(
      ProviderScope(
          child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 상위클래스 순서대로 build되고, context를 매개변수로 넘긴다 : 그림의 위치, 상속 정보
    return Container(
      color: Colors.yellow,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(child: HeaderPage()), //가로로 무한대, Column // 생성자로 초기화
            Expanded(child: BottomPage()), // 메서드의 주소를 넘기는 것 , 이름만 적으면 됨
          ],
        ),
      ),
    );
  }
}
// Consumer 사용한 정교한 부분 랜더링 구현
class HeaderPage extends StatelessWidget {
  HeaderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("나 그려짐"); // 작동 안함
    return Container(
      color: Colors.red,
      child: Align(
        alignment: Alignment.bottomRight, // 자세한 위치 처리가 가능
        // Align은 부모 크기 만큼 확장, 세로/가로가 Block 처리되서 정렬가능
        child: Consumer(
          builder: (context, ref, child) {
            final int number = ref.watch(counterProvider);
            return Text(
              "$number",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 100,
              ),
            );
          },
        ),),
    );
  }
}

class BottomPage extends ConsumerWidget {
  BottomPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Colors.blue,
      child: Align(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () {
            ref.read(counterProvider.notifier)
                .increment(); // read 하면 절대 build는 두번 되지 않는다 코드 재push 하지않는한
          },
          child: Text(
            "증가",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 100,
            ),
          ),
        ),
      ),
    );
  }
}
