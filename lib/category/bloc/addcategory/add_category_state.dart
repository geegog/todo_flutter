import 'package:meta/meta.dart';

@immutable
class AddCategoryState {
  final bool isNameValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final String message;

  bool get isFormValid => isNameValid;

  AddCategoryState({
    @required this.isNameValid,
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailure,
    this.message
  });

  factory AddCategoryState.empty() {
    return AddCategoryState(
      isNameValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory AddCategoryState.loading() {
    return AddCategoryState(
      isNameValid: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory AddCategoryState.failure(String message) {
    return AddCategoryState(
      isNameValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
      message: message,
    );
  }

  factory AddCategoryState.success() {
    return AddCategoryState(
      isNameValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
    );
  }

  AddCategoryState update({
    bool isNameValid,
  }) {
    return copyWith(
      isNameValid: isNameValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  AddCategoryState copyWith({
    bool isNameValid,
    bool isSubmitEnabled,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
  }) {
    return AddCategoryState(
      isNameValid: isNameValid ?? this.isNameValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }

  @override
  String toString() {
    return '''AddCategoryState {
      isNameValid: $isNameValid,      
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
    }''';
  }
}
