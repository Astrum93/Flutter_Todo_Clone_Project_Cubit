import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/screen/main/tab/todo/w_todo_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TodoList extends StatelessWidget with TodoDataProvider {
  TodoList({super.key});

  /// mixin class TodoDataProvider를 사용하는 경우
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => todoData.todoList.isEmpty
          ? '할일을 작성 해보세요.'.text.size(30).makeCentered()
          : Column(
              children: todoData.todoList.map((e) => TodoItem(e)).toList(),
            ),
    );
  }

  /// GetBuilder를 사용하는 경우
// @override
// Widget build(BuildContext context) {
//   return GetBuilder<TodoDataHolder>(
//     builder: (todoData) {
//       return todoData.todoList.isEmpty
//           ? '할일을 작성 해보세요.'.text.size(30).makeCentered()
//           : Column(
//               children: todoData.todoList.map((e) => TodoItem(e)).toList(),
//             );
//     },
//   );
// }
}
