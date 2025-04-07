class AnimalUpdateRequest {
  String animalId;
  String animalType;
  var age;
  String dob;
  String status;
  String lactationNo;
  String breedType;
  String gender;
  String lastPregnantDate;
  String expectedDeliveryDate;
  String? lastHeatDate;
  String lastInseminationDate;
  String? parentTagId;
  String vendorName;
  String? farmerId;
  String motherTag;
  String fatherTag;
  String weight;
  String milkingStatus;

  AnimalUpdateRequest({
    required this.animalId,
    required this.animalType,
    required this.age,
    required this.dob,
    required this.status,
    required this.lactationNo,
    required this.breedType,
    required this.gender,
    required this.lastPregnantDate,
    required this.expectedDeliveryDate,
    this.lastHeatDate,
    required this.lastInseminationDate,
    this.parentTagId,
    required this.vendorName,
    this.farmerId,
    required this.motherTag,
    required this.fatherTag,
    required this.weight,
    required this.milkingStatus,
  });

  Map<String, dynamic> toJson() {
    return {
      "animal_id": animalId,
      "animal_type": animalType,
      "age": age,
      "dob": dob,
      "status": status,
      "lactation_no": lactationNo,
      "breed_type": breedType,
      "gender": gender,
      "last_pregnant_date": lastPregnantDate,
      "expected_delivery_date": expectedDeliveryDate,
      "last_heat_date": lastHeatDate,
      "last_insemination_date": lastInseminationDate,
      "parent_tag_id": parentTagId,
      "vendor_name": vendorName,
      "farmer_id": farmerId,
      "mother_tag": motherTag,
      "father_tag": fatherTag,
      "weight": weight,
      "milking_status": milkingStatus,
    };
  }
}
