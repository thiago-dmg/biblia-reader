import 'dart:convert';

import 'package:http/http.dart' as http;

Future<http.Response> sendWithManualRedirect({
  required String method,
  required Uri url,
  required Map<String, String> headers,
  Object? jsonBody,
}) {
  final body = jsonBody == null ? null : jsonEncode(jsonBody);
  switch (method.toUpperCase()) {
    case 'POST':
      return http.post(url, headers: headers, body: body);
    case 'PUT':
      return http.put(url, headers: headers, body: body);
    case 'PATCH':
      return http.patch(url, headers: headers, body: body);
    default:
      throw UnsupportedError('sendWithManualRedirect: $method');
  }
}
