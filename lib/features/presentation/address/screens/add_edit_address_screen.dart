import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../domain/address/entities/address.dart';
import '../controller/address_provider.dart';

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
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Title field
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Address Title',
                      hintText: 'e.g. Home, Office',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.title),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Country dropdown
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      labelText: 'Country',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.public),
                    ),
                    value: _selectedCountryId,
                    hint: const Text('Select Country'),
                    items: addressProvider.countries.map((country) {
                      return DropdownMenuItem<int>(
                        value: country.id,
                        child: Text(country.name),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a country';
                      }
                      return null;
                    },
                    onChanged: (value) async {
                      if (value != null) {
                        setState(() {
                          _selectedCountryId = value;
                          _selectedStateId = null;
                          _selectedCityId = null;
                        });
                        await addressProvider.fetchStatesByCountry(value);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // State dropdown
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      labelText: 'State/Province',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_city),
                    ),
                    value: _selectedStateId,
                    hint: const Text('Select State/Province'),
                    items: addressProvider.states.map((state) {
                      return DropdownMenuItem<int>(
                        value: state.id,
                        child: Text(state.name),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a state';
                      }
                      return null;
                    },
                    onChanged: (value) async {
                      if (value != null) {
                        setState(() {
                          _selectedStateId = value;
                          _selectedCityId = null;
                        });
                        await addressProvider.fetchCitiesByState(value);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // City dropdown
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      labelText: 'City',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_on),
                    ),
                    value: _selectedCityId,
                    hint: const Text('Select City'),
                    items: addressProvider.cities.map((city) {
                      return DropdownMenuItem<int>(
                        value: city.id,
                        child: Text(city.name),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a city';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedCityId = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Address field
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Address Details',
                      hintText: 'Street name, building number, etc.',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.home),
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter address details';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Postal code field
                  TextFormField(
                    controller: _postalCodeController,
                    decoration: const InputDecoration(
                      labelText: 'Postal Code',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.local_post_office),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a postal code';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Phone field
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  
                  // Save button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _saveAddress,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : Text(
                            widget.address == null ? 'Add Address' : 'Update Address',
                            style: const TextStyle(fontSize: 16),
                          ),
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
