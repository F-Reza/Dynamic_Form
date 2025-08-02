import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class SubmissionViewPage extends StatelessWidget {
  static const routeName = '/submission_view';
  final Map<String, dynamic> formData;

  const SubmissionViewPage({super.key, required this.formData});

  Future<void> _saveToFile(BuildContext context) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/invoice_${DateTime.now().millisecondsSinceEpoch}.txt');

      StringBuffer buffer = StringBuffer();
      buffer.writeln("=== Form Submission Invoice ===\n");
      formData.forEach((key, value) {
        if (key == 'images') {
          buffer.writeln('$key:');
          for (var path in value) {
            buffer.writeln('- $path');
          }
        } else {
          buffer.writeln('$key: $value');
        }
      });

      await file.writeAsString(buffer.toString());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Saved to: ${file.path}")),
      );
      print("Saved to: ${file.path}");
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving file: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Submission Invoice"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "FORM SUBMISSION INVOICE",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      "Date: ${DateTime.now().toLocal().toString().split(' ')[0]}",
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ),
                  const Divider(height: 30, thickness: 1),
                  ..._buildFormattedFields(formData),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () => _saveToFile(context),
                      icon: const Icon(Icons.save),
                      label: const Text('Save to Storage'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFormattedFields(Map<String, dynamic> data) {
    final Map<String, String> ageGroupMap = {
      "1": "Under 18",
      "2": "18-30",
      "3": "31-45",
      "4": "46-60",
      "5": "Over 60",
    };

    final likeOptionsMap = {
      1: "Product Quality",
      2: "Customer Service",
      3: "Delivery Speed",
      4: "Pricing"
    };

    final fieldLabels1 = {
      'fullName': 'Full Name',
      'email': 'Email',
      'ageGroup': 'Age Group',
      'likes': 'Likes',
      'recommendation': 'Recommendation',
      'comments': 'Comments',
      'images': 'Images',
    };

    final fieldLabels2 = {
      'propertyAddress': 'Property Address',
      'propertyType': 'Property Type',
      'area': 'Area',
      'furnishedProperty': 'Is the property furnished?',
      'defects': 'Defects Found',
      'notes': 'Additional Notes',
      'images': 'Images',
    };
    final fieldLabels3 = {
      'patientName': 'Patient Name',
      'gender': 'Gender',
      'age': 'Age',
      'conditions': 'Existing Conditions',
      'allergies': 'Any allergies?',
      'specify': 'If yes, specify',
      'images': 'Images',
    };

    List<Widget> widgets = [];

    data.forEach((key, value) {
      String label = fieldLabels1[key] ?? key;

      if (key == 'likes' && value is List) {
        final likedItems = value.map((v) => likeOptionsMap[v] ?? v.toString()).join(', ');
        widgets.add(_invoiceRow(label, likedItems));
      } else if (key == 'ageGroup') {
        final ageText = ageGroupMap[value.toString()] ?? value.toString();
        widgets.add(_invoiceRow(label, ageText));
      } else if (key == 'images') {
        List images = value as List;
        widgets.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Uploaded Images:', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: images.map<Widget>((imgPath) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(imgPath),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      } else {
        widgets.add(_invoiceRow(label, value.toString()));
      }
    });

    return widgets;
  }

  Widget _invoiceRow(String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
