class AnimalRegisterRequest {
  final String animalType;
  final String tagNo;
  final String dob;
  final String status;
  final String lactationNo;
  final String breedType;
  final String gender;
  final String lastPregnantDate;
  final String expectedDeliveryDate;
  final String lastInseminationDate;
  final String vendorName;
  final String motherTag;
  final String fatherTag;
  final String weight;
  final String milkingStatus;
  final String farmid;

  AnimalRegisterRequest({
    required this.animalType,
    required this.tagNo,
    required this.dob,
    required this.status,
    required this.lactationNo,
    required this.breedType,
    required this.gender,
    required this.lastPregnantDate,
    required this.expectedDeliveryDate,
    required this.lastInseminationDate,
    required this.vendorName,
    required this.farmid,
    required this.motherTag,
    required this.fatherTag,
    required this.weight,
    required this.milkingStatus,
  });

  Map<String, dynamic> toJson() {
    return {
      "animal_type": animalType,
      "tag_no": tagNo,
      "dob": dob,
      "status": status,
      "lactation_no": lactationNo,
      "breed_type": breedType,
      "gender": gender,
      "last_pregnant_date": lastPregnantDate,
      "expected_delivery_date": expectedDeliveryDate,
      "last_insemination_date": lastInseminationDate,
      "vendor_name": vendorName,
      "farm_id": farmid,
      "mother_tag": motherTag,
      "father_tag": fatherTag,
      "weight": weight,
      "milking_status": milkingStatus,
    };
  }
}
