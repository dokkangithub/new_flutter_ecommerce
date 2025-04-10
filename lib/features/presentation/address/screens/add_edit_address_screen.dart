import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/enums/loading_state.dart';
import '../../../domain/address/entities/address.dart';
import '../controller/address_provider.dart';
import '../widgets/address_form_fields.dart';
import '../widgets/address_form_shimmer.dart';
import '../widgets/save_address_button.dart';
import '../../../domain/address/extensions/location_extensions.dart';

class AddEditAddressScreen extends StatefulWidget {
  final Address? address;

  const AddEditAddressScreen({
    super.key,
    this.address,
  });

  @override
  State<AddEditAddressScreen> createState() => _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends State<AddEditAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  
  int? _selectedCountryId;
  int? _selectedStateId;
  int? _selectedCityId;
  
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    
    // If editing an existing address, populate the form
    if (widget.address != null) {
      _titleController.text = widget.address!.title;
      _addressController.text = widget.address!.address;
      _postalCodeController.text = widget.address!.postalCode;
      _phoneController.text = widget.address!.phone;
      
      _selectedCountryId = widget.address!.countryId;
      _selectedStateId = widget.address!.stateId;
      _selectedCityId = widget.address!.cityId;
    }
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCountries();
    });
  }
  
  @override
  void dispose() {
    _titleController.dispose();
    _addressController.dispose();
    _postalCodeController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
  
  void _loadCountries() async {
    final addressProvider = context.read<AddressProvider>();
    await addressProvider.fetchCountries();
    
    // If editing, load states and cities
    if (widget.address != null && _selectedCountryId != null) {
      await addressProvider.fetchStatesByCountry(_selectedCountryId!);
      
      if (_selectedStateId != null) {
        await addressProvider.fetchCitiesByState(_selectedStateId!);
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.address == null ? 'Add New Address' : 'Edit Address'),
        elevation: 0,
      ),
      body: Consumer<AddressProvider>(
        builder: (context, addressProvider, child) {
          // Show shimmer while loading countries
          final bool isLoadingInitialData = addressProvider.addressState == LoadingState.loading;
          
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Show shimmer or form fields based on loading state
                  isLoadingInitialData
                      ? const AddressFormShimmer()
                      : AddressFormFields(
                          titleController: _titleController,
                          addressController: _addressController,
                          postalCodeController: _postalCodeController,
                          phoneController: _phoneController,
                          selectedCountryId: _selectedCountryId,
                          selectedStateId: _selectedStateId,
                          selectedCityId: _selectedCityId,
                          countries: addressProvider.countries.map((location) => location.toMap()).toList(),
                          states: addressProvider.states.map((location) => location.toMap()).toList(),
                          cities: addressProvider.cities.map((location) => location.toMap()).toList(),
                          isLoading: _isLoading,
                          onCountryChanged: (value) async {
                            if (value != null) {
                              setState(() {
                                _selectedCountryId = value;
                                _selectedStateId = null;
                                _selectedCityId = null;
                              });
                              await addressProvider.fetchStatesByCountry(value);
                            }
                          },
                          onStateChanged: (value) async {
                            if (value != null) {
                              setState(() {
                                _selectedStateId = value;
                                _selectedCityId = null;
                              });
                              await addressProvider.fetchCitiesByState(value);
                            }
                          },
                          onCityChanged: (value) {
                            setState(() {
                              _selectedCityId = value;
                            });
                          },
                        ),
                  
                  const SizedBox(height: 24),
                  
                  // Save button
                  SaveAddressButton(
                    isLoading: _isLoading,
                    onPressed: _saveAddress,
                    isEditing: widget.address != null,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  
  void _saveAddress() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      try {
        final addressProvider = context.read<AddressProvider>();
        
        if (widget.address == null) {
          // Add new address
          await addressProvider.addAddress(
            title: _titleController.text,
            address: _addressController.text,
            countryId: _selectedCountryId!,
            stateId: _selectedStateId!,
            cityId: _selectedCityId!,
            postalCode: _postalCodeController.text,
            phone: _phoneController.text,
          );
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Address added successfully')),
            );
            Navigator.pop(context);
          }
        } else {
          // Update existing address
          await addressProvider.updateAddress(
            id: widget.address!.id,
            title: _titleController.text,
            address: _addressController.text,
            countryId: _selectedCountryId!,
            stateId: _selectedStateId!,
            cityId: _selectedCityId!,
            postalCode: _postalCodeController.text,
            phone: _phoneController.text,
          );
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Address updated successfully')),
            );
            Navigator.pop(context);
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }
}
