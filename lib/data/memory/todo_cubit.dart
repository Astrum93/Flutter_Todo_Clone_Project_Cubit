import 'package:fast_app_base/data/memory/bloc/bloc_status.dart';
import 'package:fast_app_base/data/memory/bloc/todo_bloc_state.dart';
import 'package:fast_app_base/data/memory/todo_status.dart';
import 'package:fast_app_base/data/memory/vo_todo.dart';
import 'package:fast_app_base/screen/dialog/d_confirm.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../screen/main/write/d_write_todo.dart';

class TodoCubit extends Cubit<TodoBlocState> {
  TodoCubit() : super(const TodoBlocState(BlocStatus.initial, <Todo>[]));

  void addTodo() async {
    final result = await WriteTodoDialog().show();
    if (result != null) {
      /// Bloc의 state 안의 List는 수정 불가. 그러므로 수정 가능하게 변경하여 바뀐 state를 알려주는 방식으로 적용
      final copiedOldTodoList = List.of(state.todoList);
      copiedOldTodoList.add(Todo(
        id: DateTime.now().microsecondsSinceEpoch,
        title: result.text,
        dueDate: result.dateTime,
      ));
      emitNewList(copiedOldTodoList);
    }
  }

  void changeTodoStatus(Todo todo) async {
    /// Bloc의 state 안의 List는 수정 불가. 그러므로 수정 가능하게 변경하여 바뀐 state를 알려주는 방식으로 적용
    final copiedOldTodoList = List.of(state.todoList);

    /// Todo todo와 copiedOldTodoList의 위치 확인
    final todoIndex =
        copiedOldTodoList.indexWhere((element) => element.id == todo.id);

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

    /// 알아낸 위치정보를 활용하여 todo 수정
    copiedOldTodoList[todoIndex] = todo;
    emitNewList(copiedOldTodoList);
  }

  void editTodo(Todo todo) async {
    final result = await WriteTodoDialog(todoForEdit: todo).show();
    if (result != null) {
      todo.title = result.text;
      todo.dueDate = result.dateTime;

      final oldCopiedList = List<Todo>.from(state.todoList);
      oldCopiedList[oldCopiedList.indexOf(todo)] = todo;
      emitNewList(oldCopiedList);
    }
  }

  void removeTodo(Todo todo) {
    final oldCopiedList = List<Todo>.from(state.todoList);
    oldCopiedList.removeWhere((element) => element.id == todo.id);
    emitNewList(oldCopiedList);
  }

  void emitNewList(List<Todo> oldCopiedList) {
    emit(state.copyWith(todoList: oldCopiedList));
  }
}
