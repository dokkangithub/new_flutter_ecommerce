import 'package:flutter/material.dart';
import '../../../core/utils/local_storage/local_storage_keys.dart';
import '../../../core/utils/local_storage/secure_storage.dart';
import '../../../data/auth/models/auth_response_model.dart';
import '../../../domain/auth/usecases/auth/confirm_code_use_case.dart';
import '../../../domain/auth/usecases/auth/confirm_reset_password_use_case.dart';
import '../../../domain/auth/usecases/auth/forget_password_use_case.dart';
import '../../../domain/auth/usecases/auth/get_user_by_token_use_case.dart';
import '../../../domain/auth/usecases/auth/login_use_case.dart';
import '../../../domain/auth/usecases/auth/logout_use_case.dart';
import '../../../domain/auth/usecases/auth/resend_code_use_case.dart';
import '../../../domain/auth/usecases/auth/signup_use_case.dart';
import '../../../domain/auth/usecases/auth/social_login_use_case.dart';

class AuthProvider extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  final SignupUseCase signupUseCase;
  final SocialLoginUseCase socialLoginUseCase;
  final LogoutUseCase logoutUseCase;
  final ForgetPasswordUseCase forgetPasswordUseCase;
  final ConfirmResetPasswordUseCase confirmResetPasswordUseCase;
  final ResendCodeUseCase resendCodeUseCase;
  final ConfirmCodeUseCase confirmCodeUseCase;
  final GetUserByTokenUseCase getUserByTokenUseCase;

  AuthProvider({
    required this.loginUseCase,
    required this.signupUseCase,
    required this.socialLoginUseCase,
    required this.logoutUseCase,
    required this.forgetPasswordUseCase,
    required this.confirmResetPasswordUseCase,
    required this.resendCodeUseCase,
    required this.confirmCodeUseCase,
    required this.getUserByTokenUseCase,
  });

  bool _isLoading = false;
  AuthResponseModel? _user;

  bool get isLoading => _isLoading;
  AuthResponseModel? get user => _user;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _setLoading(true);
    try {
      _user = await loginUseCase(email, password);
      await SecureStorage().save(LocalStorageKey.userToken, _user!.accessToken!);
    } catch (e) {
      print("Login Error: $e");
    }
    _setLoading(false);
  }

  Future<void> signup(Map<String, dynamic> userData) async {
    _setLoading(true);
    try {
      final response = await signupUseCase(userData); // Response<dynamic>
      final responseData = response.data; // Extract the actual data

      if (responseData['result'] == true) {
        int userId = responseData['user_id'];
        print("User ID: $userId");

        // TODO: Store userId if needed (e.g., for verification step)
      }

      print("Signup Success: ${responseData['message']}");
      // TODO: Show success message & navigate to login if needed

    } catch (e) {
      print("Signup Error: $e");
    }
    _setLoading(false);
  }



  Future<void> socialLogin(String provider, String token) async {
    _setLoading(true);
    try {
      _user = await socialLoginUseCase(provider, token);
      await SecureStorage().save(LocalStorageKey.userToken, _user!.accessToken!);
    } catch (e) {
      print("Social Login Error: $e");
    }
    _setLoading(false);
  }

  Future<void> logout() async {
    _setLoading(true);
    try {
      await logoutUseCase();
      _user = null;
      await SecureStorage().deleteKey(LocalStorageKey.userToken);
    } catch (e) {
      print("Logout Error: $e");
    }
    _setLoading(false);
  }

  Future<void> forgetPassword(String email) async {
    _setLoading(true);
    try {
      await forgetPasswordUseCase(email);
    } catch (e) {
      print("Forget Password Error: $e");
    }
    _setLoading(false);
  }

  Future<void> confirmResetPassword(String email, String code, String password) async {
    _setLoading(true);
    try {
      await confirmResetPasswordUseCase(email, code, password);
    } catch (e) {
      print("Confirm Reset Password Error: $e");
    }
    _setLoading(false);
  }

  Future<void> resendCode(String email) async {
    _setLoading(true);
    try {
      await resendCodeUseCase(email);
    } catch (e) {
      print("Resend Code Error: $e");
    }
    _setLoading(false);
  }

  Future<void> confirmCode(String email, String code) async {
    _setLoading(true);
    try {
      await confirmCodeUseCase(email, code);
    } catch (e) {
      print("Confirm Code Error: $e");
    }
    _setLoading(false);
  }

  Future<void> getUserByToken() async {
    _setLoading(true);
    try {
      final token = await SecureStorage().get<String>(LocalStorageKey.userToken);
      if (token != null) {
        _user = await getUserByTokenUseCase(token);
      }
    } catch (e) {
      print("Get User By Token Error: $e");
    }
    _setLoading(false);
  }
}
