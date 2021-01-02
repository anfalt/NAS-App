import 'package:meta/meta.dart';
import 'package:nas_app/Model/User.dart';

@immutable
class UserState {
  final bool isError;
  final String errorMessage;
  final bool isLoading;
  final User user;
  final bool credentialsInStorage;

  UserState(
      {this.isError,
      this.errorMessage,
      this.isLoading,
      this.user,
      this.credentialsInStorage});

  factory UserState.initial() => UserState(
        errorMessage: "",
        isLoading: false,
        isError: false,
        user: null,
      );

  UserState copyWith({
    @required String errorMessage,
    @required bool isError,
    @required bool isLoading,
    @required User user,
    @required credentialsInStorage,
  }) {
    return UserState(
        errorMessage: errorMessage ?? this.errorMessage,
        isError: isError ?? this.isError,
        isLoading: isLoading ?? this.isLoading,
        user: user ?? this.user,
        credentialsInStorage:
            credentialsInStorage ?? this.credentialsInStorage);
  }
}
