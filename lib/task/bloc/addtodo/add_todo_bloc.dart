import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo_flutter/category/domain/model/category.dart';
import 'package:todo_flutter/common/utils/date_time.dart';
import 'package:todo_flutter/task/bloc/addtodo/bloc.dart';
import 'package:todo_flutter/task/domain/repository/todo_repository.dart';
import 'package:todo_flutter/task/util/add_todo_validators.dart';

class AddTodoBloc extends Bloc<AddTodoEvent, AddTodoState> {
  final _todoRepository = TodoRepository();

  AddTodoBloc() : super(AddTodoState.empty());

  @override
  Stream<Transition<AddTodoEvent, AddTodoState>> transformEvents(
    Stream<AddTodoEvent> events,
    TransitionFunction<AddTodoEvent, AddTodoState>  next,
  ) {
    final observableStream = events;
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
        endDate: event.endDate,
        endTime: event.endTime,
        category: event.category
      );
    }
  }

  Stream<AddTodoState> _mapTitleChangedToState(String title) async* {
    yield state.update(
      isTitleValid: AddTodoValidators.isValidTitle(title),
    );
  }

  Stream<AddTodoState> _mapDescriptionChangedToState(
      String description) async* {
    yield state.update(
      isDescriptionValid: AddTodoValidators.isValidDescription(description),
    );
  }

  Stream<AddTodoState> _mapAddTodoButtonPressedToState({
    String title,
    String description,
    DateTime endDate,
    TimeOfDay endTime,
    Category category,
  }) async* {
    yield AddTodoState.loading();
    try {
      final response = await _todoRepository.addTodo(
        title: title,
        description: description,
        endDate: endDate,
        endTime: endTime,
        datetime: _dateTime(endDate, endTime),
        category: category
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

  String _dateTime(DateTime endDate, TimeOfDay endTime) {
      print(endDate.toIso8601String());
      print(endTime.toString());

      String datetime = endDate.toIso8601String().split('T')[0] +
          ' ' +
          formatTimeNumber(endTime.hour) +
          ':' +
          formatTimeNumber(endTime.minute) +
          ':00';
      print(datetime);

      return datetime;
  }
}
