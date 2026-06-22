import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants/hive_constants.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheToken(String token);
  Future<String?> getCachedToken();
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearCache();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final Box userBox;

  AuthLocalDataSourceImpl(this.userBox);

  @override
  Future<void> cacheToken(String token) async {
    await userBox.put(HiveConstants.tokenKey, token);
  }

  @override
  Future<String?> getCachedToken() async {
    return userBox.get(HiveConstants.tokenKey);
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    await userBox.put(HiveConstants.userDataKey, user.toJson());
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final userData = userBox.get(HiveConstants.userDataKey);
    if (userData != null) {
      return UserModel.fromJson(Map<String, dynamic>.from(userData));
    }
    return null;
  }

  @override
  Future<void> clearCache() async {
    await userBox.delete(HiveConstants.tokenKey);
    await userBox.delete(HiveConstants.userDataKey);
  }
}