import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo_flutter/category/bloc/addcategory/bloc.dart';
import 'package:todo_flutter/category/domain/repository/category_repository.dart';
import 'package:todo_flutter/category/util/add_category_validators.dart';

class AddCategoryBloc extends Bloc<AddCategoryEvent, AddCategoryState> {
  final _categoryRepository = CategoryRepository();

  @override
  AddCategoryState get initialState => AddCategoryState.empty();

  @override
  Stream<AddCategoryState> transformEvents(
    Stream<AddCategoryEvent> events,
    Stream<AddCategoryState> Function(AddCategoryEvent event) next,
  ) {
    final observableStream = events as Observable<AddCategoryEvent>;
    final nonDebounceStream = observableStream.where((event) {
      return (event is! NameChanged );
    });
    final debounceStream = observableStream.where((event) {
      return (event is NameChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super
        .transformEvents(nonDebounceStream.mergeWith([debounceStream]), next);
  }

  @override
  Stream<AddCategoryState> mapEventToState(AddCategoryEvent event) async* {
    if (event is NameChanged) {
      yield* _mapNameChangedToState(event.name);
    } else if (event is AddCategoryButtonPressed) {
      yield* _mapAddCategoryButtonPressedToState(
        name: event.name,
      );
    }
  }

  Stream<AddCategoryState> _mapNameChangedToState(String name) async* {
    yield currentState.update(
      isNameValid: AddCategoryValidators.isValidName(name),
    );
  }

  Stream<AddCategoryState> _mapAddCategoryButtonPressedToState({
    String name,
  }) async* {
    yield AddCategoryState.loading();
    try {
      final response = await _categoryRepository.addCategory(
        name: name
      );
      Map<String, dynamic> responseObj = json.decode(response);

      if (responseObj['data'] != null) {
        yield AddCategoryState.success();
      }
      if (responseObj['errors'] != null) {
        yield AddCategoryState.failure(responseObj['errors'].toString());
      }
      if (responseObj['error'] != null) {
        yield AddCategoryState.failure(responseObj['error'].toString());
      }
    } catch (_) {
      yield AddCategoryState.failure(_.toString());
    }
  }
}
