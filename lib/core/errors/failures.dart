
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure({required this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

class ServerFailure extends Failure {
  const ServerFailure(String message, {int? statusCode})
      : super(message: message, statusCode: statusCode);
}

class NetworkFailure extends Failure {
  const NetworkFailure() : super(message: 'لا يوجد اتصال بالإنترنت');
}

class TimeoutFailure extends Failure {
  const TimeoutFailure() : super(message: 'انتهت مهلة الاتصال');
}

class CacheFailure extends Failure {
  const CacheFailure() : super(message: 'خطأ في التخزين المحلي');
}

class UnknownFailure extends Failure {
  const UnknownFailure() : super(message: 'حدث خطأ غير متوقع');
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure() : super(message: 'ليس لديك صلاحية للوصول');
}

class ForbiddenFailure extends Failure {
  const ForbiddenFailure() : super(message: 'ممنوع الوصول');
}

class NotFoundFailure extends Failure {
  const NotFoundFailure() : super(message: 'المورد غير موجود');
}
