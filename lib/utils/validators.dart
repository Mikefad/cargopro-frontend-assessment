import 'dart:convert';

String? requiredValidator(String? value, {String fieldName = 'Field'}) {
  if (value == null || value.trim().isEmpty) {
    return '$fieldName is required';
  }
  return null;
}

String? phoneValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Phone number is required';
  }
  if (!RegExp(r'^[+0-9]{8,}$').hasMatch(value.trim())) {
    return 'Enter a valid phone number';
  }
  return null;
}

String? jsonValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Data (JSON) is required';
  }
  try {
    final decoded = jsonDecode(value);
    if (decoded is! Map<String, dynamic>) {
      return 'JSON must be an object (e.g. {"key":"value"})';
    }
  } catch (_) {
    return 'Enter a valid JSON object';
  }
  return null;
}

