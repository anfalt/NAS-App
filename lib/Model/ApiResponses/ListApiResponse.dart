import 'package:nas_app/Model/List.dart';

class ListApiResponse {
  bool? success;
  String? errorMessage;

  ListApiResponse({this.errorMessage, this.success});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['success'] = this.success;
    data['errorMessage'] = this.errorMessage;
    return data;
  }

  ListApiResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
  }
}

class AllListsResponse {
  List<ListElement> body = [];
  int? itemCount;
  bool? success;
  String? errorMessage;

  AllListsResponse({this.body = const [], this.itemCount});

  AllListsResponse.fromJson(Map<String, dynamic> json) {
    if (json['body'] != null) {
      body = [];
      json['body'].forEach((v) {
        body.add(new ListElement.fromJson(v));
      });
    }
    itemCount = json['itemCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.body != null) {
      data['body'] = this.body.map((v) => v.toJson()).toList();
    }
    data['itemCount'] = this.itemCount;
    return data;
  }
}
