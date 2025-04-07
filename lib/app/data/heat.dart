class Heat {
  String animalTagNo;
  String heatDate;
  String heatTime;
  String observedBy;
  String score;
  String heatIdentificationDate;
  String comments;

  Heat({
    required this.animalTagNo,
    required this.heatDate,
    required this.heatTime,
    required this.observedBy,
    required this.score,
    required this.heatIdentificationDate,
    required this.comments,
  });

  factory Heat.fromJson(Map<String, dynamic> json) => Heat(
        animalTagNo: json["animal_tag_no"],
        heatDate: json["heat_date"],
        heatTime: json["heat_time"],
        observedBy: json["observed_by"],
        score: json["score"],
        heatIdentificationDate: json["heat_identification_date"],
        comments: json["comments"],
      );

  Map<String, dynamic> toJson() => {
        "animal_tag_no": animalTagNo,
        "heat_date": heatDate,
        "heat_time": heatTime,
        "observed_by": observedBy,
        "score": score,
        "heat_identification_date": heatIdentificationDate,
        "comments": comments,
      };
}
