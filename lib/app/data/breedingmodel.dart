class Breedingmodel {
  String animalTagno;
  String inseminationType;
  String inseminationDate;
  String inseminationBreed;
  String semenType;
  String inseminationTechnician;
  String inseminationStatus;
  String technicianNotes;
  String pregnancyDate;
  String pregnancyStatus;
  String inseminationResult;

  Breedingmodel({
    required this.animalTagno,
    required this.inseminationType,
    required this.inseminationDate,
    required this.inseminationBreed,
    required this.semenType,
    required this.inseminationTechnician,
    required this.inseminationStatus,
    required this.technicianNotes,
    required this.pregnancyDate,
    required this.pregnancyStatus,
    required this.inseminationResult,
  });

  factory Breedingmodel.fromJson(Map<String, dynamic> json) => Breedingmodel(
        animalTagno: json["animal_tag_no"],
        inseminationType: json["insemination_type"],
        inseminationDate: json["insemination_date"],
        inseminationBreed: json["insemination_breed"],
        semenType: json["semen_type"],
        inseminationTechnician: json["insemination_technician"],
        inseminationStatus: json["insemination_status"],
        technicianNotes: json["technician_notes"],
        pregnancyDate: json["pregnancy_date"],
        pregnancyStatus: json["pregnancy_status"],
        inseminationResult: json["insemination_result"],
      );

  Map<String, dynamic> toJson() => {
        "animal_tag_no": animalTagno,
        "insemination_type": inseminationType,
        "insemination_date": inseminationDate,
        "insemination_breed": inseminationBreed,
        "semen_type": semenType,
        "insemination_technician": inseminationTechnician,
        "insemination_status": inseminationStatus,
        "technician_notes": technicianNotes,
        "pregnancy_date": pregnancyDate,
        "pregnancy_status": pregnancyStatus,
        "insemination_result": inseminationResult,
      };
}
