import 'package:meta/meta.dart';

@immutable
class AddTodoState {
  final bool isTitleValid;
  final bool isDescriptionValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final String message;

  bool get isFormValid => isTitleValid && isDescriptionValid;

  AddTodoState({
    @required this.isTitleValid,
    @required this.isDescriptionValid,
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailure,
    this.message
  });

  factory AddTodoState.empty() {
    return AddTodoState(
      isTitleValid: true,
      isDescriptionValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory AddTodoState.loading() {
    return AddTodoState(
      isTitleValid: true,
      isDescriptionValid: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory AddTodoState.failure(String message) {
    return AddTodoState(
      isTitleValid: true,
      isDescriptionValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
      message: message,
    );
  }

  factory AddTodoState.success() {
    return AddTodoState(
      isTitleValid: true,
      isDescriptionValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
    );
  }

  AddTodoState update({
    bool isTitleValid,
    bool isDescriptionValid,
    bool isPhoneValid,
    bool isNameValid,
    bool isConfirmPasswordValid,
  }) {
    return copyWith(
      isTitleValid: isTitleValid,
      isDescriptionValid: isDescriptionValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  AddTodoState copyWith({
    bool isTitleValid,
    bool isDescriptionValid,
    bool isSubmitEnabled,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
  }) {
    return AddTodoState(
      isTitleValid: isTitleValid ?? this.isTitleValid,
      isDescriptionValid: isDescriptionValid ?? this.isDescriptionValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }

  @override
  String toString() {
    return '''AddTodoState {
      isTitleValid: $isTitleValid,
      isDescriptionValid: $isDescriptionValid,      
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
    }''';
  }
}
