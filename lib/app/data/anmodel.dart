class AnimalModel {
  final int? animalId;
  final String? animalType;
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
  final String? currentCalfId;
  final String? lastHeatDate;
  final String? lastInseminationDate;
  final String? parentTagId;
  final String? vendorName;
  final String? farmId;
  final String? motherTag;
  final String? fatherTag;
  final int? weight;
  final String? milkingStatus;
  final String? createdAt;
  final String? updatedAt;

  AnimalModel({
    this.animalId,
    this.animalType,
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
    this.createdAt,
    this.updatedAt,
  });

  factory AnimalModel.fromJson(Map<String, dynamic> json) {
    return AnimalModel(
      animalId: json['animal_id'] as int?,
      animalType: json['animal_type']?.toString(),
      tagNo: json['tag_no'] != null ? json['tag_no'].toString() : null,
      age: json['age']?.toString(), // Convert to string if needed.
      dob: json['dob']?.toString(),
      status: json['status']?.toString(),
      lactationNo: json['lactation_no'] as int?, // if it's an int
      breedType: json['breed_type']?.toString(),
      gender: json['gender']?.toString(),
      imagePath: json['image_path']?.toString(),
      lastPregnantDate: json['last_pregnant_date']?.toString(),
      expectedDeliveryDate: json['expected_delivery_date']?.toString(),
      currentCalfId: json['current_calf_id'] as String?, // if int
      lastHeatDate: json['last_heat_date']?.toString(),
      lastInseminationDate: json['last_insemination_date']?.toString(),
      parentTagId: json['parent_tag_id'] as String?, // if int
      vendorName: json['vendor_name']?.toString(),
      farmId: json['farm_id'] != null ? json['farm_id'].toString() : null,
      motherTag:
          json['mother_tag'] != null ? json['mother_tag'].toString() : null,
      fatherTag:
          json['father_tag'] != null ? json['father_tag'].toString() : null,
      weight: json['weight'] as int?, // if weight is int
      milkingStatus: json['milking_status']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }
}
