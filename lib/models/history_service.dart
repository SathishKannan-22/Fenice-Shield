class ServiceOrder {
  final int id;
  final User user;
  final Service service;
  final String serviceAddress;
  final String latitude;
  final String longitude;
  final String googleMapsLink;
  final String comments;
  final String serviceDate;
  final String serviceTime;
  final String status;
  final String createdAt;

  ServiceOrder({
    required this.id,
    required this.user,
    required this.service,
    required this.serviceAddress,
    required this.latitude,
    required this.longitude,
    required this.googleMapsLink,
    required this.comments,
    required this.serviceDate,
    required this.serviceTime,
    required this.status,
    required this.createdAt,
  });

  factory ServiceOrder.fromJson(Map<String, dynamic> json) {
    return ServiceOrder(
      id: json['id'],
      user: User.fromJson(json['user']),
      service: Service.fromJson(json['service']),
      serviceAddress: json['service_address'],
      latitude: json['latitude'] ?? '', // Handle nullable fields
      longitude: json['longitude'] ?? '', // Handle nullable fields
      googleMapsLink: json['google_maps_link'] ?? '', // Handle nullable fields
      comments: json['comments'],
      serviceDate: json['service_date'],
      serviceTime: json['service_time'],
      status: json['status'],
      createdAt: json['created_at'],
    );
  }
}

class User {
  final int id;
  final String username;
  final String email;
  final String mobileNumber;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.mobileNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      mobileNumber: json['mobile_number'],
    );
  }
}

class Service {
  final int id;
  final String name;

  Service({
    required this.id,
    required this.name,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      name: json['name'],
    );
  }
}
