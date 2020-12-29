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
  List<Album> items;

  Data({this.total, this.offset, this.items});

  Data.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    offset = json['offset'];
    if (json['items'] != null) {
      items = new List<Album>();
      json['items'].forEach((v) {
        items.add(new Album.fromJson(v));
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

class Album {
  Info info;
  String id;
  String type;
  Additional additional;
  String thumbnailStatus;

  Album({this.info, this.id, this.type, this.additional, this.thumbnailStatus});

  Album.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}

class Additional {
  AlbumPermission albumPermission;

  ItemCount itemCount;
  String fileLocation;
  ThumbSize thumbSize;

  Additional(
      {this.albumPermission,
      this.itemCount,
      this.fileLocation,
      this.thumbSize});

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

class ThumbSize {
  Preview preview;
  Small small;
  Small large;
  String sig;

  ThumbSize({this.preview, this.small, this.large, this.sig});

  ThumbSize.fromJson(Map<String, dynamic> json) {
    preview =
        json['preview'] != null ? new Preview.fromJson(json['preview']) : null;
    small = json['small'] != null ? new Small.fromJson(json['small']) : null;
    large = json['large'] != null ? new Small.fromJson(json['large']) : null;
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
  int resolutionx;
  int resolutiony;

  Preview({this.resolutionx, this.resolutiony});

  Preview.fromJson(Map<String, dynamic> json) {
    resolutionx = json['resolutionx'];
    resolutiony = json['resolutiony'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['resolutionx'] = this.resolutionx;
    data['resolutiony'] = this.resolutiony;
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
