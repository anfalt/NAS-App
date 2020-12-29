class FileApiAuthResponse {
  FileApiData data;
  bool success;
  FileApiError error;

  FileApiAuthResponse({this.data, this.success});

  FileApiAuthResponse.fromJson(Map<String, dynamic> json) {
    error =
        json['error'] != null ? new FileApiError.fromJson(json['error']) : null;
    data = json['data'] != null ? new FileApiData.fromJson(json['data']) : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['success'] = this.success;
    if (this.error != null) {
      data['error'] = this.error.toJson();
    }
    return data;
  }
}

class FileApiData {
  String sid;

  FileApiData({this.sid});

  FileApiData.fromJson(Map<String, dynamic> json) {
    sid = json['sid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sid'] = this.sid;
    return data;
  }
}

class FileApiError {
  int code;

  FileApiError({this.code});

  FileApiError.fromJson(Map<String, dynamic> json) {
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    return data;
  }
}
