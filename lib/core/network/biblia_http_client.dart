import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_exception.dart';
import 'manual_redirect_http_web.dart'
    if (dart.library.io) 'manual_redirect_http_io.dart' as manual_redirect;

typedef TokenProvider = String? Function();

/// Cliente HTTP com JSON e `Authorization: Bearer` opcional.
class BibliaHttpClient {
  BibliaHttpClient({
    required this.baseUrl,
    required this.getToken,
    http.Client? httpClient,
  }) : _http = httpClient ?? http.Client();

  final String baseUrl;
  final TokenProvider getToken;
  final http.Client _http;

  Uri _u(String path, [Map<String, String>? query]) {
    final b = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    final p = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$b$p').replace(queryParameters: query);
  }

  Map<String, String> _headers({bool jsonBody = false}) {
    final h = <String, String>{
      if (jsonBody) 'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final t = getToken();
    if (t != null && t.isNotEmpty) {
      h['Authorization'] = 'Bearer $t';
    }
    return h;
  }

  Future<dynamic> get(String path, {Map<String, String>? query}) async {
    final res = await _http.get(_u(path, query), headers: _headers());
    return _decode(res);
  }

  Future<dynamic> post(String path, {Object? body}) async {
    final res = await manual_redirect.sendWithManualRedirect(
      method: 'POST',
      url: _u(path),
      headers: _headers(jsonBody: body != null),
      jsonBody: body,
    );
    return _decode(res);
  }

  Future<dynamic> put(String path, {Object? body}) async {
    final res = await manual_redirect.sendWithManualRedirect(
      method: 'PUT',
      url: _u(path),
      headers: _headers(jsonBody: true),
      jsonBody: body,
    );
    return _decode(res);
  }

  Future<dynamic> patch(String path, {Object? body}) async {
    final res = await manual_redirect.sendWithManualRedirect(
      method: 'PATCH',
      url: _u(path),
      headers: _headers(jsonBody: true),
      jsonBody: body,
    );
    return _decode(res);
  }

  Future<void> delete(String path) async {
    final res = await _http.delete(_u(path), headers: _headers());
    if (res.statusCode >= 200 && res.statusCode < 300) return;
    if (res.statusCode == 401 || res.statusCode == 204) return;
    throw ApiException('HTTP ${res.statusCode}', statusCode: res.statusCode, body: res.body);
  }

  dynamic _decode(http.Response res) {
    if (res.statusCode >= 200 && res.statusCode < 300) {
      if (res.body.isEmpty) return null;
      try {
        return jsonDecode(res.body);
      } catch (_) {
        throw ApiException(
          'Resposta inválida (HTTP ${res.statusCode})',
          statusCode: res.statusCode,
          body: res.body,
        );
      }
    }
    throw ApiException(
      _messageFromBody(res.body, res.statusCode),
      statusCode: res.statusCode,
      body: res.body,
    );
  }

  static String _messageFromBody(String body, int statusCode) {
    if (body.isEmpty) {
      if (statusCode == 401) {
        return 'E-mail ou senha incorretos. Verifique e tente de novo.';
      }
      if (statusCode == 301 || statusCode == 302 || statusCode == 307 || statusCode == 308) {
        return 'O servidor respondeu com redirecionamento (HTTP $statusCode). '
            'Para API em HTTP direto, desative UseHttpsRedirection no backend ou use a URL HTTPS final no app.';
      }
      return 'Falha na requisição (HTTP $statusCode)';
    }
    try {
      final decoded = jsonDecode(body);
      if (decoded is List) {
        final parts = <String>[];
        for (final e in decoded) {
          if (e is Map) {
            final d = e['description'] as String? ?? e['Description'] as String?;
            if (d != null && d.isNotEmpty) parts.add(d);
          }
        }
        if (parts.isNotEmpty) return parts.join(' ');
      }
      if (decoded is! Map<String, dynamic>) {
        return body.length < 800 ? body : 'Resposta inválida do servidor (HTTP $statusCode)';
      }
      final j = decoded;
      final message = j['message'] as String?;
      final title = j['title'] as String?;
      final detail = j['detail'] as String?;
      if (message != null && message.isNotEmpty) return message;
      if (title != null && title.isNotEmpty) return title;
      if (detail != null && detail.isNotEmpty) return detail;
      final err = j['errors'];
      if (err is Map) {
        for (final v in err.values) {
          if (v is List && v.isNotEmpty) {
            final first = v.first;
            if (first is String && first.isNotEmpty) return first;
          }
        }
      }
    } catch (_) {
      return body.length < 800 ? body : 'Resposta inválida do servidor (HTTP $statusCode)';
    }
    return body.length < 800 ? body : 'Resposta inválida do servidor (HTTP $statusCode)';
  }

  void close() => _http.close();
}
