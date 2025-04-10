import 'package:flutter/material.dart';
import '../../../../core/utils/widgets/custom_form_field.dart';
import '../../../../core/utils/widgets/custom_dropdown.dart';

class AddressFormFields extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController addressController;
  final TextEditingController postalCodeController;
  final TextEditingController phoneController;
  
  final int? selectedCountryId;
  final int? selectedStateId;
  final int? selectedCityId;
  
  final List<Map<String, dynamic>> countries;
  final List<Map<String, dynamic>> states;
  final List<Map<String, dynamic>> cities;
  
  final Function(int?) onCountryChanged;
  final Function(int?) onStateChanged;
  final Function(int?) onCityChanged;
  
  final bool isLoading;

  const AddressFormFields({
    Key? key,
    required this.titleController,
    required this.addressController,
    required this.postalCodeController,
    required this.phoneController,
    this.selectedCountryId,
    this.selectedStateId,
    this.selectedCityId,
    required this.countries,
    required this.states,
    required this.cities,
    required this.onCountryChanged,
    required this.onStateChanged,
    required this.onCityChanged,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Title field
        CustomTextFormField(
          controller: titleController,
          label: 'Address Title',
          hint: 'e.g. Home, Office',
          prefixIcon: const Icon(Icons.title),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a title';
            }
            return null;
          },
        ),
        
        // Country dropdown
        CustomDropdown<int>(
          label: 'Country',
          hint: 'Select Country',
          value: selectedCountryId,
          prefixIcon: const Icon(Icons.public),
          items: countries.map((country) {
            return DropdownMenuItem<int>(
              value: country['id'] as int,
              child: Text(country['name'] as String),
            );
          }).toList(),
          onChanged: onCountryChanged,
          isLoading: isLoading,
          validator: (value) {
            if (value == null) {
              return 'Please select a country';
            }
            return null;
          },
        ),
        
        // State dropdown
        CustomDropdown<int>(
          label: 'State/Province',
          hint: 'Select State/Province',
          value: selectedStateId,
          prefixIcon: const Icon(Icons.map),
          items: states.map((state) {
            return DropdownMenuItem<int>(
              value: state['id'] as int,
              child: Text(state['name'] as String),
            );
          }).toList(),
          onChanged: onStateChanged,
          isLoading: isLoading,
          validator: (value) {
            if (value == null) {
              return 'Please select a state';
            }
            return null;
          },
        ),
        
        // City dropdown
        CustomDropdown<int>(
          label: 'City',
          hint: 'Select City',
          value: selectedCityId,
          prefixIcon: const Icon(Icons.location_city),
          items: cities.map((city) {
            return DropdownMenuItem<int>(
              value: city['id'] as int,
              child: Text(city['name'] as String),
            );
          }).toList(),
          onChanged: onCityChanged,
          isLoading: isLoading,
          validator: (value) {
            if (value == null) {
              return 'Please select a city';
            }
            return null;
          },
        ),
        
        // Address field
        CustomTextFormField(
          controller: addressController,
          label: 'Address',
          hint: 'Street address, building, etc.',
          prefixIcon: const Icon(Icons.home),
          maxLines: 3,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an address';
            }
            return null;
          },
        ),
        
        // Postal code field
        CustomTextFormField(
          controller: postalCodeController,
          label: 'Postal Code',
          prefixIcon: const Icon(Icons.local_post_office),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a postal code';
            }
            return null;
          },
        ),
        
        // Phone field
        CustomTextFormField(
          controller: phoneController,
          label: 'Phone Number',
          prefixIcon: const Icon(Icons.phone),
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a phone number';
            }
            return null;
          },
        ),
      ],
    );
  }
}
