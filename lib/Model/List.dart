
enum ListItemStatus { deleted, open, done, important }

class ListElement {
  String? iD;
  String? title;
  String? createdDate;
  String? modified;
  String? isDeleted;
  bool? isMarked = false;
  List<ListItem> items = [];

  ListElement(
      {this.iD, this.title, this.createdDate, this.modified, this.isDeleted});

  ListElement.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    title = json['Title'];
    createdDate = json['CreatedDate'];
    modified = json['Modified'];
    isDeleted = json['IsDeleted'];
    if (json['ListItems'] != null) {
      items = [];
      json['ListItems'].forEach((v) {
        items.add(new ListItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Title'] = this.title;
    data['CreatedDate'] = this.createdDate;
    data['Modified'] = this.modified;
    data['IsDeleted'] = this.isDeleted;
    return data;
  }
}

class ListItem {
  String? iD;
  String? title;
  String? listID;
  String? createdDate;
  String? modified;
  ListItemStatus? status;
  bool isEnabled = false;

  ListItem(
      {this.iD,
      this.title,
      this.createdDate,
      this.modified,
      this.status,
      this.listID});

  ListItem.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    title = json['Title'];
    createdDate = json['CreatedDate'];
    modified = json['Modified'];
    status = ListItemStatus.values[int.parse(json['State'])];
    listID = json['ListID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Title'] = this.title;
    data['CreatedDate'] = this.createdDate;
    data['Modified'] = this.modified;
    data['Status'] = this.status;
    data['ListID'] = this.listID;
    return data;
  }
}
