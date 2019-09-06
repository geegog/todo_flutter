import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:todo_flutter/task/bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo_flutter/task/bloc/todo_event.dart';
import 'package:todo_flutter/task/bloc/todo_state.dart';
import 'package:todo_flutter/task/domain/repository/todo_repository.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final _todoRepository = TodoRepository();
  String nextPage = "todo/all";

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
  // TODO: implement initialState
  TodoState get initialState => null;

  @override
  Stream<TodoState> mapEventToState(TodoEvent event) async* {
    if (event is Fetch && !_hasReachedMax(currentState)) {
      try {
        if (currentState is TodoUninitialized) {
          final todos = await _todoRepository.fetchData(nextPage);
          String after = todos.metadata.after;
          nextPage = "todo/all?after=$after";
          yield TodoLoaded(todos: todos.data, hasReachedMax: false);
          return;
        }
        if (currentState is TodoLoaded) {
          final todos = await _todoRepository.fetchData(nextPage);
          String after = todos.metadata.after;
          nextPage = "todo/all?after=$after";
          yield todos.data.isEmpty
              ? (currentState as TodoLoaded).copyWith(hasReachedMax: true)
              : TodoLoaded(
                  todos: (currentState as TodoLoaded).todos + todos.data,
                  hasReachedMax: false,
                );
        }
      } catch (_) {
        yield TodoError();
      }
    }
  }

  bool _hasReachedMax(TodoState state) =>
      state is TodoLoaded && state.hasReachedMax;
}
