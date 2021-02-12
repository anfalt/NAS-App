class AlbumApiResponse {
  bool success;
  Data data;
  AlbumApiError error;

  AlbumApiResponse({this.success, this.data});

  AlbumApiResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'] != null
        ? new AlbumApiError.fromJson(json['error'])
        : null;
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    if (this.error != null) {
      data['error'] = this.error.toJson();
    }
    return data;
  }
}

class AlbumApiError {
  int code;
  String message;

  AlbumApiError({this.code});

  AlbumApiError.fromJson(Map<String, dynamic> json) {
    code = json['code'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    return data;
  }
}

class Data {
  int total;
  int offset;
  List<Asset> items;

  Data({this.total, this.offset, this.items});

  Data.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    offset = json['offset'];
    if (json['items'] != null) {
      items = new List<Asset>();
      json['items'].forEach((v) {
        items.add(new Asset.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['offset'] = this.offset;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Asset {
  Info info;
  String id;
  String type;
  Additional additional;
  String thumbnailStatus;

  Asset({this.info, this.id, this.type, this.additional, this.thumbnailStatus});

  Asset.fromJson(Map<String, dynamic> json) {
    info = json['info'] != null ? new Info.fromJson(json['info']) : null;
    id = json['id'];
    type = json['type'];
    additional = json['additional'] != null
        ? new Additional.fromJson(json['additional'])
        : null;
    thumbnailStatus = json['thumbnail_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.info != null) {
      data['info'] = this.info.toJson();
    }
    data['id'] = this.id;
    data['type'] = this.type;
    if (this.additional != null) {
      data['additional'] = this.additional.toJson();
    }
    data['thumbnail_status'] = this.thumbnailStatus;
    return data;
  }
}

class Info {
  String sharepath;
  String name;
  String title;
  String description;
  int hits;
  String createdate;
  String type;
  bool conversion;
  bool allowComment;
  bool allowEmbed;

  Info(
      {this.sharepath,
      this.name,
      this.title,
      this.description,
      this.hits,
      this.type,
      this.createdate,
      this.conversion,
      this.allowComment,
      this.allowEmbed});

  Info.fromJson(Map<String, dynamic> json) {
    sharepath = json['sharepath'];
    name = json['name'];
    title = json['title'];
    description = json['description'];
    hits = json['hits'];
    type = json['type'];
    conversion = json['conversion'];
    allowComment = json['allow_comment'];
    allowEmbed = json['allow_embed'];
    createdate = json['createdate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sharepath'] = this.sharepath;
    data['name'] = this.name;
    data['title'] = this.title;
    data['description'] = this.description;
    data['hits'] = this.hits;
    data['type'] = this.type;
    data['conversion'] = this.conversion;
    data['allow_comment'] = this.allowComment;
    data['allow_embed'] = this.allowEmbed;
    data['createdate'] = this.createdate;
    return data;
  }
}

class Additional {
  AlbumPermission albumPermission;

  ItemCount itemCount;
  String fileLocation;
  ThumbSize thumbSize;
  VideoCodec videoCodec;
  List<VideoQuality> videoQuality;

  Additional(
      {this.albumPermission,
      this.itemCount,
      this.fileLocation,
      this.thumbSize,
      this.videoCodec,
      this.videoQuality});

  Additional.fromJson(Map<String, dynamic> json) {
    albumPermission = json['album_permission'] != null
        ? new AlbumPermission.fromJson(json['album_permission'])
        : null;
    itemCount = json['item_count'] != null
        ? new ItemCount.fromJson(json['item_count'])
        : null;
    fileLocation = json['file_location'];
    thumbSize = json['thumb_size'] != null
        ? new ThumbSize.fromJson(json['thumb_size'])
        : null;
    videoCodec = json['video_codec'] != null
        ? new VideoCodec.fromJson(json['video_codec'])
        : null;
    if (json['video_quality'] != null) {
      videoQuality = new List<VideoQuality>();
      json['video_quality'].forEach((v) {
        videoQuality.add(new VideoQuality.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.albumPermission != null) {
      data['album_permission'] = this.albumPermission.toJson();
    }
    if (this.itemCount != null) {
      data['item_count'] = this.itemCount.toJson();
    }
    data['file_location'] = this.fileLocation;
    if (this.thumbSize != null) {
      data['thumb_size'] = this.thumbSize.toJson();
    }
    if (this.videoCodec != null) {
      data['video_codec'] = this.videoCodec.toJson();
    }
    if (this.videoQuality != null) {
      data['video_quality'] = this.videoQuality.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PhotoExif {
  String takendate;
  String camera;
  String cameraModel;
  String exposure;
  String aperture;
  int iso;
  Gps gps;
  String focalLength;
  String lens;
  String flash;

  PhotoExif(
      {this.takendate,
      this.camera,
      this.cameraModel,
      this.exposure,
      this.aperture,
      this.iso,
      this.gps,
      this.focalLength,
      this.lens,
      this.flash});

  PhotoExif.fromJson(Map<String, dynamic> json) {
    takendate = json['takendate'];
    camera = json['camera'];
    cameraModel = json['camera_model'];
    exposure = json['exposure'];
    aperture = json['aperture'];
    iso = json['iso'];
    gps = json['gps'] != null ? new Gps.fromJson(json['gps']) : null;
    focalLength = json['focal_length'];
    lens = json['lens'];
    flash = json['flash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['takendate'] = this.takendate;
    data['camera'] = this.camera;
    data['camera_model'] = this.cameraModel;
    data['exposure'] = this.exposure;
    data['aperture'] = this.aperture;
    data['iso'] = this.iso;
    if (this.gps != null) {
      data['gps'] = this.gps.toJson();
    }
    data['focal_length'] = this.focalLength;
    data['lens'] = this.lens;
    data['flash'] = this.flash;
    return data;
  }
}

class Gps {
  String lat;
  String lng;

  Gps({this.lat, this.lng});

  Gps.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}

class VideoCodec {
  String container;
  String vcodec;
  String acodec;
  int resolutionx;
  int resolutiony;
  int frameBitrate;
  int videoBitrate;
  int audioBitrate;

  VideoCodec(
      {this.container,
      this.vcodec,
      this.acodec,
      this.resolutionx,
      this.resolutiony,
      this.frameBitrate,
      this.videoBitrate,
      this.audioBitrate});

  VideoCodec.fromJson(Map<String, dynamic> json) {
    container = json['container'];
    vcodec = json['vcodec'];
    acodec = json['acodec'];
    resolutionx = json['resolutionx'];
    resolutiony = json['resolutiony'];
    frameBitrate = json['frame_bitrate'];
    videoBitrate = json['video_bitrate'];
    audioBitrate = json['audio_bitrate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['container'] = this.container;
    data['vcodec'] = this.vcodec;
    data['acodec'] = this.acodec;
    data['resolutionx'] = this.resolutionx;
    data['resolutiony'] = this.resolutiony;
    data['frame_bitrate'] = this.frameBitrate;
    data['video_bitrate'] = this.videoBitrate;
    data['audio_bitrate'] = this.audioBitrate;
    return data;
  }
}

class VideoQuality {
  String id;
  String container;
  String vcodec;
  String acodec;
  int filesize;
  int resolutionx;
  int resolutiony;
  int videoBitrate;
  int audioBitrate;
  int videoProfile;
  int videoLevel;
  String profileName;

  VideoQuality(
      {this.id,
      this.container,
      this.vcodec,
      this.acodec,
      this.filesize,
      this.resolutionx,
      this.resolutiony,
      this.videoBitrate,
      this.audioBitrate,
      this.videoProfile,
      this.videoLevel,
      this.profileName});

  VideoQuality.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    container = json['container'];
    vcodec = json['vcodec'];
    acodec = json['acodec'];
    filesize = json['filesize'];
    resolutionx = json['resolutionx'];
    resolutiony = json['resolutiony'];
    videoBitrate = json['video_bitrate'];
    audioBitrate = json['audio_bitrate'];
    videoProfile = json['video_profile'];
    videoLevel = json['video_level'];
    profileName = json['profile_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['container'] = this.container;
    data['vcodec'] = this.vcodec;
    data['acodec'] = this.acodec;
    data['filesize'] = this.filesize;
    data['resolutionx'] = this.resolutionx;
    data['resolutiony'] = this.resolutiony;
    data['video_bitrate'] = this.videoBitrate;
    data['audio_bitrate'] = this.audioBitrate;
    data['video_profile'] = this.videoProfile;
    data['video_level'] = this.videoLevel;
    data['profile_name'] = this.profileName;
    return data;
  }
}

class Autogenerated {
  bool success;
  Data data;

  Autogenerated({this.success, this.data});

  Autogenerated.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Items {
  String id;
  String type;
  Info info;
  Additional additional;
  String thumbnailStatus;

  Items({this.id, this.type, this.info, this.additional, this.thumbnailStatus});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    info = json['info'] != null ? new Info.fromJson(json['info']) : null;
    additional = json['additional'] != null
        ? new Additional.fromJson(json['additional'])
        : null;
    thumbnailStatus = json['thumbnail_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    if (this.info != null) {
      data['info'] = this.info.toJson();
    }
    if (this.additional != null) {
      data['additional'] = this.additional.toJson();
    }
    data['thumbnail_status'] = this.thumbnailStatus;
    return data;
  }
}

class ThumbSize {
  Preview preview;
  Preview small;
  Preview large;
  String sig;

  ThumbSize({this.preview, this.small, this.large, this.sig});

  ThumbSize.fromJson(Map<String, dynamic> json) {
    preview =
        json['preview'] != null ? new Preview.fromJson(json['preview']) : null;
    small = json['small'] != null ? new Preview.fromJson(json['small']) : null;
    large = json['large'] != null ? new Preview.fromJson(json['large']) : null;
    sig = json['sig'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.preview != null) {
      data['preview'] = this.preview.toJson();
    }
    if (this.small != null) {
      data['small'] = this.small.toJson();
    }
    if (this.large != null) {
      data['large'] = this.large.toJson();
    }
    data['sig'] = this.sig;
    return data;
  }
}

class Preview {
  int resolutiony;
  int resolutionx;
  int mtime;

  Preview({this.resolutiony, this.resolutionx, this.mtime});

  Preview.fromJson(Map<String, dynamic> json) {
    resolutiony = json['resolutiony'];
    resolutionx = json['resolutionx'];
    mtime = json['mtime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['resolutiony'] = this.resolutiony;
    data['resolutionx'] = this.resolutionx;
    data['mtime'] = this.mtime;
    return data;
  }
}

class AlbumPermission {
  bool browse;
  bool upload;
  bool manage;

  AlbumPermission({this.browse, this.upload, this.manage});

  AlbumPermission.fromJson(Map<String, dynamic> json) {
    browse = json['browse'];
    upload = json['upload'];
    manage = json['manage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['browse'] = this.browse;
    data['upload'] = this.upload;
    data['manage'] = this.manage;
    return data;
  }
}

class ItemCount {
  int photo;
  int video;

  ItemCount({this.photo, this.video});

  ItemCount.fromJson(Map<String, dynamic> json) {
    photo = json['photo'];
    video = json['video'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['photo'] = this.photo;
    data['video'] = this.video;
    return data;
  }
}

class Small {
  int resolutiony;
  int resolutionx;
  int mtime;

  Small({this.resolutiony, this.resolutionx, this.mtime});

  Small.fromJson(Map<String, dynamic> json) {
    resolutiony = json['resolutiony'];
    resolutionx = json['resolutionx'];
    mtime = json['mtime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['resolutiony'] = this.resolutiony;
    data['resolutionx'] = this.resolutionx;
    data['mtime'] = this.mtime;
    return data;
  }
}
