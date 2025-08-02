import 'dart:io';
import 'package:dynamicform/screens/submission_view_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/form_model.dart';
import '../providers/form_provider.dart';

class FormPage2 extends StatefulWidget {
  static const routeName = '/form2';
  final String? formName;

  const FormPage2({super.key, this.formName});

  @override
  State<FormPage2> createState() => _FormPage2State();
}

class _FormPage2State extends State<FormPage2> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  // Form controllers and state variables
  final TextEditingController _propertyAddressController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String? _selectedPropertyType;
  final List<int> _selectedDefects = [];
  String? _furnishedPropertyValue;
  List<XFile> _selectedImages = [];

  String? _defectsErrorText;
  String? _imageErrorText;
  String? _furnishedPropertyErrorText;


  // Property Type options
  final List<Map<String, dynamic>> _propertyType = [
    {"name": "Select property type", "value": ""},
    {"name": "Apartment", "value": "1"},
    {"name": "House", "value": "2"},
    {"name": "Commercial", "value": "3"},
    {"name": "Land", "value": "4"},
  ];

  // Checkbox options
  final List<Map<String, dynamic>> _defectsOptions = [
    {"name": "Cracks in Walls", "value": 1},
    {"name": "Leaking Roof", "value": 2},
    {"name": "Faulty Wiring", "value": 3},
    {"name": "Plumbing Issues", "value": 4},
  ];

  // Radio options
  final List<Map<String, dynamic>> _furnishedPropertyOptions = [
    {"label": "Yes", "value": "yes"},
    {"label": "No", "value": "no"},
    {"label": "N/A", "value": "na"},
  ];

  @override
  void dispose() {
    _propertyAddressController.dispose();
    _areaController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(bool isMultiImage) async {
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles.isNotEmpty) {
        setState(() {
          if (isMultiImage) {
            _selectedImages.addAll(pickedFiles);
          } else {
            _selectedImages = [pickedFiles.first];
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: ${e.toString()}')),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _submitForm() {
    setState(() {
      _imageErrorText = _selectedImages.isEmpty ? 'Please upload at least one image.' : null;
      _defectsErrorText = _selectedDefects.isEmpty ? 'Please select at least one option' : null;
      _furnishedPropertyErrorText = (_furnishedPropertyValue == null || _furnishedPropertyValue!.isEmpty)
          ? 'Please select an option'
          : null;
    });


    if (_formKey.currentState!.validate() &&
        _defectsErrorText == null &&
        _furnishedPropertyErrorText == null) {
      _formKey.currentState!.save();

      final formData = {
        'id':'2',
        'propertyAddress': _propertyAddressController.text,
        'propertyType': _selectedPropertyType, //
        'area': _areaController.text,
        'furnishedProperty': _furnishedPropertyValue,
        'defects': _selectedDefects,
        'notes': _notesController.text,
        'images': _selectedImages.map((image) => image.path).toList(),
      };

      print('Form submitted: $formData');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form submitted successfully!')),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SubmissionViewPage(formData: formData, formName: 'Property Inspection'),
        ),
      );

    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.formName ?? 'Dynamic Form'),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Property Address Field
              _buildSectionTitle('Property Details'),
              _buildTextFormField(
                controller: _propertyAddressController,
                label: 'Property Address',
                hintText: 'ex: 123 Main St',
                minLength: 5,
                maxLength: 100,
                keyboardType: TextInputType.name,
                maxLines: 2,
              ),

              // Property Typ Dropdown
              _buildDropdownField(
                value: _selectedPropertyType,
                label: 'Property Type',
                hintText: 'Select property type',
                icon: Icons.arrow_drop_down_circle,
                items: _propertyType,
                onChanged: (value) {
                  setState(() {
                    _selectedPropertyType = value;
                  });
                },
              ),

              // Area Field
              _buildTextFormField(
                controller: _areaController,
                label: 'Area (sq ft)',
                hintText: 'ex: 1500 sq ft',
                minLength: 5,
                maxLength: 100,
                keyboardType: TextInputType.name,
              ),

              // Property Furnished Radio Buttons
              _buildRadioButtonGroup(
                label: 'Is the property furnished?',
                options: _furnishedPropertyOptions,
                groupValue: _furnishedPropertyValue,
                onChanged: (value) {
                  setState(() {
                    _furnishedPropertyValue = value;
                  });
                },
                errorText: _furnishedPropertyErrorText,
              ),

              // DefectsFound Checkboxes
              _buildSectionTitle('Inspection Checklist'),
              _buildCheckboxList(
                label: 'Defects Found',
                options: _defectsOptions,
                selectedValues: _selectedDefects,
                onChanged: (value, isChecked) {
                  setState(() {
                    if (isChecked) {
                      _selectedDefects.add(value);
                    } else {
                      _selectedDefects.remove(value);
                    }
                  });
                },
                errorText: _defectsErrorText,
              ),

              // Multi Image Upload
              _buildImageUploadCard(
                label: 'Upload photos of defects',
                isMultiImage: true,
                onPressed: () => _pickImage(true),
                images: _selectedImages,
                onRemove: _removeImage,
                errorText: _imageErrorText,
              ),
              SizedBox(height: 30,),

              // Comments Field
              _buildTextFormField(
                controller: _notesController,
                label: 'Additional Notes',
                hintText: 'ex: Major structural damage observed',
                minLength: 0,
                maxLength: 500,
                keyboardType: TextInputType.multiline,
                maxLines: 4,
              ),


              // Submit Button
              const SizedBox(height: 5),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Submit Form',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required int minLength,
    required int maxLength,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            keyboardType: keyboardType,
            maxLines: maxLines,
            maxLength: maxLength,
            validator: validator ?? (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              if (value.length < minLength) {
                return 'Minimum $minLength characters required';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String? value,
    required String label,
    required String hintText,
    required IconData icon,
    required List<Map<String, dynamic>> items,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: Icon(icon, size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 0),
            ),
            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item['value'],
                child: Text(
                  item['name'],
                  style: TextStyle(
                    color: item['value'] == "" ? Colors.grey : Colors.black,
                  ),
                ),
              );
            }).toList(),
            onChanged: onChanged,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select an option';
              }
              return null;
            },
            style: const TextStyle(fontSize: 15),
            icon: const Icon(Icons.arrow_drop_down),
            borderRadius: BorderRadius.circular(10),
            isExpanded: true,
          ),
        ],
      ),
    );
  }


  Widget _buildCheckboxList({
    required String label,
    required List<Map<String, dynamic>> options,
    required List<int> selectedValues,
    required Function(int, bool) onChanged,
    bool isRequired = true,
    String? errorText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: errorText != null
                  ? Theme.of(context).colorScheme.error
                  : Colors.grey.shade300),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              children: options.map((option) {
                return CheckboxListTile(
                  title: Text(
                    option['name'],
                    style: const TextStyle(fontSize: 14),
                  ),
                  value: selectedValues.contains(option['value']),
                  onChanged: (bool? value) {
                    if (value != null) {
                      onChanged(option['value'], value);
                    }
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  activeColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }).toList(),
            ),
          ),
          if (errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 12),
              child: Text(
                errorText,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRadioButtonGroup({
    required String label,
    required List<Map<String, dynamic>> options,
    required String? groupValue,
    required Function(String?) onChanged,
    String? errorText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: options.map((option) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<String>(
                        value: option['value'],
                        groupValue: groupValue,
                        onChanged: onChanged,
                      ),
                      const SizedBox(width: 4),
                      Text(option['label']),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          if (errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 0, left: 10),
              child: Text(
                errorText,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }


  Widget _buildImageUploadCard({
    required String label,
    required bool isMultiImage,
    required VoidCallback onPressed,
    required List<XFile> images,
    required Function(int) onRemove,
    String? errorText, // Add this
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            if (images.isEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OutlinedButton.icon(
                    onPressed: onPressed,
                    icon: const Icon(Icons.add_a_photo, size: 20),
                    label: Text(
                      isMultiImage ? 'Select Images' : 'Select Image',
                      style: const TextStyle(fontSize: 14),
                    ),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  if (errorText != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        errorText,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 13,
                        ),
                      ),
                    ),
                ],
              ),
            if (images.isNotEmpty) ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(images.length, (index) {
                  return _buildImagePreview(images[index], () => onRemove(index));
                }),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: onPressed,
                    icon: const Icon(Icons.add, size: 20),
                    label: const Text('Add More', style: TextStyle(fontSize: 14)),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 36),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${images.length} ${isMultiImage ? 'images' : 'image'} selected',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview(XFile image, VoidCallback onRemove) {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: FileImage(File(image.path)),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              padding: const EdgeInsets.all(4),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}