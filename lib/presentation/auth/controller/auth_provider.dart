import 'package:dio/dio.dart';
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
  String? _errorMessage;

  bool get isLoading => _isLoading;
  AuthResponseModel? get user => _user;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }


  Future<bool> login(String email, String password,String loginBy) async {
    _setLoading(true);
    bool isSuccess = false;
    try {
      _user = await loginUseCase(email, password,loginBy);
      if (_user != null && _user!.accessToken != null) {
        await SecureStorage().save(LocalStorageKey.userToken, _user!.accessToken!);
        isSuccess = true;
      }else if(_user!.result==false){
        _setErrorMessage(_user!.message[0]);
      }
    } catch (e) {
      print("Login Error: $e");
    }
    _setLoading(false);
    return isSuccess;
  }


  Future<void> signup(Map<String, dynamic> userData) async {
    _setLoading(true);
    try {
      Response response = await signupUseCase(userData);
      print('sssssdd${response.data}');
      if(response.data['result']){
        _user=response.data;
        await SecureStorage().save(LocalStorageKey.userToken, _user!.accessToken!);
        _setErrorMessage(_user!.message);
      }else {
        _setErrorMessage(response.data['message'][0]);
      }
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
