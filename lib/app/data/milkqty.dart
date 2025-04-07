class Milkqty {
  final String animalTagNo;
  final DateTime? date;
  final String? amQuantity;
  final String? pmQuantity;

  Milkqty({
    required this.animalTagNo,
    this.date,
    this.amQuantity,
    this.pmQuantity,
  });

  factory Milkqty.fromJson(Map<String, dynamic> json) {
    final dateString = json['date']?.toString();
    return Milkqty(
      animalTagNo: (json['animal_tag_no'] ?? "").toString(),
      date: dateString != null ? DateTime.parse(dateString) : null,
      amQuantity: json['am_quantity']?.toString(),
      pmQuantity: json['pm_quantity']?.toString(),
    );
  }

  @override
  String toString() {
    return 'Milkqty(animalTagNo: $animalTagNo, date: $date, amQuantity: $amQuantity, pmQuantity: $pmQuantity)';
  }
}
