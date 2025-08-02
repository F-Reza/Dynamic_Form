import 'package:flutter/material.dart';

import '../models/form_model.dart';

class FormProvider with ChangeNotifier {
  List<FormModel> _forms = [];
  List<FormSubmission> _submissions = [];

  List<FormModel> get forms => _forms;
  List<FormSubmission> get submissions => _submissions;

  Future<List<FormModel>> loadForms() async {
    // In a real app, this would load from API or local storage
    // For now, we'll use the hardcoded JSON from the example
    _forms = [
      FormModel.fromJson({
        "formName": "Customer Feedback Form",
        "id": 1,
        "sections": [
          {
            "name": "Personal Information",
            "key": "section_1",
            "fields": [
              {
                "id": 1,
                "key": "text_1",
                "properties": {
                  "type": "text",
                  "defaultValue": "",
                  "hintText": "ex: John Doe",
                  "minLength": 2,
                  "maxLength": 50,
                  "label": "Full Name"
                }
              },
              {
                "id": 1,
                "key": "text_2",
                "properties": {
                  "type": "text",
                  "defaultValue": "",
                  "hintText": "ex: john@example.com",
                  "minLength": 5,
                  "maxLength": 100,
                  "label": "Email Address"
                }
              },
              {
                "id": 2,
                "key": "list_1",
                "properties": {
                  "type": "dropDownList",
                  "defaultValue": "",
                  "hintText": "Select your age group",
                  "label": "Age Group",
                  "listItems":
                  "[{\"name\":\"Under 18\",\"value\":1},{\"name\":\"18-30\",\"value\":2},{\"name\":\"31-45\",\"value\":3},{\"name\":\"46-60\",\"value\":4},{\"name\":\"Over 60\",\"value\":5}]",
                  "multiSelect": false
                }
              }
            ]
          },
          {
            "name": "Feedback Details",
            "key": "section_2",
            "fields": [
              {
                "id": 2,
                "key": "list_2",
                "properties": {
                  "type": "checkBoxList",
                  "defaultValue": "",
                  "hintText": "Select all that apply",
                  "label": "What did you like?",
                  "listItems":
                  "[{\"name\":\"Product Quality\",\"value\":1},{\"name\":\"Customer Service\",\"value\":2},{\"name\":\"Delivery Speed\",\"value\":3},{\"name\":\"Pricing\",\"value\":4}]",
                  "multiSelect": true
                }
              },
              {
                "id": 3,
                "key": "yesno_1",
                "properties": {
                  "type": "yesno",
                  "defaultValue": "",
                  "label": "Would you recommend us?"
                }
              },
              {
                "id": 1,
                "key": "text_3",
                "properties": {
                  "type": "text",
                  "defaultValue": "",
                  "hintText": "ex: The service was great!",
                  "minLength": 10,
                  "maxLength": 500,
                  "label": "Additional Comments"
                }
              },
              {
                "id": 4,
                "key": "image_1",
                "properties": {
                  "type": "imageView",
                  "defaultValue": "",
                  "label": "Upload a photo (optional)",
                  "multiImage": false
                }
              }
            ]
          }
        ]
      }),
      FormModel.fromJson({
        "formName": "Property Inspection Form",
        "id": 2,
        "sections": [
          {
            "name": "Property Details",
            "key": "section_1",
            "fields": [
              {
                "id": 1,
                "key": "text_1",
                "properties": {
                  "type": "text",
                  "defaultValue": "",
                  "hintText": "ex: 123 Main St",
                  "minLength": 5,
                  "maxLength": 100,
                  "label": "Property Address"
                }
              },
              {
                "id": 2,
                "key": "list_1",
                "properties": {
                  "type": "dropDownList",
                  "defaultValue": "",
                  "hintText": "Select property type",
                  "label": "Property Type",
                  "listItems":
                  "[{\"name\":\"Apartment\",\"value\":1},{\"name\":\"House\",\"value\":2},{\"name\":\"Commercial\",\"value\":3},{\"name\":\"Land\",\"value\":4}]",
                  "multiSelect": false
                }
              },
              {
                "id": 1,
                "key": "text_2",
                "properties": {
                  "type": "text",
                  "defaultValue": "",
                  "hintText": "ex: 1500 sq ft",
                  "minLength": 1,
                  "maxLength": 20,
                  "label": "Area (sq ft)"
                }
              },
              {
                "id": 3,
                "key": "yesno_1",
                "properties": {
                  "type": "yesno",
                  "defaultValue": "",
                  "label": "Is the property furnished?"
                }
              }
            ]
          },
          {
            "name": "Inspection Checklist",
            "key": "section_2",
            "fields": [
              {
                "id": 2,
                "key": "list_2",
                "properties": {
                  "type": "checkBoxList",
                  "defaultValue": "",
                  "hintText": "Select issues found",
                  "label": "Defects Found",
                  "listItems":
                  "[{\"name\":\"Cracks in Walls\",\"value\":1},{\"name\":\"Leaking Roof\",\"value\":2},{\"name\":\"Faulty Wiring\",\"value\":3},{\"name\":\"Plumbing Issues\",\"value\":4}]",
                  "multiSelect": true
                }
              },
              {
                "id": 4,
                "key": "image_1",
                "properties": {
                  "type": "imageView",
                  "defaultValue": "",
                  "label": "Upload photos of defects",
                  "multiImage": true
                }
              },
              {
                "id": 1,
                "key": "text_3",
                "properties": {
                  "type": "text",
                  "defaultValue": "",
                  "hintText": "ex: Major structural damage observed",
                  "minLength": 0,
                  "maxLength": 500,
                  "label": "Additional Notes"
                }
              }
            ]
          }
        ]
      }),
      FormModel.fromJson({
        "formName": "Health Survey Form",
        "id": 3,
        "sections": [
          {
            "name": "Basic Information",
            "key": "section_1",
            "fields": [
              {
                "id": 1,
                "key": "text_1",
                "properties": {
                  "type": "text",
                  "defaultValue": "",
                  "hintText": "ex: Alex Smith",
                  "minLength": 2,
                  "maxLength": 50,
                  "label": "Patient Name"
                }
              },
              {
                "id": 2,
                "key": "list_1",
                "properties": {
                  "type": "dropDownList",
                  "defaultValue": "",
                  "hintText": "Select gender",
                  "label": "Gender",
                  "listItems":
                  "[{\"name\":\"Male\",\"value\":1},{\"name\":\"Female\",\"value\":2},{\"name\":\"Other\",\"value\":3}]",
                  "multiSelect": false
                }
              },
              {
                "id": 1,
                "key": "text_2",
                "properties": {
                  "type": "text",
                  "defaultValue": "",
                  "hintText": "ex: 35",
                  "minLength": 1,
                  "maxLength": 3,
                  "label": "Age"
                }
              }
            ]
          },
          {
            "name": "Medical History",
            "key": "section_2",
            "fields": [
              {
                "id": 2,
                "key": "list_2",
                "properties": {
                  "type": "checkBoxList",
                  "defaultValue": "",
                  "hintText": "Select all that apply",
                  "label": "Existing Conditions",
                  "listItems":
                  "[{\"name\":\"Diabetes\",\"value\":1},{\"name\":\"Hypertension\",\"value\":2},{\"name\":\"Asthma\",\"value\":3},{\"name\":\"Heart Disease\",\"value\":4}]",
                  "multiSelect": true
                }
              },
              {
                "id": 3,
                "key": "yesno_1",
                "properties": {
                  "type": "yesno",
                  "defaultValue": "",
                  "label": "Any allergies?"
                }
              },
              {
                "id": 1,
                "key": "text_3",
                "properties": {
                  "type": "text",
                  "defaultValue": "",
                  "hintText": "ex: Peanuts, Penicillin",
                  "minLength": 0,
                  "maxLength": 200,
                  "label": "If yes, specify"
                }
              },
              {
                "id": 4,
                "key": "image_1",
                "properties": {
                  "type": "imageView",
                  "defaultValue": "",
                  "label": "Upload prescription (if any)",
                  "multiImage": false
                }
              }
            ]
          }
        ]
      })
    ];

    notifyListeners();
    return _forms;
  }

  void saveFormData(String formId, Map<String, dynamic> data) {
    // In a real app, this would save to local storage or API
    // For now, we'll just keep it in memory
    // The actual saving happens in the SubmissionViewPage
  }

  void addSubmission(FormSubmission submission) {
    _submissions.add(submission);
    notifyListeners();
  }
}