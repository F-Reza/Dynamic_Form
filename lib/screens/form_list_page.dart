import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/form_model.dart';
import '../providers/form_provider.dart';
import 'form_page1.dart';
import 'form_page2.dart';
import 'form_page3.dart';

class FormListPage extends StatelessWidget {
  static const routeName = '/form-list';
  const FormListPage({super.key});

  @override
  Widget build(BuildContext context) {

    final formList = [
      'Customer Feedback Form',
      'Property Inspection Form',
      'Health Survey Form'
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Forms'),
      ),
      body: ListView(
        children: formList.map((formName) {
          return Card(
            elevation: 2,
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(formName),
              leading: const Icon(Icons.description),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FormPage3(formName: formName),
                  ),
                );
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}