import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Counter extends StateNotifier<int> {
  Counter() : super(0); // 최초값

  void increment(){
    state++; // state 는 데이터 타입 
  } // 1. 변경 가능한 Class - StateNotifier 를 상속하는 

} // class 형태 : 창고
// 2. Provider 생성 
final counterProvider = StateNotifierProvider<Counter, int>((ref) {
  return Counter(); // 여기서 최초값 설정 연습 
}); // <창고, 창고 관리 데이터>

void main() {
  runApp(
    // For widgets to be able to read providers, we need to wrap the entire
    // application in a "ProviderScope" widget.
    // This is where the state of our providers will be stored.
    ProviderScope(
      child: MyApp(),
    ),
  );
}

// Extend ConsumerWidget instead of StatelessWidget, which is exposed by Riverpod
class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int value = ref.watch(counterProvider);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Example')),
        body: Center(
          child: Text("$value"), // 동적인 데이터가 들어오기 때문
        ),
        floatingActionButton: FloatingActionButton(
          onPressed:(){
            ref.read(counterProvider.notifier).increment(); // ref에 접근, notifier은 문법 창고의 메서드에 접근
          }, child: Icon(Icons.add),),
      ),
    );
  }
}