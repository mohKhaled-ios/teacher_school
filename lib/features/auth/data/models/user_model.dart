import 'package:hive/hive.dart';
import '../../../../core/constants/hive_constants.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

@HiveType(typeId: HiveConstants.userTypeId)
class UserModel extends User {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String role;

  @HiveField(4)
  final String? phone;

  @HiveField(5)
  final String? profileImage;

  @HiveField(6)
  final String? classId;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone,
    this.profileImage,
    this.classId,
  }) : super(
          id: id,
          name: name,
          email: email,
          role: role,
          phone: phone,
          profileImage: profileImage,
          classId: classId,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      phone: json['phone'],
      profileImage: json['profileImage'],
      classId: json['classId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'phone': phone,
      'profileImage': profileImage,
      'classId': classId,
    };
  }

  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
      role: role,
      phone: phone,
      profileImage: profileImage,
      classId: classId,
    );
  }
  }