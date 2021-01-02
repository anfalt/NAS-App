import 'AssetState.dart';
import 'AssetStateAction.dart';

assetsReducer(AssetState prevState, SetAssetsStateAction action) {
  final payload = action.assetState;
  return prevState.copyWith(
    asset: payload.asset,
    errorMessage: payload.errorMessage,
    isError: payload.isError,
    isLoading: payload.isLoading,
  );
}
