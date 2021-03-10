
import 'package:dio/dio.dart';
import 'package:nas_app/Model/ApiResponses/AlbumApiResponse.dart';
import 'package:nas_app/Model/User.dart';

class AlbumAsset extends Asset {
  bool? isMarked;
  AlbumAsset? parentAsset;
  List<AlbumAsset> assets;

  AlbumAsset(
      Additional? additional,
      String? thumbnailStatus,
      String? id,
      Info? info,
      String? type,
      bool? isMarked,
      AlbumAsset? parentAsset,
      List<AlbumAsset> assets)
      : this.isMarked = isMarked,
        this.parentAsset = parentAsset,
        this.assets = assets,
        super(
            additional: additional,
            thumbnailStatus: thumbnailStatus,
            id: id,
            info: info,
            type: type);

  String getLargeThumbUrl(User user) {
    return "https://anfalt.de/photo/webapi/thumb.php?api=SYNO.PhotoStation.Thumb&method=get&version=1&size=large&id=" +
        this.id! +
        "&thumb_sig=" +
        this.additional!.thumbSize!.sig! +
        "&mtime=" +
        this.additional!.thumbSize!.large!.mtime.toString() +
        "&SynoToken=" +
        user.photoSessionId!;
  }

  String getSmallThumbURL(User user) {
    return "https://anfalt.de/photo/webapi/thumb.php?api=SYNO.PhotoStation.Thumb&method=get&version=1&size=small&id=" +
        this.id! +
        "&thumb_sig=" +
        this.additional!.thumbSize!.sig! +
        "&mtime=" +
        this.additional!.thumbSize!.small!.mtime.toString() +
        "&SynoToken=" +
        user.photoSessionId!;
  }

  String getPreviewThumbURL(User user) {
    return "https://anfalt.de/photo/webapi/thumb.php?api=SYNO.PhotoStation.Thumb&method=get&version=1&size=preview&id=" +
        this.id! +
        "&thumb_sig=" +
        this.additional!.thumbSize!.sig! +
        "&mtime=" +
        this.additional!.thumbSize!.preview!.mtime.toString() +
        "&SynoToken=" +
        user.photoSessionId!;
  }

  String getImageDownloadUrl(User user) {
    var url = "https://anfalt.de/photo/webapi/download.php?SynoToken=" +
        user.photoSessionId!;

    return url;
  }

  FormData getImageDownloadBody(User user) {
    var body = {
      "api": "SYNO.PhotoStation.Download",
      "method": "getphoto",
      "version": "1",
      "no_structure": false,
      "download": true,
      "id": this.id
    };

    FormData formData = FormData.fromMap(body);

    return formData;
  }

  Map<String, String> getVideoDownloadUrls(User user) {
    Map<String, String> result = {};
    var stringPattern =
        "https://anfalt.de/photo/webapi/download.php/1.mp4?api=SYNO.PhotoStation.Download&method=getvideo&version=1&id=" +
            this.id! +
            "&quality_id=<qualityID>" +
            "&SynoToken=" +
            user.photoSessionId!;

    this.additional!.videoQuality.forEach((element) {
      result[element.profileName!] =
          stringPattern.replaceAll("<qualityID>", element.id!);
    });

    return result;
  }
}
