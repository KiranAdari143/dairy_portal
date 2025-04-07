class Vaccin {
  int animalId;
  String vaccineName;
  String vaccineType;
  String vaccineDate;
  String dosage;

  Vaccin({
    required this.animalId,
    required this.vaccineName,
    required this.vaccineType,
    required this.vaccineDate,
    required this.dosage,
  });

  factory Vaccin.fromJson(Map<String, dynamic> json) => Vaccin(
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
