import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? phone;
  final String? profileImage;
  final String? classId;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone,
    this.profileImage,
    this.classId,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        role,
        phone,
        profileImage,
        classId,
      ];
}