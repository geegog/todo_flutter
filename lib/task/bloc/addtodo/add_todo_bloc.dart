import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo_flutter/task/bloc/addtodo/bloc.dart';
import 'package:todo_flutter/task/domain/repository/todo_repository.dart';
import 'package:todo_flutter/task/util/add_todo_validators.dart';

class AddTodoBloc extends Bloc<AddTodoEvent, AddTodoState> {
  final _todoRepository = TodoRepository();

  @override
  AddTodoState get initialState => AddTodoState.empty();

  @override
  Stream<AddTodoState> transformEvents(
    Stream<AddTodoEvent> events,
    Stream<AddTodoState> Function(AddTodoEvent event) next,
  ) {
    final observableStream = events as Observable<AddTodoEvent>;
    final nonDebounceStream = observableStream.where((event) {
      return (event is! TitleChanged && event is! DescriptionChanged);
    });
    final debounceStream = observableStream.where((event) {
      return (event is TitleChanged || event is DescriptionChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super
        .transformEvents(nonDebounceStream.mergeWith([debounceStream]), next);
  }

  @override
  Stream<AddTodoState> mapEventToState(AddTodoEvent event) async* {
    if (event is TitleChanged) {
      yield* _mapTitleChangedToState(event.title);
    } else if (event is DescriptionChanged) {
      yield* _mapDescriptionChangedToState(event.description);
    } else if (event is AddTodoButtonPressed) {
      yield* _mapAddTodoButtonPressedToState(
        title: event.title,
        description: event.description,
        datetime: event.datetime,
      );
    }
  }

  Stream<AddTodoState> _mapTitleChangedToState(String title) async* {
    yield currentState.update(
      isTitleValid: AddTodoValidators.isValidTitle(title),
    );
  }

  Stream<AddTodoState> _mapDescriptionChangedToState(
      String description) async* {
    yield currentState.update(
      isDescriptionValid: AddTodoValidators.isValidDescription(description),
    );
  }

  Stream<AddTodoState> _mapAddTodoButtonPressedToState({
    String title,
    String description,
    String datetime,
  }) async* {
    yield AddTodoState.loading();
    try {
      final response = await _todoRepository.addTodo(
        title: title,
        description: description,
        datetime: datetime,
      );
      Map<String, dynamic> responseObj = json.decode(response);

      if (responseObj['data'] != null) {
        yield AddTodoState.success();
      }
      if (responseObj['errors'] != null) {
        yield AddTodoState.failure(responseObj['errors'].toString());
      }
      if (responseObj['error'] != null) {
        yield AddTodoState.failure(responseObj['error'].toString());
      }
    } catch (_) {
      yield AddTodoState.failure(_.toString());
    }
  }
}
