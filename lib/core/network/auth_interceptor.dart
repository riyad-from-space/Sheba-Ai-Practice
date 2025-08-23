
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheba_ai/core/storage/secure_storage.dart';


class AuthInterceptor extends Interceptor {
  final Ref ref;

  AuthInterceptor(this.ref);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await SecureStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Token expired, try to refresh
      final refreshToken = await SecureStorage.getRefreshToken();
      if (refreshToken != null) {
        try {
          // Implement token refresh logic here
          // If refresh succeeds, retry the original request
          // If refresh fails, redirect to login
        } catch (e) {
          await SecureStorage.clearTokens();
          // Navigate to login screen
        }
      }
    }
    handler.next(err);
  }
}