import 'dart:io';
import 'package:dynamicform/screens/submission_view_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/form_model.dart';
import '../providers/form_provider.dart';

class FormPage1 extends StatefulWidget {
  static const routeName = '/form';
  final String? formName;

  const FormPage1({super.key, this.formName});

  @override
  State<FormPage1> createState() => _FormPage1State();
}

class _FormPage1State extends State<FormPage1> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  // Form controllers and state variables
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _commentsController = TextEditingController();

  String? _selectedAgeGroup;
  final List<int> _selectedLikes = [];
  String? _recommendationValue;
  List<XFile> _selectedImages = [];

  String? _likesErrorText;
  String? _recommendationErrorText;


  // Age group options
  final List<Map<String, dynamic>> _ageGroups = [
    {"name": "Select your age group", "value": ""},
    {"name": "Under 18", "value": "1"},
    {"name": "18-30", "value": "2"},
    {"name": "31-45", "value": "3"},
    {"name": "46-60", "value": "4"},
    {"name": "Over 60", "value": "5"},
  ];

  // Checkbox options
  final List<Map<String, dynamic>> _likeOptions = [
    {"name": "Product Quality", "value": 1},
    {"name": "Customer Service", "value": 2},
    {"name": "Delivery Speed", "value": 3},
    {"name": "Pricing", "value": 4},
  ];

  // Radio options
  final List<Map<String, dynamic>> _recommendationOptions = [
    {"label": "Yes", "value": "yes"},
    {"label": "No", "value": "no"},
    {"label": "NA", "value": "na"},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _commentsController.dispose();
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
      _likesErrorText = _selectedLikes.isEmpty ? 'Please select at least one option' : null;
      _recommendationErrorText = (_recommendationValue == null || _recommendationValue!.isEmpty)
          ? 'Please select an option'
          : null;
    });

    if (_formKey.currentState!.validate() &&
        _likesErrorText == null &&
        _recommendationErrorText == null) {
      _formKey.currentState!.save();

      final formData = {
        'id':'1',
        'fullName': _nameController.text,
        'email': _emailController.text,
        'ageGroup': _selectedAgeGroup,
        'likes': _selectedLikes,
        'recommendation': _recommendationValue,
        'comments': _commentsController.text,
        'images': _selectedImages.map((image) => image.path).toList(),
      };

      print('Form submitted: $formData');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form submitted successfully!')),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SubmissionViewPage(formData: formData),
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
              // Full Name Field
              _buildSectionTitle('Personal Information'),
              _buildTextFormField(
                controller: _nameController,
                label: 'Full Name',
                hintText: 'ex: John Doe',
                minLength: 2,
                maxLength: 50,
                keyboardType: TextInputType.name,
              ),

              // Email Field
              _buildTextFormField(
                controller: _emailController,
                label: 'Email Address',
                hintText: 'ex: john@example.com',
                minLength: 5,
                maxLength: 100,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),

              // Age Group Dropdown
              _buildDropdownField(
                value: _selectedAgeGroup,
                label: 'Age Group',
                hintText: 'Select your age group',
                icon: Icons.arrow_drop_down_circle,
                items: _ageGroups,
                onChanged: (value) {
                  setState(() {
                    _selectedAgeGroup = value;
                  });
                },
              ),

              // Likes Checkboxes
              _buildCheckboxList(
                label: 'What did you like about us?',
                options: _likeOptions,
                selectedValues: _selectedLikes,
                onChanged: (value, isChecked) {
                  setState(() {
                    if (isChecked) {
                      _selectedLikes.add(value);
                    } else {
                      _selectedLikes.remove(value);
                    }
                  });
                },
                errorText: _likesErrorText,
              ),

              // Recommendation Radio Buttons
              _buildRadioButtonGroup(
                label: 'Would you recommend us?',
                options: _recommendationOptions,
                groupValue: _recommendationValue,
                onChanged: (value) {
                  setState(() {
                    _recommendationValue = value;
                  });
                },
                errorText: _recommendationErrorText,
              ),


              // Comments Field
              _buildTextFormField(
                controller: _commentsController,
                label: 'Additional Comments',
                hintText: 'ex: The service was great!',
                minLength: 10,
                maxLength: 500,
                keyboardType: TextInputType.multiline,
                maxLines: 4,
              ),

              // Single Image Upload
              // _buildSectionTitle('Photo Upload'),
              _buildImageUploadField(
                label: 'Upload a photo (optional)',
                isMultiImage: false,
                onPressed: () => _pickImage(false),
                images: _selectedImages,
                onRemove: _removeImage,
              ),

              // Submit Button
              const SizedBox(height: 20),
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


  Widget _buildImageUploadField({
    required String label,
    required bool isMultiImage,
    required VoidCallback onPressed,
    required List<XFile> images,
    required Function(int) onRemove,
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
          ElevatedButton.icon(
            onPressed: onPressed,
            icon: const Icon(Icons.add_a_photo),
            label: Text(isMultiImage ? 'Add Images' : 'Add Image'),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: List.generate(images.length, (index) {
              return _buildImagePreview(images[index], () => onRemove(index));
            }),
          ),
        ],
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