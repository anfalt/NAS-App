class PhotoApiAuthResponse {
  bool success;
  PhotoApiData data;
  PhotoApiError error;

  PhotoApiAuthResponse({this.success, this.data});

  PhotoApiAuthResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data =
        json['data'] != null ? new PhotoApiData.fromJson(json['data']) : null;
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

class PhotoApiError {
  int code;
  String message;

  PhotoApiError({this.code});

  PhotoApiError.fromJson(Map<String, dynamic> json) {
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    return data;
  }
}

class PhotoApiData {
  String sid;
  String username;
  bool regSynoUser;
  bool isAdmin;
  bool allowComment;
  PhotoApiPermission permission;
  bool enableFaceRecog;
  bool allowPublicShare;
  bool allowDownload;
  bool showDetail;

  PhotoApiData(
      {this.sid,
      this.username,
      this.regSynoUser,
      this.isAdmin,
      this.allowComment,
      this.permission,
      this.enableFaceRecog,
      this.allowPublicShare,
      this.allowDownload,
      this.showDetail});

  PhotoApiData.fromJson(Map<String, dynamic> json) {
    sid = json['sid'];
    username = json['username'];
    regSynoUser = json['reg_syno_user'];
    isAdmin = json['is_admin'];
    allowComment = json['allow_comment'];
    permission = json['permission'] != null
        ? new PhotoApiPermission.fromJson(json['permission'])
        : null;
    enableFaceRecog = json['enable_face_recog'];
    allowPublicShare = json['allow_public_share'];
    allowDownload = json['allow_download'];
    showDetail = json['show_detail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sid'] = this.sid;
    data['username'] = this.username;
    data['reg_syno_user'] = this.regSynoUser;
    data['is_admin'] = this.isAdmin;
    data['allow_comment'] = this.allowComment;
    if (this.permission != null) {
      data['permission'] = this.permission.toJson();
    }
    data['enable_face_recog'] = this.enableFaceRecog;
    data['allow_public_share'] = this.allowPublicShare;
    data['allow_download'] = this.allowDownload;
    data['show_detail'] = this.showDetail;
    return data;
  }
}

class PhotoApiPermission {
  bool browse;
  bool upload;
  bool manage;

  PhotoApiPermission({this.browse, this.upload, this.manage});

  PhotoApiPermission.fromJson(Map<String, dynamic> json) {
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
