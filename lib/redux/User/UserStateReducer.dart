import 'package:nas_app/redux/User/UserState.dart';

import 'UserAction.dart';

userReducer(UserState prevState, SetUserStateAction action) {
  final payload = action.userState;
  return prevState.copyWith(
      errorMessage: payload.errorMessage,
      isError: payload.isError,
      isLoading: payload.isLoading,
      user: payload.user,
      credentialsInStorage: payload.credentialsInStorage);
}
