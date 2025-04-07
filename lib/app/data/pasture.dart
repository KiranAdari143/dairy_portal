class Pasture {
  String name;
  String category;
  String size;
  String leased;

  Pasture({
    required this.name,
    required this.category,
    required this.size,
    required this.leased,
  });

  factory Pasture.fromJson(Map<String, dynamic> json) => Pasture(
        name: json["name"],
        category: json["category"],
        size: json["size"],
        leased: json["leased"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "category": category,
        "size": size,
        "leased": leased,
      };
}
