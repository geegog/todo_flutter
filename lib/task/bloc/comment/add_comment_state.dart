import 'package:meta/meta.dart';

@immutable
class AddCommentState {
  final bool isTextValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final String message;

  bool get isFormValid => isTextValid;

  AddCommentState({
    @required this.isTextValid,
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailure,
    this.message
  });

  factory AddCommentState.empty() {
    return AddCommentState(
      isTextValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory AddCommentState.loading() {
    return AddCommentState(
      isTextValid: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory AddCommentState.failure(String message) {
    return AddCommentState(
      isTextValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
      message: message,
    );
  }

  factory AddCommentState.success() {
    return AddCommentState(
      isTextValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
    );
  }

  AddCommentState update({
    bool isTextValid,
  }) {
    return copyWith(
      isTextValid: isTextValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  AddCommentState copyWith({
    bool isTextValid,
    bool isSubmitEnabled,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
  }) {
    return AddCommentState(
      isTextValid: isTextValid ?? this.isTextValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }

  @override
  String toString() {
    return '''AddCommentState {
      isTextValid: $isTextValid,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
    }''';
  }
}
