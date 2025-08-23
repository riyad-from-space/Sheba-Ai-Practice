import 'package:sheba_ai/core/network/api_result.dart';
import 'package:sheba_ai/core/storage/secure_storage.dart';
import 'package:sheba_ai/data/models/user_model.dart';
import 'package:sheba_ai/data/services/auth_service.dart';

class AuthRepository{
  final AuthService _authService;

  AuthRepository(this._authService);
  Future<ApiResult<UserModel>> register(RegisterRequest request)async{
    try{
      final user = await _authService.register(request);
      return ApiResult.success(user);
    }
    catch(e){
      return ApiResult.failure(e.toString(),null);
    }
  }

  Future<ApiResult<LoginResponse>> login(LoginRequest request)async{
    try{
      final response = await _authService.login(request);
      await SecureStorage.saveTokens(accessToken: response.access,refreshToken: response.refresh

        
      );
      return ApiResult.success(response);
    }
    catch(e){
      return ApiResult.failure(e.toString(), null);

    }
  }
  Future<ApiResult<UserModel>> getProfile() async {
    try {
      final user = await _authService.getProfile();
      return ApiResult.success(user);
    } catch (e) {
      return ApiResult.failure(e.toString(), null);
    }
  }

  Future<void> logout() async {
    await SecureStorage.clearTokens();
  }

  Future<bool> isLoggedIn() async {
    final token = await SecureStorage.getAccessToken();
    return token != null;
  }
}