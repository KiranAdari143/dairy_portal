class PastureModel {
  int pastureId;
  String? name;
  String? category;
  String? size;
  String? leased;

  PastureModel({
    required this.pastureId,
    required this.name,
    required this.category,
    required this.size,
    required this.leased,
  });

  factory PastureModel.fromJson(Map<String, dynamic> json) => PastureModel(
        pastureId: json["pasture_id"],
        name: json["name"],
        category: json["category"],
        size: json["size"],
        leased: json["leased"],
      );

  Map<String, dynamic> toJson() => {
        "pasture_id": pastureId,
        "name": name,
        "category": category,
        "size": size,
        "leased": leased,
      };
}
