import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponse> login(String email, String password);
  Future<UserModel> getMe();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl(this.apiClient);

  @override
  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await apiClient.login({
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = response.data;
        return LoginResponse(
          token: data['token'],
          user: UserModel.fromJson(data['user']),
        );
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'فشل تسجيل الدخول',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> getMe() async {
    try {
      final response = await apiClient.getMe();

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'فشل جلب بيانات المستخدم',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}

class LoginResponse {
  final String token;
  final UserModel user;

  LoginResponse({
    required this.token,
    required this.user,
  });
}