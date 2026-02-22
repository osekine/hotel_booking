import 'dart:io' show Platform;

String resolveGraphqlUrl() {
  const explicit = String.fromEnvironment('API_BASE_URL', defaultValue: '');
  if (explicit.trim().isNotEmpty) return explicit.trim();

  const portStr = String.fromEnvironment('API_PORT', defaultValue: '4000');
  final port = int.tryParse(portStr) ?? 4000;

  const hostOverride = String.fromEnvironment('API_HOST', defaultValue: '');
  final host = hostOverride.trim().isNotEmpty
      ? hostOverride.trim()
      : (Platform.isAndroid ? '10.0.2.2' : 'localhost');

  return 'http://$host:$port/graphql';
}
