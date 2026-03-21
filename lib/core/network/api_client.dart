/// Cliente HTTP base (Dio ou `package:http`) com interceptors de auth e logging.
/// Implementação concreta fica em `data` ou `core/network`.
abstract class ApiClient {
  Future<dynamic> get(String path, {Map<String, String>? query});
  Future<dynamic> post(String path, {Map<String, dynamic>? body});
  Future<dynamic> patch(String path, {Map<String, dynamic>? body});
  Future<void> delete(String path);
}
