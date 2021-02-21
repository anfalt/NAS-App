import 'package:nas_app/Model/ApiResponses/AlbumApiResponse.dart';

class AlbumInfoApiResponse {
  bool success;
  Data data;
  AlbumInfoApiError error;

  AlbumInfoApiResponse({this.success, this.data});

  AlbumInfoApiResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'] != null
        ? new AlbumInfoApiError.fromJson(json['error'])
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

class AlbumInfoApiError {
  int code;
  String message;

  AlbumInfoApiError({this.code});

  AlbumInfoApiError.fromJson(Map<String, dynamic> json) {
    code = json['code'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    return data;
  }
}

class Data {
  List<Items> items;

  Data({this.items});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String id;
  Info info;
  Additional additional;
  String thumbnailStatus;

  Items({this.id, this.info, this.additional});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    thumbnailStatus = json['thumbnailStatus'];
    info = json['info'] != null ? new Info.fromJson(json['info']) : null;
    additional = json['additional'] != null
        ? new Additional.fromJson(json['additional'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.info != null) {
      data['info'] = this.info.toJson();
    }
    if (this.additional != null) {
      data['additional'] = this.additional.toJson();
    }
    if (this.thumbnailStatus != null) {
      data['thumbnailStatus'] = this.thumbnailStatus;
    }
    return data;
  }
}
