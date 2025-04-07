class Pregnancy {
  String animalTagNo;
  String checkdate;
  String identificationtype;
  String diagnosticresult;
  String comments;
  String pregnancyscreening;

  Pregnancy({
    required this.animalTagNo,
    required this.checkdate,
    required this.identificationtype,
    required this.diagnosticresult,
    required this.pregnancyscreening,
    required this.comments,
  });

  factory Pregnancy.fromJson(Map<String, dynamic> json) => Pregnancy(
        animalTagNo: json["animal_tag_no"],
        checkdate: json["check_date"],
        identificationtype: json["identification_method"],
        diagnosticresult: json["diagnostic_result"],
        comments: json["comments"],
        pregnancyscreening: json["pregnancy_screening"],
      );

  Map<String, dynamic> toJson() => {
        "animal_tag_no": animalTagNo,
        "check_date": checkdate,
        "identification_method": identificationtype,
        "diagnostic_result": diagnosticresult,
        "comments": comments,
        "pregnancy_screening": pregnancyscreening,
      };
}
