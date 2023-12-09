import 'package:fast_app_base/data/memory/todo_status.dart';
import 'package:fast_app_base/data/memory/vo_todo.dart';
import 'package:fast_app_base/screen/dialog/d_confirm.dart';
import 'package:get/get.dart';
import '../../screen/main/write/d_write_todo.dart';

class TodoDataHolder extends GetxController {
  final RxList<Todo> todoList = <Todo>[].obs;

  void changeTodoStatus(Todo todo) async {
    switch (todo.status) {
      case TodoStatus.incomplete:
        todo.status = TodoStatus.ongoing;
      case TodoStatus.ongoing:
        todo.status = TodoStatus.complete;
      case TodoStatus.complete:
        final result = await ConfirmDialog('정말로 처음 상태로 변경 하시겠어요?').show();
        result?.runIfSuccess((data) {
          todo.status = TodoStatus.incomplete;
        });
        todo.status = TodoStatus.incomplete;
    }
    todoList.refresh();

    /// GetBuilder를 사용하는 경우 GetxController를 업데이트하기 위해 사용
    //update();
  }

  void addTodo() async {
    final result = await WriteTodoDialog().show();
    if (result != null) {
      todoList.add(Todo(
        id: DateTime.now().microsecondsSinceEpoch,
        title: result.text,
        dueDate: result.dateTime,
      ));

      /// obs의 add()는 내부에 refresh가 있다.

      //update();
    }
  }

  void editTodo(Todo todo) async {
    final result = await WriteTodoDialog(todoForEdit: todo).show();
    if (result != null) {
      todo.title = result.text;
      todo.dueDate = result.dateTime;
      todoList.refresh();
      //update();
    }
  }

  void removeTodo(Todo todo) {
    todoList.remove(todo);
    todoList.refresh();
    //update();
  }
}

mixin class TodoDataProvider {
  late final TodoDataHolder todoData = Get.find();
}
