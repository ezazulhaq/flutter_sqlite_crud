class Contact {
  int id;
  String name;
  String mobile;

  Contact({
    this.id,
    this.name,
    this.mobile,
  });

  static const tblContacts = "contacts";
  static const colId = "id";
  static const colName = "name";
  static const colMobile = "mobile";

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      colName: name,
      colMobile: mobile,
    };

    if (id != null) {
      map[colId] = id;
    }

    return map;
  }

  Contact.fromMap(Map map) {
    id = map[colId];
    name = map[colName];
    mobile = map[colMobile];
  }
}
