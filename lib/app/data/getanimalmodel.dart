class Animal {
  final int animalId;
  final String animalType;
  final String? tagNo;
  final String? age;
  final String? dob;
  final String? status;
  final int? lactationNo;
  final String? breedType;
  final String? gender;
  final String? imagePath;
  final String? lastPregnantDate;
  final String? expectedDeliveryDate;
  final int? currentCalfId;
  final String? lastHeatDate;
  final String? lastInseminationDate;
  final String? parentTagId;
  final String? vendorName;
  final int? farmId;
  final String? motherTag;
  final String? fatherTag;
  final int? weight;
  final String? milkingStatus;

  Animal({
    required this.animalId,
    required this.animalType,
    this.tagNo,
    this.age,
    this.dob,
    this.status,
    this.lactationNo,
    this.breedType,
    this.gender,
    this.imagePath,
    this.lastPregnantDate,
    this.expectedDeliveryDate,
    this.currentCalfId,
    this.lastHeatDate,
    this.lastInseminationDate,
    this.parentTagId,
    this.vendorName,
    this.farmId,
    this.motherTag,
    this.fatherTag,
    this.weight,
    this.milkingStatus,
  });

  factory Animal.fromJson(Map<String, dynamic> json) {
    print('Processing animal with tag_no: ${json['tag_no']}');
    print('Animal Type from JSON: ${json['animal_type']}');
    return Animal(
      animalId: json['animal_id'] ?? 0, // default to 0 if null
      animalType: json['animal_type'] ?? 'Unknown', // default value
      tagNo: json['tag_no'],
      age: json['age'],
      dob: json['dob'],
      status: json['status'],
      lactationNo: json['lactation_no'] ?? 0,
      breedType: json['breed_type'],
      gender: json['gender'],
      imagePath: json['image_path'],
      lastPregnantDate: json['last_pregnant_date'],
      expectedDeliveryDate: json['expected_delivery_date'],
      currentCalfId: json['current_calf_id'],
      lastHeatDate: json['last_heat_date'],
      lastInseminationDate: json['last_insemination_date'],
      parentTagId: json['parent_tag_id'],
      vendorName: json['vendor_name'],
      farmId: json['farm_id'] ?? 0,
      motherTag: json['mother_tag'],
      fatherTag: json['father_tag'],
      weight: json['weight'] ?? 0,
      milkingStatus: json['milking_status'],
    );
  }
}
