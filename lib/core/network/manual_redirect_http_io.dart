import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

const _maxRedirects = 5;

/// POST/PUT/PATCH sem seguir redirect automático (evita virar GET e perder o body).
/// Se vier 301/302/307/308 com [Location], repete o mesmo método e corpo na URL final.
Future<http.Response> sendWithManualRedirect({
  required String method,
  required Uri url,
  required Map<String, String> headers,
  Object? jsonBody,
}) async {
  final client = HttpClient();
  try {
    return await _send(client, method, url, headers, jsonBody, 0);
  } finally {
    client.close(force: true);
  }
}

Future<http.Response> _send(
  HttpClient client,
  String method,
  Uri url,
  Map<String, String> headers,
  Object? jsonBody,
  int depth,
) async {
  final req = await client.openUrl(method, url);
  req.followRedirects = false;

  final h = Map<String, String>.from(headers);
  h.removeWhere((k, _) => k.toLowerCase() == 'content-length');
  h.forEach(req.headers.set);

  if (_methodHasBody(method) && jsonBody != null) {
    final bodyBytes = utf8.encode(jsonEncode(jsonBody));
    req.headers.contentLength = bodyBytes.length;
    req.add(bodyBytes);
  }

  final streamed = await req.close();
  final responseBytes = await _readAllBytes(streamed);
  final code = streamed.statusCode;
  final flat = _flattenHeaders(streamed.headers);

  if (code >= 300 && code < 400 && depth < _maxRedirects) {
    final loc = streamed.headers.value(HttpHeaders.locationHeader);
    if (loc != null && loc.isNotEmpty) {
      final next = url.resolve(loc);
      if (next != url) {
        if (_methodHasBody(method) && jsonBody != null) {
          return _send(client, method, next, headers, jsonBody, depth + 1);
        }
        return _send(client, method, next, headers, null, depth + 1);
      }
    }
  }

  return http.Response.bytes(
    responseBytes,
    code,
    headers: flat,
    reasonPhrase: streamed.reasonPhrase,
  );
}

bool _methodHasBody(String m) {
  switch (m.toUpperCase()) {
    case 'POST':
    case 'PUT':
    case 'PATCH':
      return true;
    default:
      return false;
  }
}

Future<List<int>> _readAllBytes(HttpClientResponse r) async {
  final b = <int>[];
  await for (final chunk in r) {
    b.addAll(chunk);
  }
  return b;
}

Map<String, String> _flattenHeaders(HttpHeaders h) {
  final m = <String, String>{};
  h.forEach((name, values) {
    if (values.isNotEmpty) {
      m[name] = values.length == 1 ? values.single : values.join(',');
    }
  });
  return m;
}
