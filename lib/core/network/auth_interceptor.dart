import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheba_ai/core/constants/api_constants.dart';
import 'package:sheba_ai/core/storage/secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final Ref ref;

  AuthInterceptor(this.ref);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await SecureStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refreshToken = await SecureStorage.getRefreshToken();
      if (refreshToken != null) {
        try {
          final dio = Dio();
          final response = await dio.post(
            ApiConstants.refresh,
            data: {'refresh': refreshToken},
          );

          if (response.statusCode == 200 && response.data['access'] != null) {
            final newAccessToken = response.data['access'];
            await SecureStorage.saveTokens(
              accessToken: newAccessToken,
              refreshToken: refreshToken,
            );

            final opts = err.requestOptions;
            opts.headers['Authorization'] = 'Bearer $newAccessToken';
            final cloneReq = await dio.fetch(opts);
            return handler.resolve(cloneReq);
          } else {
            await SecureStorage.clearTokens();
            //navigate to login screen
            return handler.next(err);
          }
        } catch (e) {
          await SecureStorage.clearTokens();
          //navigate to login screen
          return handler.next(err);
        }
      }
    }
    handler.next(err);
  }
}
