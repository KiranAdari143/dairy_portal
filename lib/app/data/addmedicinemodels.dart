class Medicine {
  int animalId;
  String medicineName;
  String medicineDescription;
  String startDate;
  String endDate;
  String medicineType;

  Medicine({
    required this.animalId,
    required this.medicineName,
    required this.medicineDescription,
    required this.startDate,
    required this.endDate,
    required this.medicineType,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) => Medicine(
        animalId: json["animal_id"],
        medicineName: json["medicine_name"],
        medicineDescription: json["medicine_description"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        medicineType: json["medicine_type"],
      );

  Map<String, dynamic> toJson() => {
        "animal_id": animalId,
        "medicine_name": medicineName,
        "medicine_description": medicineDescription,
        "start_date": startDate,
        "end_date": endDate,
        "medicine_type": medicineType,
      };
}
