class PregnancyModel {
  int Id;
  String animalTagNo;
  String checkdate;
  String identificationtype;
  String diagnosticresult;
  String comments;
  String pregnancyscreening;

  PregnancyModel({
    required this.Id,
    required this.animalTagNo,
    required this.checkdate,
    required this.identificationtype,
    required this.diagnosticresult,
    required this.pregnancyscreening,
    required this.comments,
  });

  factory PregnancyModel.fromJson(Map<String, dynamic> json) => PregnancyModel(
        Id: json["id"] is int
            ? json["id"]
            : int.tryParse(json["id"].toString()) ?? 0,
        animalTagNo: json["animal_tag_no"]?.toString() ?? "",
        checkdate: json["check_date"]?.toString() ?? "",
        identificationtype: json["identification_method"]?.toString() ?? "",
        diagnosticresult: json["diagnostic_result"]?.toString() ?? "",
        comments: json["comments"]?.toString() ?? "",
        // Use the correct key from the API ("parental_screening")
        pregnancyscreening: json["parental_screening"]?.toString() ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": Id,
        "animal_tag_no": animalTagNo,
        "check_date": checkdate,
        "identification_method": identificationtype,
        "diagnostic_result": diagnosticresult,
        "comments": comments,
        "parental_screening": pregnancyscreening,
      };
}
