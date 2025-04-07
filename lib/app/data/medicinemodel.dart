class MedicineModel {
  final int animalId;
  final String medicineName;
  final String medicineDescription;
  final String medicineDate;
  final int medicineCost;
  final int dosage;

  MedicineModel({
    required this.animalId,
    required this.medicineName,
    required this.medicineDescription,
    required this.medicineDate,
    required this.medicineCost,
    required this.dosage,
  });

  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    return MedicineModel(
      animalId: json["animal_id"] is int
          ? json["animal_id"]
          : int.tryParse(json["animal_id"].toString()) ?? 0,
      medicineName: json["medicine_name"]?.toString() ?? "",
      medicineDescription: json["medicine_description"]?.toString() ?? "",
      medicineDate: json["medicine_date"]?.toString() ?? "",
      medicineCost: json["medicine_cost"] is int
          ? json["medicine_cost"]
          : int.tryParse(json["medicine_cost"].toString()) ?? 0,
      dosage: json["dosage"] is int
          ? json["dosage"]
          : int.tryParse(json["dosage"].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "animal_id": animalId,
        "medicine_name": medicineName,
        "medicine_description": medicineDescription,
        "medicine_date": medicineDate,
        "medicine_cost": medicineCost,
        "dosage": dosage,
      };
}
