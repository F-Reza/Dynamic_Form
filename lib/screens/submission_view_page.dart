import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SubmissionViewPage extends StatelessWidget {
  static const routeName = '/submission_view';
  final Map<String, dynamic> formData;
  final String formName;

  const SubmissionViewPage({super.key, required this.formData, required this.formName});

  Future<void> _saveToFile(BuildContext context) async {

    // await generatePdfWithImages(formData);

    try {
      final downloadDir = Directory('/storage/emulated/0/Download');
      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${downloadDir.path}/invoice_${DateTime.now().millisecondsSinceEpoch}.txt');
      // final file = File('${directory.path}/invoice_${DateTime.now().millisecondsSinceEpoch}.txt');

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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving file: $e")),
      );
    }

  }



  /*Future<void> generatePdfWithImages(Map<String, dynamic> formData) async {
    final pdf = pw.Document();
    final now = DateTime.now();
    final dateStr = DateFormat('yyyy-MM-dd').format(now);
    final timeStr = DateFormat('hh:mm a').format(now);

    // Label Maps
    final ageGroupMap = {
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

    final genderMap = {
      "1": "Male",
      "2": "Female",
      "3": "Other",
    };

    final propertyTypeMap = {
      "1": "Apartment",
      "2": "House",
      "3": "Commercial",
      "4": "Land",
    };

    final defectOptionsMap = {
      1: "Cracks in Walls",
      2: "Leaking Roof",
      3: "Faulty Wiring",
      4: "Plumbing Issues",
    };

    final conditionOptionsMap = {
      1: "Diabetes",
      2: "Hypertension",
      3: "Asthma",
      4: "Heart Disease",
    };

    String formatYesNoNA(String input) {
      switch (input.toLowerCase()) {
        case 'yes':
          return 'Yes';
        case 'no':
          return 'No';
        case 'na':
          return 'N/A';
        default:
          return input;
      }
    }

    List<pw.Widget> formWidgets = [
      pw.Center(
        child: pw.Text("FORM SUBMISSION INVOICE",
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
      ),
      pw.SizedBox(height: 8),
      pw.Center(child: pw.Text("Date: $dateStr   Time: $timeStr")),
      pw.Divider(),
    ];

    for (var entry in formData.entries) {
      final key = entry.key;
      final value = entry.value;

      if (key == 'id') continue;

      if (key == 'likes' && value is List) {
        final text = value.map((v) => likeOptionsMap[v] ?? v.toString()).join(', ');
        formWidgets.add(pw.Text("Likes: $text"));
      } else if (key == 'defects' && value is List) {
        final text = value.map((v) => defectOptionsMap[v] ?? v.toString()).join(', ');
        formWidgets.add(pw.Text("Defects: $text"));
      } else if (key == 'conditions' && value is List) {
        final text = value.map((v) => conditionOptionsMap[v] ?? v.toString()).join(', ');
        formWidgets.add(pw.Text("Conditions: $text"));
      } else if (key == 'ageGroup') {
        formWidgets.add(pw.Text("Age Group: ${ageGroupMap[value.toString()] ?? value}"));
      } else if (key == 'gender') {
        formWidgets.add(pw.Text("Gender: ${genderMap[value.toString()] ?? value}"));
      } else if (key == 'propertyType') {
        formWidgets.add(pw.Text("Property Type: ${propertyTypeMap[value.toString()] ?? value}"));
      } else if (['recommendation', 'furnishedProperty', 'allergies'].contains(key)) {
        formWidgets.add(pw.Text("${_capitalize(key)}: ${formatYesNoNA(value)}"));
      } else if (key == 'images' && value is List) {
        formWidgets.add(pw.SizedBox(height: 10));
        formWidgets.add(pw.Text("Images:"));
        for (var imagePath in value) {
          final file = File(imagePath);
          if (await file.exists()) {
            final imgBytes = await file.readAsBytes();
            final image = pw.MemoryImage(imgBytes);
            formWidgets.add(pw.SizedBox(height: 8));
            formWidgets.add(pw.Image(image, width: 200, height: 150));
          }
        }
        formWidgets.add(pw.SizedBox(height: 10));
      } else {
        formWidgets.add(pw.Text("${_capitalize(key)}: ${value.toString()}"));
      }
    }

    pdf.addPage(pw.Page(
      margin: const pw.EdgeInsets.all(24),
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: formWidgets,
      ),
    ));

    // Save to Downloads
    if (await Permission.storage.request().isGranted) {
      final downloadDir = Directory('/storage/emulated/0/Download');
      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }

      final file = File('${downloadDir.path}/form_invoice_${now.millisecondsSinceEpoch}.pdf');
      await file.writeAsBytes(await pdf.save());

      print("PDF saved to: ${file.path}");
    } else {
      print(" Storage permission denied");
    }
  }

  String _capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }
*/

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd').format(now);
    final formattedTime = DateFormat('hh:mm a').format(now);
    return Scaffold(
      appBar: AppBar(
        title: Text(formName),
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
                  /*Center(
                    child: Text(
                      "Date: $formattedDate  Time: $formattedTime",
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ),*/
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
    final id = data['id'];

    final ageGroupMap = {
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

    final propertyTypeMap = {
      "1": "Apartment",
      "2": "House",
      "3": "Commercial",
      "4": "Land",
    };

    final defectOptionsMap = {
      1: "Cracks in Walls",
      2: "Leaking Roof",
      3: "Faulty Wiring",
      4: "Plumbing Issues",
    };

    final genderMap = {
      "1": "Male",
      "2": "Female",
      "3": "Other",
    };

    final conditionOptionsMap = {
      1: "Diabetes",
      2: "Hypertension",
      3: "Asthma",
      4: "Heart Disease",
    };

    final labels = {
      '1': {
        'fullName': 'Full Name',
        'email': 'Email',
        'ageGroup': 'Age Group',
        'likes': 'Likes',
        'recommendation': 'Recommendation',
        'comments': 'Comments',
      },
      '2': {
        'propertyAddress': 'Property Address',
        'propertyType': 'Property Type',
        'area': 'Area',
        'furnishedProperty': 'Is the property furnished?',
        'defects': 'Defects Found',
        'notes': 'Additional Notes',
      },
      '3': {
        'patientName': 'Patient Name',
        'gender': 'Gender',
        'age': 'Age',
        'conditions': 'Existing Conditions',
        'allergies': 'Any allergies?',
        'specify': 'If yes, specify',
      }
    };

    List<Widget> widgets = [];


    data.forEach((key, value) {
      if (key == 'id') return;
      String label = labels[id]?[key] ?? key;

      if (key == 'likes' && value is List) {
        final likedItems = value.map((v) => likeOptionsMap[v] ?? v.toString()).join(', ');
        widgets.add(_invoiceRow(label, likedItems));
      } else if (key == 'defects' && value is List) {
        final defectList = value.map((v) => defectOptionsMap[v] ?? v.toString()).join(', ');
        widgets.add(_invoiceRow(label, defectList));
      } else if (key == 'conditions' && value is List) {
        final conditionsList = value.map((v) => conditionOptionsMap[v] ?? v.toString()).join(', ');
        widgets.add(_invoiceRow(label, conditionsList));
      } else if (key == 'propertyType') {
        final propertyTypeText = propertyTypeMap[value.toString()] ?? value.toString();
        widgets.add(_invoiceRow(label, propertyTypeText));
      } else if (key == 'ageGroup') {
        final ageText = ageGroupMap[value.toString()] ?? value.toString();
        widgets.add(_invoiceRow(label, ageText));
      } else if (key == 'gender') {
        final genderText = genderMap[value.toString()] ?? value.toString();
        widgets.add(_invoiceRow(label, genderText));
      } else if (key == 'recommendation' || key == 'furnishedProperty' || key == 'allergies') {
        final ynText = _formatYesNoNA(value.toString());
        widgets.add(_invoiceRow(label, ynText));
      }
      else if (key == 'images') {
        List images = value as List;
        widgets.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Uploaded Images:', style: TextStyle(fontWeight: FontWeight.bold)),
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

  String _formatYesNoNA(String input) {
    switch (input.toLowerCase()) {
      case 'yes':
        return 'Yes';
      case 'no':
        return 'No';
      case 'na':
        return 'N/A';
      default:
        return input;
    }
  }


  Widget _invoiceRow(String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
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
