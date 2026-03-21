/// Base URL da API Biblia Reader (VPS). Troque em build flavors ou override com `--dart-define`.
class ApiConfig {
  ApiConfig._();

  static const String baseUrl = String.fromEnvironment(
    'BIBLIA_API_BASE_URL',
    defaultValue: 'http://72.61.35.190:5001',
  );

  static Uri uri(String path, [Map<String, String>? query]) {
    final base = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    final p = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$base$p').replace(queryParameters: query);
  }
}
