import 'dart:convert';

class FormModel {
  final String formName;
  final int id;
  final List<FormSection> sections;

  FormModel({
    required this.formName,
    required this.id,
    required this.sections,
  });

  factory FormModel.fromJson(Map<String, dynamic> json) {
    return FormModel(
      formName: json['formName'],
      id: json['id'],
      sections: List<FormSection>.from(
          json['sections'].map((x) => FormSection.fromJson(x))),
    );
  }
}

class FormSection {
  final String name;
  final String key;
  final List<FormField> fields;

  FormSection({
    required this.name,
    required this.key,
    required this.fields,
  });

  factory FormSection.fromJson(Map<String, dynamic> json) {
    return FormSection(
      name: json['name'],
      key: json['key'],
      fields: List<FormField>.from(
          json['fields'].map((x) => FormField.fromJson(x))),
    );
  }
}

class FormField {
  final int id;
  final String key;
  final FieldProperties properties;

  FormField({
    required this.id,
    required this.key,
    required this.properties,
  });

  factory FormField.fromJson(Map<String, dynamic> json) {
    return FormField(
      id: json['id'],
      key: json['key'],
      properties: FieldProperties.fromJson(json['properties']),
    );
  }
}

class FieldProperties {
  final String type;
  final dynamic defaultValue;
  final String? hintText;
  final int? minLength;
  final int? maxLength;
  final String label;
  final String? listItems;
  final bool? multiSelect;
  final bool? multiImage;

  FieldProperties({
    required this.type,
    required this.defaultValue,
    this.hintText,
    this.minLength,
    this.maxLength,
    required this.label,
    this.listItems,
    this.multiSelect,
    this.multiImage,
  });

  factory FieldProperties.fromJson(Map<String, dynamic> json) {
    return FieldProperties(
      type: json['type'],
      defaultValue: json['defaultValue'],
      hintText: json['hintText'],
      minLength: json['minLength'],
      maxLength: json['maxLength'],
      label: json['label'],
      listItems: json['listItems'],
      multiSelect: json['multiSelect'],
      multiImage: json['multiImage'],
    );
  }

  List<DropdownItem>? getDropdownItems() {
    if (listItems == null) return null;
    try {
      final items = jsonDecode(listItems!) as List;
      return items.map((item) => DropdownItem.fromJson(item)).toList();
    } catch (e) {
      return null;
    }
  }
}

class DropdownItem {
  final String name;
  final dynamic value;

  DropdownItem({required this.name, required this.value});

  factory DropdownItem.fromJson(Map<String, dynamic> json) {
    return DropdownItem(
      name: json['name'],
      value: json['value'],
    );
  }
}

class FormSubmission {
  final String formId;
  final String submissionId;
  final DateTime submissionDate;
  final Map<String, dynamic> data;

  FormSubmission({
    required this.formId,
    required this.submissionId,
    required this.submissionDate,
    required this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      'formId': formId,
      'submissionId': submissionId,
      'submissionDate': submissionDate.toIso8601String(),
      'data': data,
    };
  }

  factory FormSubmission.fromJson(Map<String, dynamic> json) {
    return FormSubmission(
      formId: json['formId'],
      submissionId: json['submissionId'],
      submissionDate: DateTime.parse(json['submissionDate']),
      data: json['data'],
    );
  }
}