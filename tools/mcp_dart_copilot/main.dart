// MCP Dart Copilot — minimal stub server
// Run with: `dart run tools/mcp_dart_copilot/main.dart`

import 'dart:convert';
import 'dart:io';

Future<void> main(List<String> args) async {
  final port = int.tryParse(Platform.environment['MCP_PORT'] ?? '') ?? 8080;
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
  print('MCP Dart Copilot stub listening on http://localhost:$port');

  await for (final req in server) {
    if (req.requestedUri.path == '/ping') {
      req.response
        ..statusCode = 200
        ..headers.contentType = ContentType.json
        ..write(jsonEncode({'status': 'ok', 'service': 'MCPDartCopilot'}))
        ..close();
      continue;
    }

    /*if (req.requestedUri.path == '/mcp' && req.method == 'POST') {
      final body = await utf8.decoder.bind(req).join();
      // echo MCP message for now
      req.response
        ..statusCode = 200
        ..headers.contentType = ContentType.json
        ..write(jsonEncode({'received': body}))
        ..close();
      continue;
    } */
  if (req.requestedUri.path == '/start_legacy' && req.method == 'POST') {
      // Путь к вашему серверу 2001 года
      final toolkitPath = '..\\extra\\os2tk\\samples\\tcpiptk\\socket\\selects.exe';

      try {
        // Запуск процесса напрямую через MCP
        final process = await Process.start(toolkitPath, [], runInShell: true);

        print('--- OS/2 WARP SERVER 2001 ACTIVATED ---');

        req.response
          ..statusCode = 200
          ..headers.contentType = ContentType.json
          ..write(jsonEncode({'status': 'started', 'pid': process.pid}))
          ..close();
      } catch (e) {
        req.response
          ..statusCode = 500
          ..write('Error starting legacy server: $e')
          ..close();
      }
      continue;
    }

    // default: 404
    req.response
      ..statusCode = 404
      ..write('Not found')
      ..close();
  }
}
