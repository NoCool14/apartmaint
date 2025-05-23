import 'package:cloud_firestore/cloud_firestore.dart';

/// The roles available in the system
enum UserRole {
  admin,
  landlord,
  tenant,
  employee,
  manager,
  handyman,
}

/// Extension on UserRole to provide helper methods
extension UserRoleExtension on UserRole {
  String get name {
    switch (this) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.landlord:
        return 'Landlord';
      case UserRole.tenant:
        return 'Tenant';
      case UserRole.employee:
        return 'Employee';
      case UserRole.manager:
        return 'Manager';
      case UserRole.handyman:
        return 'Handyman';
    }
  }

  String get value {
    return toString().split('.').last;
  }

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (role) => role.toString().split('.').last == value,
      orElse: () => UserRole.tenant,
    );
  }
}

/// User model representing a user in the system
class UserModel {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  String get displayName => '$firstName $lastName'.trim();
  final List<UserRole> roles;
  final bool approved;
  final String? phoneNumber;
  final String? employedBy;
  final String? stripeCustomerId;
  final String? profileImageUrl;
  final String? inviteCode;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? currentLeaseId;
  final String? currentUnitId;
  final String? currentPropertyId;
  final List<String>? fcmTokens;
  final bool isStaff;
  final List<String>? landlords;
  final Map<String, String>? landlordNames;
  final String? currentLandlordId;
  final List<String>? previousLandlords;

  const UserModel({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.roles,
    this.approved = false,
    this.phoneNumber,
    this.employedBy,
    this.stripeCustomerId,
    this.profileImageUrl,
    this.inviteCode,
    this.createdAt,
    this.updatedAt,
    this.currentLeaseId,
    this.currentUnitId,
    this.currentPropertyId,
    this.fcmTokens,
    this.isStaff = false,
    this.landlords,
    this.landlordNames,
    this.currentLandlordId,
    this.previousLandlords,
  });

  /// Full name of the user
  String get fullName => '$firstName $lastName';

  // Role check helpers
  bool hasRole(UserRole role) => roles.contains(role);
  bool get isAdmin => hasRole(UserRole.admin);
  bool get isLandlord => hasRole(UserRole.landlord);
  bool get isTenant => hasRole(UserRole.tenant);
  bool get isEmployee => hasRole(UserRole.employee);
  bool get isManager => hasRole(UserRole.manager);
  bool get isHandyman => hasRole(UserRole.handyman);

  String get primaryRoleDisplayName {
    if (roles.isEmpty) return 'Unknown';
    if (isAdmin) return UserRole.admin.name;
    if (isLandlord) return UserRole.landlord.name;
    if (isManager) return UserRole.manager.name;
    if (isEmployee) return UserRole.employee.name;
    if (isTenant) return UserRole.tenant.name;
    if (isHandyman) return UserRole.handyman.name;
    return roles.first.name;
  }

  /// Whether the user has completed setup
  bool get isSetUp => firstName.isNotEmpty && lastName.isNotEmpty;

  /// Create a copy of this UserModel with the given fields replaced
  UserModel copyWith({
    String? uid,
    String? email,
    String? firstName,
    String? lastName,
    List<UserRole>? roles,
    bool? approved,
    String? phoneNumber,
    String? employedBy,
    String? stripeCustomerId,
    String? profileImageUrl,
    String? inviteCode,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? currentLeaseId,
    String? currentUnitId,
    String? currentPropertyId,
    List<String>? fcmTokens,
    bool? isStaff,
    List<String>? landlords,
    Map<String, String>? landlordNames,
    String? currentLandlordId,
    List<String>? previousLandlords,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      roles: roles ?? this.roles,
      approved: approved ?? this.approved,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      employedBy: employedBy ?? this.employedBy,
      stripeCustomerId: stripeCustomerId ?? this.stripeCustomerId,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      inviteCode: inviteCode ?? this.inviteCode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      currentLeaseId: currentLeaseId ?? this.currentLeaseId,
      currentUnitId: currentUnitId ?? this.currentUnitId,
      currentPropertyId: currentPropertyId ?? this.currentPropertyId,
      fcmTokens: fcmTokens ?? this.fcmTokens,
      isStaff: isStaff ?? this.isStaff,
      landlords: landlords ?? this.landlords,
      landlordNames: landlordNames ?? this.landlordNames,
      currentLandlordId: currentLandlordId ?? this.currentLandlordId,
      previousLandlords: previousLandlords ?? this.previousLandlords,
    );
  }

