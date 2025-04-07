// models.dart

class Animalupdate {
  int statusCode;
  String message;
  List<Detail> details;
  String ipAddress;

  Animalupdate({
    required this.statusCode,
    required this.message,
    required this.details,
    required this.ipAddress,
  });

  factory Animalupdate.fromJson(Map<String, dynamic> json) => Animalupdate(
        statusCode: json["statusCode"],
        message: json["message"],
        details:
            List<Detail>.from(json["details"].map((x) => Detail.fromJson(x))),
        ipAddress: json["ipAddress"],
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "message": message,
        "details": List<dynamic>.from(details.map((x) => x.toJson())),
        "ipAddress": ipAddress,
      };
}

class Detail {
  int groupId;
  String groupName;
  int? employeeId;
  String? employeeName;
  List<Animal> animals;

  Detail({
    required this.groupId,
    required this.groupName,
    required this.employeeId,
    required this.employeeName,
    required this.animals,
  });

  factory Detail.fromJson(Map<String, dynamic> json) {
    final int groupId = json["group_id"];
    // Parse the animals list.
    final animalsList = List<Animal>.from(
      json["animals"].map((x) => Animal.fromJson(x)),
    );
    // Assign this groupId to each animal.
    for (var animal in animalsList) {
      animal.groupId = groupId;
    }
    return Detail(
      groupId: groupId,
      groupName: json["group_name"],
      employeeId: json["employee_id"],
      employeeName: json["employee_name"],
      animals: animalsList,
    );
  }

  Map<String, dynamic> toJson() => {
        "group_id": groupId,
        "group_name": groupName,
        "employee_id": employeeId,
        "employee_name": employeeName,
        "animals": List<dynamic>.from(animals.map((x) => x.toJson())),
      };
}

class Animal {
  int? id;
  String? name;
  String? tagNo;
  int? groupId; // NEW FIELD: holds the original group ID

  Animal({
    this.id,
    this.name,
    this.tagNo,
    this.groupId,
  });

  factory Animal.fromJson(Map<String, dynamic> json) => Animal(
        id: json["id"],
        name: json["name"],
        tagNo: json["tag_no"],
        // groupId will be set in Detail.fromJson
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "tag_no": tagNo,
        // Optionally add "group_id": groupId if needed by your API.
      };
}
