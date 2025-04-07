class MilkingData {
  final String animalTagNo;
  final String date;
  final String am;
  final String pm;
  final String total;

  MilkingData({
    required this.animalTagNo,
    required this.date,
    required this.am,
    required this.pm,
    required this.total,
  });

  factory MilkingData.fromJson(Map<String, dynamic> json) {
    return MilkingData(
      animalTagNo: json['animal_tag_no']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      am: json['am_quantity']?.toString() ?? '',
      pm: json['pm_quantity']?.toString() ?? '',
      total: json['total_quantity']?.toString() ?? '',
    );
  }
}
