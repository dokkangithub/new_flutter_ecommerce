import 'package:flutter/material.dart';
import 'package:laravel_ecommerce/core/utils/extension/text_style_extension.dart';
import 'package:laravel_ecommerce/core/utils/widgets/custom_form_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Profile Picture Section
            _imageSection(),
            const SizedBox(height: 24),
            // Form Fields
            _formFields(context),
          ],
        ),
      ),
    );
  }

  Widget _imageSection(){
    return  Center(
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
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
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(
                'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/image-1on4aUt2uycsEs8NVAzaIf1WOBctRD.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Emmanuel Oyiboke',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              'Change Profile Picture',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _formFields(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('first name',style: context.titleMedium),
          CustomTextFormField(controller: _firstNameController,hint: 'First Name',isReadOnly: true,),
          const SizedBox(height: 16),
          Text('Last Name',style: context.titleMedium),
          CustomTextFormField(controller: _lastNameController,hint: 'Last Name',isReadOnly: true,),
          const SizedBox(height: 16),
          Text('phone',style: context.titleMedium),
          CustomTextFormField(controller: _lastNameController,hint: 'phone',isReadOnly: true,),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}

