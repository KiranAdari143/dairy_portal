class Breed {
  int inseminationId;
  String inseminationDate;
  String inseminationType;
  String? inseminatedBy;
  String pregnancyStatus;
  String? repeatCount;
  String? repeatDateCheck;
  String inseminationBreed;
  String semenType;
  String inseminationTechnician;
  String pregnancyDate;
  String inseminationResult;
  String technicianNotes;
  String inseminationStatus;
  String animalTagNo;

  Breed({
    required this.inseminationId,
    required this.inseminationDate,
    required this.inseminationType,
    required this.inseminatedBy,
    required this.pregnancyStatus,
    required this.repeatCount,
    required this.repeatDateCheck,
    required this.inseminationBreed,
    required this.semenType,
    required this.inseminationTechnician,
    required this.pregnancyDate,
    required this.inseminationResult,
    required this.technicianNotes,
    required this.inseminationStatus,
    required this.animalTagNo,
  });

  factory Breed.fromJson(Map<String, dynamic> json) => Breed(
        inseminationId: json["insemination_id"],
        inseminationDate: json["insemination_date"],
        inseminationType: json["insemination_type"],
        inseminatedBy: json["inseminated_by"],
        pregnancyStatus: json["pregnancy_status"],
        repeatCount: json["repeat_count"],
        repeatDateCheck: json["repeat_date_check"],
        inseminationBreed: json["insemination_breed"],
        semenType: json["semen_type"],
        inseminationTechnician: json["insemination_technician"],
        pregnancyDate: json["pregnancy_date"],
        inseminationResult: json["insemination_result"],
        technicianNotes: json["technician_notes"],
        inseminationStatus: json["insemination_status"],
        animalTagNo: json["animal_tag_no"],
      );

  Map<String, dynamic> toJson() => {
        "insemination_id": inseminationId,
        "insemination_date": inseminationDate,
        "insemination_type": inseminationType,
        "inseminated_by": inseminatedBy,
        "pregnancy_status": pregnancyStatus,
        "repeat_count": repeatCount,
        "repeat_date_check": repeatDateCheck,
        "insemination_breed": inseminationBreed,
        "semen_type": semenType,
        "insemination_technician": inseminationTechnician,
        "pregnancy_date": pregnancyDate,
        "insemination_result": inseminationResult,
        "technician_notes": technicianNotes,
        "insemination_status": inseminationStatus,
        "animal_tag_no": animalTagNo,
      };
}
