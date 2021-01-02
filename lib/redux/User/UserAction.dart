import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:nas_app/Services/AuthService.dart';
import 'package:redux/redux.dart';

import '../store.dart';
import 'UserState.dart';

@immutable
class SetUserStateAction {
  final UserState userState;

  SetUserStateAction(this.userState);
}

Future<void> fetchUserLogOutAction(
    Store<AppState> store, AuthService authService) async {
  store.dispatch(SetUserStateAction(UserState(isLoading: true)));

  try {
    final storage = new FlutterSecureStorage();
    await storage.delete(key: "userName");
    await storage.delete(key: "password");

    SetUserStateAction(
      UserState(isLoading: false, credentialsInStorage: false, user: null),
    );
  } catch (error) {
    store.dispatch(SetUserStateAction(
        UserState(isLoading: false, credentialsInStorage: false, user: null)));
  }
}

Future<void> fetchUserActionFromStorage(
    Store<AppState> store, AuthService authService) async {
  store.dispatch(SetUserStateAction(UserState(isLoading: true)));

  try {
    var credentialsFromStorage = await _getUserCredentialsFromStorage();
    var passWord = credentialsFromStorage["passWord"];
    var userName = credentialsFromStorage["userName"];
    if (userName != null && passWord != null) {
      fetchUserAction(store, authService, userName, passWord);
    } else {
      store.dispatch(SetUserStateAction(
        UserState(isLoading: false, credentialsInStorage: false),
      ));
    }
  } catch (error) {
    store.dispatch(SetUserStateAction(
        UserState(isLoading: false, credentialsInStorage: false)));
  }
}

Future<void> fetchUserAction(Store<AppState> store, AuthService authServce,
    String username, String password) async {
  store.dispatch(SetUserStateAction(UserState(isLoading: true)));

  try {
    var authResult = await authServce.authenticateUser(username, password);
    if (!authResult.success) {
      throw ("Fehler bei der Anmeldung" + authResult.errorMessage);
    }
    var user = authResult.user;
    store.dispatch(SetUserStateAction(
      UserState(
        isLoading: false,
        user: user,
        credentialsInStorage: true,
      ),
    ));
  } catch (error) {
    store.dispatch(SetUserStateAction(UserState(
        isLoading: false, isError: true, errorMessage: error.toString())));
  }
}

Future<Map<String, String>> _getUserCredentialsFromStorage() async {
  final storage = new FlutterSecureStorage();
  var userName = await storage.read(key: "userName");
  var passWord = await storage.read(key: "password");

  return {"userName": userName, "passWord": passWord};
}
