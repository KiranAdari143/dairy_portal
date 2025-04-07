class Medicinemodel {
  int medicineId;
  String medicineName;
  dynamic medicineCost;
  String medicineDescription;
  String medicineDate;
  int animalId;
  String dosage;

  Medicinemodel({
    required this.medicineId,
    required this.medicineName,
    required this.medicineCost,
    required this.medicineDescription,
    required this.medicineDate,
    required this.animalId,
    required this.dosage,
  });

  factory Medicinemodel.fromJson(Map<String, dynamic> json) => Medicinemodel(
        medicineId: json["medicine_id"],
        medicineName: json["medicine_name"],
        medicineCost: json["medicine_cost"],
        medicineDescription: json["medicine_description"],
        medicineDate: json["medicine_date"],
        animalId: json["animal_id"],
        dosage: json["dosage"],
      );

  Map<String, dynamic> toJson() => {
        "medicine_id": medicineId,
        "medicine_name": medicineName,
        "medicine_cost": medicineCost,
        "medicine_description": medicineDescription,
        "medicine_date": medicineDate,
        "animal_id": animalId,
        "dosage": dosage,
      };
}
