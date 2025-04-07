class VaccineModel {
  final int Id;
  final int animalId;
  final String vaccineName;
  final String vaccineDate;
  final String vaccineType;
  final int dosage;

  VaccineModel({
    required this.Id,
    required this.animalId,
    required this.vaccineName,
    required this.vaccineType,
    required this.vaccineDate,
    required this.dosage,
  });

  factory VaccineModel.fromJson(Map<String, dynamic> json) {
    return VaccineModel(
      Id: json["id"],
      animalId: json["animal_id"] is int
          ? json["animal_id"]
          : int.tryParse(json["animal_id"].toString()) ?? 0,
      vaccineName: json["vaccine_name"]?.toString() ?? "",
      vaccineDate: json["vaccine_date"]?.toString() ?? "",
      vaccineType: json["vaccine_type"]?.toString() ?? "",
      dosage: json["dosage"] is int
          ? json["dosage"]
          : int.tryParse(json["dosage"].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": Id,
        "animal_id": animalId,
        "vaccine_name": vaccineName,
        "vaccine_date": vaccineDate,
        "vaccine_type": vaccineType,
        "dosage": dosage,
      };
}
