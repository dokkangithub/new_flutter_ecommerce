import '../../../../core/api/api_provider.dart';
import '../../../../core/utils/constants/app_strings.dart';
import '../models/profile_counters_model.dart';
import '../models/profile_update_response.dart';
import '../models/user_profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfileModel> getUserProfile();
  Future<ProfileCountersModel> getProfileCounters();
  Future<ProfileUpdateResponse> updateProfile(String userId, String name, String password);
  Future<ProfileUpdateResponse> updateProfileImage(String userId, String filename, String base64Image);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiProvider apiProvider;

  ProfileRemoteDataSourceImpl(this.apiProvider);

  @override
  Future<UserProfileModel> getUserProfile() async {
    try {
      final response = await apiProvider.get('/profile/${AppStrings.userId}');
      return UserProfileModel.fromJson(response.data['data'] ?? {});
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  @override
  Future<ProfileCountersModel> getProfileCounters() async {
    try {
      final response = await apiProvider.get('/profile/counters');
      return ProfileCountersModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to get profile counters: $e');
    }
  }

  @override
  Future<ProfileUpdateResponse> updateProfile(String userId, String name, String password) async {
    try {
      final Map<String, dynamic> data = {
        'id': userId,
        'name': name,
        'password': password,
      };
      
      final response = await apiProvider.post('/profile/update', data: data);
      return ProfileUpdateResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  @override
  Future<ProfileUpdateResponse> updateProfileImage(String userId, String filename, String base64Image) async {
    try {
      final Map<String, dynamic> data = {
        'id': userId,
        'filename': filename,
        'image': base64Image,
      };
      
      final response = await apiProvider.post('/profile/update-image', data: data);
      return ProfileUpdateResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update profile image: $e');
    }
  }
}
