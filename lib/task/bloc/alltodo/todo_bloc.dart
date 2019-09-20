import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:todo_flutter/task/bloc/alltodo/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo_flutter/task/bloc/alltodo/todo_event.dart';
import 'package:todo_flutter/task/bloc/alltodo/todo_state.dart';
import 'package:todo_flutter/task/domain/repository/todo_repository.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final _todoRepository = TodoRepository();
  String nextPage = "todo_category/all";

  @override
  Stream<TodoState> transformEvents(
    Stream<TodoEvent> events,
    Stream<TodoState> Function(TodoEvent event) next,
  ) {
    return super.transformEvents(
      (events as Observable<TodoEvent>).debounceTime(
        Duration(milliseconds: 500),
      ),
      next,
    );
  }

  @override
  get initialState => TodoUninitialized();

  @override
  Stream<TodoState> mapEventToState(TodoEvent event) async* {
    if (event is FetchTodo && !_hasReachedMax(currentState)) {
      try {
        if (currentState is TodoUninitialized) {
          final todos = await _todoRepository.fetchData(nextPage);
          int pageNumber = todos.metadata.pageNumber + 1;
          nextPage = "todo_category/all?page=$pageNumber";
          //print(nextPage);
          yield TodoLoaded(
              todos: todos.data,
              hasReachedMax:
                  todos.metadata.pageNumber == todos.metadata.totalPages
                      ? true
                      : false);
          return;
        }
        if (currentState is TodoLoaded) {
          final todos = await _todoRepository.fetchData(nextPage);
          int pageNumber = todos.metadata.pageNumber + 1;
          nextPage = "todo_category/all?page=$pageNumber";
          yield TodoLoaded(
            todos: (currentState as TodoLoaded).todos + todos.data,
            hasReachedMax:
                pageNumber > todos.metadata.totalPages ? true : false,
          );
        }
      } catch (_) {
        print(_);
        yield TodoError();
      }
    }
    if (event is RefreshTodo) {
      try {
        final todos = await _todoRepository.fetchData("todo_category/all");
        int pageNumber = todos.metadata.pageNumber + 1;
        nextPage = "todo_category/all?page=$pageNumber";
        yield TodoLoaded(
            todos: todos.data, hasReachedMax: todos.metadata.pageNumber == todos.metadata.totalPages
            ? true
            : false, dateTime: DateTime.now());
      } catch (_) {
        print(_);
        yield currentState;
      }
    }
  }

  bool _hasReachedMax(TodoState state) =>
      state is TodoLoaded && state.hasReachedMax;
}
