class Profile {
  final int id;
  final String email;
  final String username;
  final String mobile;
  final String address;
  final String? additionalNumber;
  final bool isActive;
  final bool isStaff;
  final bool isVerified;
  final String createdAt;
  final String updatedAt;

  Profile({
    required this.id,
    required this.email,
    required this.username,
    required this.mobile,
    required this.address,
    this.additionalNumber,
    required this.isActive,
    required this.isStaff,
    required this.isVerified,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      mobile: json['mobile'],
      address: json['address'],
      additionalNumber: json['additional_number'],
      isActive: json['is_active'],
      isStaff: json['is_staff'],
      isVerified: json['is_verified'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
