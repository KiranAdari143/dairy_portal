class Vaccination {
  int animalId;
  String vaccineName;
  String vaccineType;
  String vaccineDate;
  String dosage;

  Vaccination({
    required this.animalId,
    required this.vaccineName,
    required this.vaccineType,
    required this.vaccineDate,
    required this.dosage,
  });

  factory Vaccination.fromJson(Map<String, dynamic> json) => Vaccination(
        animalId: json["animal_id"],
        vaccineName: json["vaccine_name"],
        vaccineType: json["vaccine_type"],
        vaccineDate: json["vaccine_date"],
        dosage: json["dosage"],
      );

  Map<String, dynamic> toJson() => {
        "animal_id": animalId,
        "vaccine_name": vaccineName,
        "vaccine_type": vaccineType,
        "vaccine_date": vaccineDate,
        "dosage": dosage,
      };
}