  /// Factory constructor for creating a UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      roles: (json['roles'] as List<dynamic>?)
              ?.map((roleString) => UserRoleExtension.fromString(roleString as String))
              .toList() ??
          [UserRole.tenant],
      approved: json['approved'] as bool? ?? false,
      phoneNumber: json['phoneNumber'] as String?,
      employedBy: json['employedBy'] as String?,
      stripeCustomerId: json['stripeCustomerId'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      inviteCode: json['inviteCode'] as String?,
      currentLeaseId: json['currentLeaseId'] as String?,
      currentUnitId: json['currentUnitId'] as String?,
      currentPropertyId: json['currentPropertyId'] as String?,
      fcmTokens: (json['fcmTokens'] as List<dynamic>?)?.cast<String>(),
      isStaff: json['isStaff'] as bool? ?? false,
      landlords: (json['landlords'] as List<dynamic>?)?.cast<String>(),
      landlordNames: (json['landlordNames'] as Map<dynamic, dynamic>?)?.cast<String, String>(),
      currentLandlordId: json['currentLandlordId'] as String?,
      previousLandlords: (json['previousLandlords'] as List<dynamic>?)?.cast<String>(),
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
    );
  }

  /// Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'roles': roles.map((r) => r.value).toList(),
      'approved': approved,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (employedBy != null) 'employedBy': employedBy,
      if (stripeCustomerId != null) 'stripeCustomerId': stripeCustomerId,
      if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
      if (inviteCode != null) 'inviteCode': inviteCode,
      if (currentLeaseId != null) 'currentLeaseId': currentLeaseId,
      if (currentUnitId != null) 'currentUnitId': currentUnitId,
      if (currentPropertyId != null) 'currentPropertyId': currentPropertyId,
      if (fcmTokens != null) 'fcmTokens': fcmTokens,
      'isStaff': isStaff,
      if (landlords != null) 'landlords': landlords,
      if (landlordNames != null) 'landlordNames': landlordNames,
      if (currentLandlordId != null) 'currentLandlordId': currentLandlordId,
      if (previousLandlords != null) 'previousLandlords': previousLandlords,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  /// Factory constructor for creating a UserModel from Firestore DocumentSnapshot
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return UserModel(
      uid: doc.id,
      email: data['email'] as String? ?? '',
      firstName: data['firstName'] as String? ?? '',
      lastName: data['lastName'] as String? ?? '',
      roles: (data['roles'] as List<dynamic>?)
              ?.map((roleString) => UserRoleExtension.fromString(roleString as String))
              .toList() ??
          [UserRole.tenant],
      approved: data['approved'] as bool? ?? false,
      phoneNumber: data['phoneNumber'] as String?,
      employedBy: data['employedBy'] as String?,
      stripeCustomerId: data['stripeCustomerId'] as String?,
      profileImageUrl: data['profileImageUrl'] as String?,
      inviteCode: data['inviteCode'] as String?,
      currentLeaseId: data['currentLeaseId'] as String?,
      currentUnitId: data['currentUnitId'] as String?,
      currentPropertyId: data['currentPropertyId'] as String?,
      fcmTokens: (data['fcmTokens'] as List<dynamic>?)?.cast<String>(),
      isStaff: data['isStaff'] as bool? ?? false,
      landlords: (data['landlords'] as List<dynamic>?)?.cast<String>(),
      landlordNames: (data['landlordNames'] as Map<dynamic, dynamic>?)?.cast<String, String>(),
      currentLandlordId: data['currentLandlordId'] as String?,
      previousLandlords: (data['previousLandlords'] as List<dynamic>?)?.cast<String>(),
      createdAt: data['createdAt'] != null ? (data['createdAt'] as Timestamp).toDate() : null,
      updatedAt: data['updatedAt'] != null ? (data['updatedAt'] as Timestamp).toDate() : null,
    );
  }

  /// Converts the UserModel to a map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'roles': roles.map((r) => r.value).toList(),
      'approved': approved,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (employedBy != null) 'employedBy': employedBy,
      if (stripeCustomerId != null) 'stripeCustomerId': stripeCustomerId,
      if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
      if (inviteCode != null) 'inviteCode': inviteCode,
      if (currentLeaseId != null) 'currentLeaseId': currentLeaseId,
      if (currentUnitId != null) 'currentUnitId': currentUnitId,
      if (currentPropertyId != null) 'currentPropertyId': currentPropertyId,
      if (fcmTokens != null) 'fcmTokens': fcmTokens,
      'isStaff': isStaff,
      if (landlords != null) 'landlords': landlords,
      if (landlordNames != null) 'landlordNames': landlordNames,
      if (currentLandlordId != null) 'currentLandlordId': currentLandlordId,
      if (previousLandlords != null) 'previousLandlords': previousLandlords,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
