import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../core/config/themes.dart/theme.dart';
import '../../../../core/utils/constants/app_strings.dart';
import '../../../../core/utils/enums/loading_state.dart';
import '../../../../core/utils/local_storage/local_storage_keys.dart';
import '../../../../core/utils/local_storage/secure_storage.dart';
import '../../../../core/utils/widgets/custom_button.dart';
import '../../../../core/utils/widgets/custom_form_field.dart';
import '../controller/profile_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    // Set the name controller text directly from AppStrings
    _nameController.text = AppStrings.userName ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('تعديل الملف الشخصي'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileImagePicker(context, profileProvider),
              const SizedBox(height: 24),
              _buildFormFields(context),
              const SizedBox(height: 32),
              _buildUpdateButton(context, profileProvider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImagePicker(BuildContext context, ProfileProvider profileProvider) {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
                color: AppTheme.accentColor.withOpacity(0.2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: _selectedImage != null
                    ? Image.file(
                  _selectedImage!,
                  fit: BoxFit.cover,
                )
                    : profileProvider.profileImageUrl != null
                    ? Image.network(
                  profileProvider.profileImageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.grey,
                  ),
                )
                    : const Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: _pickImage,
            child: const Text(
              'تغيير الصورة',
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormFields(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('الاسم', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        CustomTextFormField(
          controller: _nameController,
          hint: 'أدخل اسمك',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'الرجاء إدخال الاسم';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        const Text('كلمة المرور الجديدة', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        CustomTextFormField(
          controller: _passwordController,
          hint: 'أدخل كلمة المرور الجديدة',
          isPassword: true,
          validator: (value) {
            if (value != null && value.isNotEmpty && value.length < 6) {
              return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        const Text('تأكيد كلمة المرور', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        CustomTextFormField(
          controller: _confirmPasswordController,
          hint: 'أعد إدخال كلمة المرور الجديدة',
          isPassword: true,
          validator: (value) {
            if (_passwordController.text.isNotEmpty && value != _passwordController.text) {
              return 'كلمات المرور غير متطابقة';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildUpdateButton(BuildContext context, ProfileProvider profileProvider) {
    return SizedBox(
      width: double.infinity,
      child: CustomButton(
        onPressed: () => _updateProfile(context, profileProvider),
        text: 'تحديث الملف الشخصي',
        isLoading: profileProvider.updateState == LoadingState.loading,
      ),
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _updateProfile(BuildContext context, ProfileProvider profileProvider) async {
    if (!_formKey.currentState!.validate()) return;

    // Update profile image if selected
    if (_selectedImage != null) {
      final success = await profileProvider.updateProfileImage(_selectedImage!);
      if (!success) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('فشل تحديث صورة الملف الشخصي')),
        );
        return;
      }
    }

    // Update profile info if name or password is provided
    if (_nameController.text.isNotEmpty || _passwordController.text.isNotEmpty) {
      final success = await profileProvider.updateProfile(
        _nameController.text,
        _passwordController.text,
      );

      if (!mounted) return;

      if (success) {
        if (_nameController.text != AppStrings.userName) {
          AppStrings.userName = _nameController.text;
          await SecureStorage().save(LocalStorageKey.userName, _nameController.text);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تحديث الملف الشخصي بنجاح')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('فشل تحديث الملف الشخصي')),
        );
      }
    }
    else if (_selectedImage != null) {
      // If only image was updated and it was successful
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تحديث صورة الملف الشخصي بنجاح')),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}