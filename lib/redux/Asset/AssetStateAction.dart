import 'package:meta/meta.dart';
import 'package:nas_app/Model/Asset.dart';
import 'package:nas_app/Services/AuthService.dart';
import 'package:nas_app/Services/PhotoService.dart';
import 'package:nas_app/redux/User/UserAction.dart';
import 'package:redux/redux.dart';

import '../store.dart';
import 'AssetState.dart';

@immutable
class SetAssetsStateAction {
  final AssetState assetState;

  SetAssetsStateAction(this.assetState);
}

Future<void> fetchAssetMarkedAction(
    Store<AppState> store, String assetId) async {
  var updatedAssets = store.state.assetState.asset.assets.map((el) {
    if (el.id == assetId) {
      el.isMarked = !el.isMarked;
    }
    return el;
  }).toList();

  var updatedAsset = store.state.assetState.asset;
  updatedAsset.assets = updatedAssets;
  store.dispatch(SetAssetsStateAction(AssetState(asset: updatedAsset)));
}

Future<void> fetchLatestAssetMarkedAction(
    Store<AppState> store, PhotoService photoService, String sessionId) async {
  store.dispatch(SetAssetsStateAction(
      AssetState(isLoading: true, isError: false, errorMessage: "")));

  try {
    var assetResp = await photoService.getLatestAssets(sessionId);

    if (!assetResp.success) {
      if (assetResp.error != null && assetResp.error.code == 417) {
        Redux.store.dispatch(
            (store) => fetchUserActionFromStorage(store, new AuthService()));
        return;
      } else {
        throw ("Fehler beim Laden der Alben: " +
            (assetResp.error.code != null
                ? assetResp.error.code.toString()
                : "") +
            (assetResp.error.message != null
                ? assetResp.error.message.toString()
                : ""));
      }
    }

    var latestAssets =
        await Future.wait(assetResp.data.items.map((asset) async {
      var albumId = "album_" + asset.id.split("_")[1];
      var albumInfo = await photoService.getAlbumInfo(sessionId, albumId);
      var albumAsset = new AlbumAsset(asset.additional, asset.thumbnailStatus,
          asset.id, asset.info, asset.type, false, null, []);
      if (albumInfo.success) {
        var parentAlbum = albumInfo.data.items.first;
        albumAsset.parentAsset = new AlbumAsset(
            parentAlbum.additional,
            parentAlbum.thumbnailStatus,
            parentAlbum.id,
            parentAlbum.info,
            "album",
            false,
            null, []);
      }

      return albumAsset;
    }).toList());
    store.dispatch(SetAssetsStateAction(
      AssetState(
          isLoading: false,
          latestAssets: latestAssets,
          errorMessage: "",
          isError: false),
    ));
  } catch (error) {
    store.dispatch(SetAssetsStateAction(AssetState(
        isLoading: false, isError: true, errorMessage: error.toString())));
  }
}

Future<void> fetchAssetWithChildrenAction(
    Store<AppState> store,
    PhotoService photoService,
    String sessionId,
    AlbumAsset parentAsset,
    String assetId) async {
  store.dispatch(SetAssetsStateAction(
      AssetState(isLoading: true, isError: false, errorMessage: "")));

  try {
    var assetResp = await photoService.getAssets(sessionId, assetId);

    if (!assetResp.success) {
      if (assetResp.error != null && assetResp.error.code == 417) {
        Redux.store.dispatch(
            (store) => fetchUserActionFromStorage(store, new AuthService()));
        return;
      } else {
        throw ("Fehler beim Laden der Alben: " +
            (assetResp.error.code != null
                ? assetResp.error.code.toString()
                : "") +
            (assetResp.error.message != null
                ? assetResp.error.message.toString()
                : ""));
      }
    }

    var albumInfoResp = await photoService.getAlbumInfo(sessionId, assetId);
    if (!albumInfoResp.success) {
      throw ("Fehler beim Laden der Alben: " +
          (albumInfoResp.error.code != null
              ? albumInfoResp.error.code.toString()
              : "") +
          (albumInfoResp.error.message != null
              ? albumInfoResp.error.message.toString()
              : ""));
    }
    var albumInfo = albumInfoResp.data.items[0].info;
    var thumbNailStats = albumInfoResp.data.items[0].thumbnailStatus;
    var albumAdditional = albumInfoResp.data.items[0].additional;
    var albumType = albumInfoResp.data.items[0].info.type;
    var currentAsset = new AlbumAsset(albumAdditional, thumbNailStats, assetId,
        albumInfo, albumType, false, parentAsset, []);

    var assetList = assetResp.data.items
        .map((asset) => new AlbumAsset(asset.additional, asset.thumbnailStatus,
            asset.id, asset.info, asset.type, false, currentAsset, []))
        .toList();

    currentAsset.assets = assetList;
    store.dispatch(SetAssetsStateAction(
      AssetState(
          isLoading: false,
          asset: currentAsset,
          errorMessage: "",
          isError: false),
    ));
  } catch (error) {
    store.dispatch(SetAssetsStateAction(AssetState(
        isLoading: false, isError: true, errorMessage: error.toString())));
  }
}
