import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo_flutter/category/bloc/allcategory/bloc.dart';
import 'package:todo_flutter/category/domain/repository/category_repository.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final _categoryRepository = CategoryRepository();
  String nextPage = "category/all";

  CategoryBloc() : super(CategoryUninitialized());

  @override
  Stream<Transition<CategoryEvent, CategoryState>> transformEvents(
    Stream<CategoryEvent> events,
    TransitionFunction<CategoryEvent, CategoryState> next,
  ) {
    return super.transformEvents(
      events.debounceTime(
        Duration(milliseconds: 500),
      ),
      next,
    );
  }

  @override
  Stream<CategoryState> mapEventToState(CategoryEvent event) async* {
    if (event is FetchCategory && !_hasReachedMax(state)) {
      try {
        if (state is CategoryUninitialized) {
          final categories = await _categoryRepository.fetchData(nextPage);
          yield CategoryLoaded(categories: categories.data, hasReachedMax: true);
        }
      } catch (_) {
        yield CategoryError();
      }
    }
    if (event is RefreshCategory) {
      try {
        final categories = await _categoryRepository.fetchData(nextPage);
        yield CategoryLoaded(categories: categories.data, hasReachedMax: true, dateTime: DateTime.now());
      } catch (_) {
        yield state;
      }
    }
  }

  bool _hasReachedMax(CategoryState state) =>
      state is CategoryLoaded && state.hasReachedMax;
}
