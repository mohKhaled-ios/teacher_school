
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final AuthRepository authRepository;

  AuthCubit({
    required this.loginUseCase,
    required this.authRepository,
  }) : super(AuthInitial());

  Future<void> checkAuthStatus() async {
    emit(AuthLoading());

    try {
      final token = await authRepository.getCachedToken();
      final user = await authRepository.getCachedUser();

      if (token != null && token.isNotEmpty && user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    try {
      final result = await loginUseCase(
        LoginParams(email: email, password: password),
      );

      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (user) => emit(AuthAuthenticated(user)),
      );
    } catch (e) {
      emit(AuthError('حدث خطأ أثناء تسجيل الدخول'));
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());

    try {
      final result = await authRepository.logout();

      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (_) => emit(AuthUnauthenticated()),
      );
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> refreshUser() async {
    try {
      final result = await authRepository.getMe();

      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (user) => emit(AuthAuthenticated(user)),
      );
    } catch (e) {
      // تجاهل الخطأ في حالة عدم القدرة على تحديث البيانات
    }
  }
}
