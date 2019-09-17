import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo_flutter/category/bloc/allcategory/bloc.dart';
import 'package:todo_flutter/category/domain/repository/category_repository.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final _categoryRepository = CategoryRepository();
  String nextPage = "category/all";

  @override
  Stream<CategoryState> transformEvents(
    Stream<CategoryEvent> events,
    Stream<CategoryState> Function(CategoryEvent event) next,
  ) {
    return super.transformEvents(
      (events as Observable<CategoryEvent>).debounceTime(
        Duration(milliseconds: 500),
      ),
      next,
    );
  }

  @override
  get initialState => CategoryUninitialized();

  @override
  Stream<CategoryState> mapEventToState(CategoryEvent event) async* {
    if (event is Fetch && !_hasReachedMax(currentState)) {
      try {
        if (currentState is CategoryUninitialized) {
          final categories = await _categoryRepository.fetchData(nextPage);
          yield CategoryLoaded(categories: categories.data, hasReachedMax: true);
          return;
        }
      } catch (_) {
        yield CategoryError();
      }
    }
    if (event is Refresh) {
      try {
        final categories = await _categoryRepository.fetchData(nextPage);
        yield CategoryLoaded(categories: categories.data, hasReachedMax: true, dateTime: DateTime.now());
      } catch (_) {
        yield currentState;
      }
    }
  }

  bool _hasReachedMax(CategoryState state) =>
      state is CategoryLoaded && state.hasReachedMax;
}
