import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sheba_ai/core/constants/api_constants.dart';
import 'package:sheba_ai/data/models/user_model.dart';

part 'auth_service.g.dart';

@RestApi()
abstract class AuthService {
  factory AuthService(Dio dio) = _AuthService;

  @POST(ApiConstants.register)
  Future<UserModel> register(@Body() RegisterRequest request);

  @POST(ApiConstants.login)
  Future<LoginResponse> login(@Body() LoginRequest request);

  @POST(ApiConstants.refresh)
  Future<LoginResponse> refreshToken(@Body() Map<String, String> refreshToken);

  @GET(ApiConstants.profile)
  Future<UserModel> getProfile();
}
