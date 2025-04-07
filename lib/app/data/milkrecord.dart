class MilkRecord {
  final String animalTagNo;
  final String type;
  final String? amQuantity;
  final String? pmQuantity;

  MilkRecord({
    required this.animalTagNo,
    required this.type,
    this.amQuantity,
    this.pmQuantity,
  });

  factory MilkRecord.fromJson(Map<String, dynamic> json) {
    return MilkRecord(
      animalTagNo: json['animal_tag_no'] as String,
      type: json['animal_type'] as String,
      amQuantity: json['total_am_quantity']?.toString(),
      pmQuantity: json['total_pm_quantity']?.toString(),
    );
  }
}
