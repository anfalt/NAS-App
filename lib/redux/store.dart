import 'dart:async';

import 'package:meta/meta.dart';
import 'package:nas_app/redux/User/UserAction.dart';
import 'package:nas_app/redux/User/UserState.dart';
import 'package:nas_app/redux/User/UserStateReducer.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import 'Asset/AssetState.dart';
import 'Asset/AssetStateAction.dart';
import 'Asset/AssetStateReducer.dart';

AppState appReducer(AppState state, dynamic action) {
  if (action is SetAssetsStateAction) {
    final nextAssetState = assetsReducer(state.assetState, action);
    return state.copyWith(assetState: nextAssetState);
  } else if (action is SetUserStateAction) {
    final nextUserState = userReducer(state.userState, action);
    return state.copyWith(userState: nextUserState);
  }

  return state;
}

@immutable
class AppState {
  final AssetState assetState;
  final UserState userState;

  AppState({
    @required this.assetState,
    @required this.userState,
  });

  AppState copyWith({
    AssetState assetState,
    UserState userState,
  }) {
    return AppState(
      assetState: assetState ?? this.assetState,
      userState: userState ?? this.userState,
    );
  }
}

class Redux {
  static Store<AppState> _store;

  static Store<AppState> get store {
    if (_store == null) {
      throw Exception("store is not initialized");
    } else {
      return _store;
    }
  }

  static Future<void> init() async {
    final assetStateInitial = AssetState.initial();
    final userStateInitialState = UserState.initial();

    _store = Store<AppState>(
      appReducer,
      middleware: [thunkMiddleware],
      initialState: AppState(
          assetState: assetStateInitial, userState: userStateInitialState),
    );
  }
}
