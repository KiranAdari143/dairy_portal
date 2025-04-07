class Employee {
  final int employeeId;
  final String employeeName;
  final int age;
  final String aadharcardNo;
  final String pancardNo;
  final String address;
  final String department;
  final int yearsOfExperience;
  final String joiningDate;
  final double salaryAmount;
  final String bankAccountDetails;
  final String gender;
  final String phone;
  final String emergencyNo;
  final String employeeType;
  final String jobRole;
  final String ifscCode;
  final String dateOfBirth;

  Employee({
    required this.employeeId,
    required this.employeeName,
    required this.age,
    required this.aadharcardNo,
    required this.pancardNo,
    required this.address,
    required this.department,
    required this.yearsOfExperience,
    required this.joiningDate,
    required this.salaryAmount,
    required this.bankAccountDetails,
    required this.gender,
    required this.phone,
    required this.emergencyNo,
    required this.employeeType,
    required this.jobRole,
    required this.ifscCode,
    required this.dateOfBirth,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      employeeId: json['employee_id'],
      employeeName: json['employee_name'],
      age: json['age'],
      aadharcardNo: json['aadharcard_no'],
      pancardNo: json['pancard_no'],
      address: json['address'],
      department: json['department'],
      yearsOfExperience: json['years_of_experience'],
      joiningDate: json['joining_date'],
      salaryAmount: double.parse(json['salary_amount']),
      bankAccountDetails: json['bank_account_details'],
      gender: json['gender'] ?? '',
      phone: json['phone'] ?? '',
      emergencyNo: json['emergency_no'] ?? '',
      employeeType: json['employee_type'] ?? '',
      jobRole: json['job_role'] ?? '',
      ifscCode: json['ifsc_code'] ?? '',
      dateOfBirth: json['date_of_birth'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employee_id': employeeId,
      'employee_name': employeeName,
      'age': age,
      'aadharcard_no': aadharcardNo,
      'pancard_no': pancardNo,
      'address': address,
      'department': department,
      'years_of_experience': yearsOfExperience,
      'joining_date': joiningDate,
      'salary_amount': salaryAmount.toString(),
      'bank_account_details': bankAccountDetails,
      'gender': gender,
      'phone': phone,
      'emergency_no': emergencyNo,
      'employee_type': employeeType,
      'job_role': jobRole,
      'ifsc_code': ifscCode,
      'date_of_birth': dateOfBirth,
    };
  }
}
