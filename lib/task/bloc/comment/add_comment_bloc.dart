import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo_flutter/task/bloc/comment/bloc.dart';
import 'package:todo_flutter/task/domain/repository/comment_repository.dart';
import 'package:todo_flutter/task/util/add_comment_validators.dart';

class AddCommentBloc extends Bloc<AddCommentEvent, AddCommentState> {
  final _commentRepository = CommentRepository();

  @override
  AddCommentState get initialState => AddCommentState.empty();

  @override
  Stream<AddCommentState> transformEvents(
    Stream<AddCommentEvent> events,
    Stream<AddCommentState> Function(AddCommentEvent event) next,
  ) {
    final observableStream = events as Observable<AddCommentEvent>;
    final nonDebounceStream = observableStream.where((event) {
      return (event is! TextChanged);
    });
    final debounceStream = observableStream.where((event) {
      return (event is TextChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super
        .transformEvents(nonDebounceStream.mergeWith([debounceStream]), next);
  }

  @override
  Stream<AddCommentState> mapEventToState(AddCommentEvent event) async* {
    if (event is TextChanged) {
      yield* _mapTextChangedToState(event.text);
    } else if (event is AddCommentButtonPressed) {
      yield* _mapAddCommentButtonPressedToState(
        text: event.text,
        todoId: event.todoId,
      );
    }
  }

  Stream<AddCommentState> _mapTextChangedToState(String text) async* {
    yield currentState.update(
      isTextValid: AddCommentValidators.isValidText(text),
    );
  }

  Stream<AddCommentState> _mapAddCommentButtonPressedToState({
    String text,
    int todoId,
  }) async* {
    yield AddCommentState.loading();
    try {
      final response = await _commentRepository.addComment(
        text: text,
        todoId: todoId,
      );
      print(response);
      Map<String, dynamic> responseObj = json.decode(response);

      if (responseObj['data'] != null) {
        yield AddCommentState.success();
      }
      if (responseObj['errors'] != null) {
        yield AddCommentState.failure(responseObj['errors'].toString());
      }
      if (responseObj['error'] != null) {
        yield AddCommentState.failure(responseObj['error'].toString());
      }
    } catch (_) {
      yield AddCommentState.failure(_.toString());
    }
  }

}
