import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo_flutter/task/bloc/comment/bloc.dart';
import 'package:todo_flutter/task/domain/repository/comment_repository.dart';
import 'package:todo_flutter/task/util/add_comment_validators.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final _commentRepository = CommentRepository();
  String nextPage = '';

  CommentBloc(CommentState initialState) : super(initialState);

  @override
  Stream<Transition<CommentEvent, CommentState>> transformEvents(
    Stream<CommentEvent> events,
    TransitionFunction<CommentEvent, CommentState> next,
  ) {
    return super.transformEvents(
      events.debounceTime(
        Duration(milliseconds: 500),
      ),
      next,
    );
  }

  @override
  Stream<CommentState> mapEventToState(CommentEvent event) async* {
    if (event is FetchComment && !_hasReachedMax(state)) {
      int todoId = event.todoId;
      try {
        if (state is CommentUninitialized) {
          nextPage = "comment/todo/$todoId/all";
          final comments = await _commentRepository.fetchData(nextPage);
          int pageNumber = comments.metadata.pageNumber + 1;
          nextPage = "comment/todo/$todoId/all?page=$pageNumber";
          yield CommentLoaded(
              comments: comments.data,
              hasReachedMax:
                  comments.metadata.pageNumber == comments.metadata.totalPages
                      ? true
                      : false);
          return;
        }
        if (state is CommentLoaded) {
          final comments = await _commentRepository.fetchData(nextPage);
          int pageNumber = comments.metadata.pageNumber + 1;
          nextPage = "comment/todo/$todoId/all?page=$pageNumber";
          yield CommentLoaded(
            comments: (state as CommentLoaded).comments + comments.data,
            hasReachedMax:
                pageNumber > comments.metadata.totalPages ? true : false,
          );
        }
      } catch (_) {
        print(_);
        yield CommentError();
      }
    }
    if (event is RefreshComment) {
      int todoId = event.todoId;
      try {
        final comments =
            await _commentRepository.fetchData("comment/todo/$todoId/all");
        int pageNumber = comments.metadata.pageNumber + 1;
        nextPage = "comment/todo/$todoId/all?page=$pageNumber";
        yield CommentLoaded(
            comments: comments.data,
            hasReachedMax:
                comments.metadata.pageNumber == comments.metadata.totalPages
                    ? true
                    : false,
            dateTime: DateTime.now());
      } catch (_) {
        print(_);
        yield state;
      }
    }
  }

  bool _hasReachedMax(CommentState state) =>
      state is CommentLoaded && state.hasReachedMax;
}
