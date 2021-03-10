import 'package:meta/meta.dart';
import 'package:nas_app/Model/User.dart';
import 'package:nas_app/Model/UserSettings.dart';

@immutable
class UserState {
  final bool? isError;
  final String? errorMessage;
  final bool? isLoading;
  final User? user;
  final bool? credentialsInStorage;
  final UserSettings? userSettings;
  final String? messagingToken;

  UserState(
      {this.isError,
      this.errorMessage,
      this.isLoading,
      this.user,
      this.credentialsInStorage,
      this.messagingToken,
      this.userSettings});

  factory UserState.initial() => UserState(
      errorMessage: "",
      isLoading: false,
      isError: false,
      user: null,
      messagingToken: "",
      userSettings: UserSettings.getInitialSettings());

  UserState copyWith(
      {required String? errorMessage,
      required bool? isError,
      required bool? isLoading,
      required User? user,
      required bool? credentialsInStorage,
      required String? messagingToken,
      required UserSettings? userSettings}) {
    return UserState(
        messagingToken: messagingToken ?? this.messagingToken,
        errorMessage: errorMessage ?? this.errorMessage,
        isError: isError ?? this.isError,
        isLoading: isLoading ?? this.isLoading,
        user: user ?? this.user,
        userSettings: userSettings ?? this.userSettings,
        credentialsInStorage:
            credentialsInStorage ?? this.credentialsInStorage);
  }
}
