
import 'package:meta/meta.dart';
import 'package:nas_app/Model/Asset.dart';

@immutable
class AssetState {
  final bool? isError;
  final String? errorMessage;
  final bool? isLoading;
  final AlbumAsset? asset;
  final List<AlbumAsset>? latestAssets;

  AssetState(
      {this.isError,
      this.isLoading,
      this.asset,
      this.errorMessage,
      this.latestAssets});

  factory AssetState.initial() => AssetState(
      isLoading: false,
      isError: false,
      errorMessage: "",
      asset: null,
      latestAssets: []);

  AssetState copyWith(
      {required bool? isError,
      required String? errorMessage,
      required bool? isLoading,
      required AlbumAsset? asset,
      required List<AlbumAsset>? latestAssets}) {
    return AssetState(
        isError: isError ?? this.isError,
        errorMessage: errorMessage ?? this.errorMessage,
        isLoading: isLoading ?? this.isLoading,
        asset: asset ?? this.asset,
        latestAssets: latestAssets ?? this.latestAssets);
  }
}
