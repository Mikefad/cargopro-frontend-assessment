import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/cargo_object.dart';

class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  static const String _baseUrl = 'https://api.restful-api.dev/objects';
  final http.Client _client;

  Future<List<CargoObject>> fetchObjects({
    int page = 1,
    int pageSize = 20,
  }) async {
    final uri = Uri.parse('$_baseUrl?page=$page&size=$pageSize');
    final response = await _client.get(uri);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body is List) {
        return body
            .map((item) => CargoObject.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw const HttpException('Unexpected response format');
      }
    } else {
      throw HttpException(
        'Failed to load objects (${response.statusCode})',
      );
    }
  }

  Future<CargoObject> fetchObject(String id) async {
    final uri = Uri.parse('$_baseUrl/$id');
    final response = await _client.get(uri);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return CargoObject.fromJson(body);
    } else {
      throw HttpException(
        'Failed to load object (${response.statusCode})',
      );
    }
  }

  Future<CargoObject> createObject(CargoObject object) async {
    final uri = Uri.parse(_baseUrl);
    final response = await _client.post(
      uri,
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'name': object.name,
        'data': object.data,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return CargoObject.fromJson(body);
    } else {
      throw HttpException(
        'Failed to create object (${response.statusCode})',
      );
    }
  }

  Future<CargoObject> updateObject(CargoObject object) async {
    if (object.id == null) {
      throw const HttpException('Object id is required for update');
    }

    final uri = Uri.parse('$_baseUrl/${object.id}');
    final response = await _client.put(
      uri,
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'name': object.name,
        'data': object.data,
      }),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return CargoObject.fromJson(body);
    } else {
      throw HttpException(
        'Failed to update object (${response.statusCode})',
      );
    }
  }

  Future<void> deleteObject(String id) async {
    final uri = Uri.parse('$_baseUrl/$id');
    final response = await _client.delete(uri);

    if (response.statusCode != 200) {
      throw HttpException(
        'Failed to delete object (${response.statusCode})',
      );
    }
  }
}

