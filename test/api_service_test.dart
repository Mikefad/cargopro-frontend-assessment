import 'dart:convert';

import 'package:cargopro_assignment/models/cargo_object.dart';
import 'package:cargopro_assignment/services/api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('ApiService.fetchObjects', () {
    test('returns parsed CargoObjects when server responds with 200', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/objects');
        expect(request.url.queryParameters['page'], '1');
        expect(request.url.queryParameters['size'], '20');

        final payload = <Map<String, dynamic>>[
          <String, dynamic>{
            'id': '1',
            'name': 'Test object',
            'data': <String, dynamic>{'foo': 'bar'},
          },
        ];
        return http.Response(jsonEncode(payload), 200);
      });

      final api = ApiService(client: mockClient);
      final results = await api.fetchObjects(page: 1, pageSize: 20);

      expect(results, hasLength(1));
      expect(results.first, isA<CargoObject>());
      expect(results.first.name, 'Test object');
      expect(results.first.data['foo'], 'bar');
    });
  });
}

