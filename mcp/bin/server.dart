/*import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

// Используем Router для чистоты кода
final router = Router();
// ...existing code...
import 'package:logging/logging.dart';

final router = Router();
final Logger _logger = Logger('server');
// ...existing code...

Future<Response> handleFingerprintData(Request req) async {
  try {
    final body = await req.readAsString();
    final jsonData = jsonDecode(body);

    // If payload comes from C# client, save to separate log file and return
    final String source = (jsonData['source'] ?? '').toString().toLowerCase();
    if (source == 'csharp') {
      final logsDir = Platform.isWindows ? '..\\logs' : '../logs';
      final logsPath = Platform.isWindows ? '..\\logs\\csharp.log' : '../logs/csharp.log';
      await Directory(logsDir).create(recursive: true);
      await File(logsPath).writeAsString('${DateTime.now().toIso8601String()} ${jsonEncode(jsonData)}\n', mode: FileMode.append);
      _logger.info('Saved C# payload to $logsPath');
      return Response.ok(jsonEncode({'status': 'saved', 'file': logsPath}), headers: {'content-type': 'application/json'});
    }

    // We expect the client to send 'type' (e.g., 'keystroke', 'sensor_acc') and 'csv_data'
    final String type = jsonData['type'] ?? 'clicks';
    final String csvRow = jsonData['touch_data_csv'] ?? '';

    if (csvRow.isEmpty) return Response.badRequest(body: 'Empty data');

    // Maps to your classifier_service directory
    final fileName = '$type.csv';
    final filePath = Platform.isWindows
        ? '..\\classifier_service\\$fileName'
        : '../classifier_service/$fileName';

    final file = File(filePath);
    await file.writeAsString('$csvRow\n', mode: FileMode.append);

    _logger.info('Logged to $fileName');
    return Response.ok(jsonEncode({'status': 'saved', 'file': fileName}),
        headers: {'content-type': 'application/json'});
  } catch (e) {
    _logger.severe('IO Error: $e');
    return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
  }
}
// ...existing code...

void main() async {
  // Configure logging output
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((rec) {
    stderr.writeln('${rec.level.name}: ${rec.time}: ${rec.loggerName}: ${rec.message}');
    // persist to rotating files (info/warning/error)
    final logName = rec.level >= Level.SEVERE
        ? 'error.log'
        : rec.level >= Level.WARNING
            ? 'warning.log'
            : 'info.log';
    final logPath = Platform.isWindows ? '..\\logs\\$logName' : '../logs/$logName';
    try {
      File(logPath).createSync(recursive: true);
      File(logPath).writeAsStringSync('${rec.time.toIso8601String()} ${rec.level.name} ${rec.loggerName}: ${rec.message}\n', mode: FileMode.append);
    } catch (_) {
      // ignore file write errors (best-effort)
    }
  });

  router.get('/', rootHandler);
  router.get('/health', (Request r) => Response.ok('OK'));
  router.post('/api/v1/fingerprint_data', handleFingerprintData);
  router.get('/api/v1/start/native', startNativeGetHandler);

  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addHandler(router);

  final server = await io.serve(handler, '0.0.0.0', 8080);
  _logger.info('--- ENOK MCP v2026 ACTIVE ---');
  _logger.info('Listening on port ${server.port} — run with: dart run server.dart (from bin/)');
}
```// filepath: c:\Games\INFINITYREBUILDINGTRUSTLOOPServerLIFEGAMESFORWINDOWSLIFE\mcp\bin\server.dart
// ...existing code...
import 'package:logging/logging.dart';

final router = Router();
final Logger _logger = Logger('server');
// ...existing code...

Future<Response> handleFingerprintData(Request req) async {
  try {
    final body = await req.readAsString();
    final jsonData = jsonDecode(body);

    // If payload comes from C# client, save to separate log file and return
    final String source = (jsonData['source'] ?? '').toString().toLowerCase();
    if (source == 'csharp') {
      final logsDir = Platform.isWindows ? '..\\logs' : '../logs';
      final logsPath = Platform.isWindows ? '..\\logs\\csharp.log' : '../logs/csharp.log';
      await Directory(logsDir).create(recursive: true);
      await File(logsPath).writeAsString('${DateTime.now().toIso8601String()} ${jsonEncode(jsonData)}\n', mode: FileMode.append);
      _logger.info('Saved C# payload to $logsPath');
      return Response.ok(jsonEncode({'status': 'saved', 'file': logsPath}), headers: {'content-type': 'application/json'});
    }

    // We expect the client to send 'type' (e.g., 'keystroke', 'sensor_acc') and 'csv_data'
    final String type = jsonData['type'] ?? 'clicks';
    final String csvRow = jsonData['touch_data_csv'] ?? '';

    if (csvRow.isEmpty) return Response.badRequest(body: 'Empty data');

    // Maps to your classifier_service directory
    final fileName = '$type.csv';
    final filePath = Platform.isWindows
        ? '..\\classifier_service\\$fileName'
        : '../classifier_service/$fileName';

    final file = File(filePath);
    await file.writeAsString('$csvRow\n', mode: FileMode.append);

    _logger.info('Logged to $fileName');
    return Response.ok(jsonEncode({'status': 'saved', 'file': fileName}),
        headers: {'content-type': 'application/json'});
  } catch (e) {
    _logger.severe('IO Error: $e');
    return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
  }
}
// ...existing code...

void main() async {
  // Configure logging output
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((rec) {
    stderr.writeln('${rec.level.name}: ${rec.time}: ${rec.loggerName}: ${rec.message}');
    // persist to rotating files (info/warning/error)
    final logName = rec.level >= Level.SEVERE
        ? 'error.log'
        : rec.level >= Level.WARNING
            ? 'warning.log'
            : 'info.log';
    final logPath = Platform.isWindows ? '..\\logs\\$logName' : '../logs/$logName';
    try {
      File(logPath).createSync(recursive: true);
      File(logPath).writeAsStringSync('${rec.time.toIso8601String()} ${rec.level.name} ${rec.loggerName}: ${rec.message}\n', mode: FileMode.append);
    } catch (_) {
      // ignore file write errors (best-effort)
    }
  });

  router.get('/', rootHandler);
  router.get('/health', (Request r) => Response.ok('OK'));
  router.post('/api/v1/fingerprint_data', handleFingerprintData);
  router.get('/api/v1/start/native', startNativeGetHandler);

  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addHandler(router);

  final server = await io.serve(handler, '0.0.0.0', 8080);
  _logger.info('--- ENOK MCP v2026 ACTIVE ---');
  _logger.info('Listening on port ${server.port} — run with: dart run server.dart (from bin/)');
}final Logger _logger = Logger('server');
Future<Response> handleFingerprintData(Request req) async {
  final body = await req.readAsString();
  
  // Путь к файлу clicks.csv относительно места запуска MCP
  final clicksFilePath = Platform.isWindows 
      ? '..\\classifier_service\\clicks.csv' 
      : '../classifier_service/clicks.csv';

  try {
    // Добавляем новые строки в конец файла
    final file = File(clicksFilePath);
    // Декодируем JSON, чтобы извлечь touch_csv данные из body (как в touch.html JS)
    final jsonData = jsonDecode(body);
    final touchCsvData = jsonData['touch_data_csv'] ?? '';

    if (touchCsvData.isNotEmpty) {
      await file.writeAsString(touchCsvData + '\n', mode: FileMode.append);
      print("Добавлены новые строки в clicks.csv.");
    }

    return Response.ok(jsonEncode({'status': 'received', 'message': 'Data saved to clicks.csv'}), headers: {'content-type': 'application/json'});
  } catch (e) {
    print("Ошибка сохранения данных в файл: $e");
    return Response.internalServerError(body: jsonEncode({'error': 'Failed to save data: $e'}));
  }
}

Future<Response> rootHandler(Request req) async {
  return Response.ok(
    jsonEncode({'message': 'Welcome to Enok MCP v2026', 'status': 'online', 'domain': 'bjfirstplaygamesworld.com'}),
    headers: {'content-type': 'application/json'}
  );
}
Future<Response> startHandler(Request req) async {
  try {
    final body = jsonDecode(await req.readAsString());
    final String name = body['name'] ?? 'server_${DateTime.now().millisecondsSinceEpoch}';
    final String type = body['type'] ?? 'docker'; // 'docker' или 'native'
    final String command = body['command'] ?? ''; // Путь к exe/bat или имя образа
    final int port = body['port'] ?? 27015;

    ProcessResult result;

    if (type == 'docker') {
      // Запуск через Docker
      result = await Process.run('docker', [
        'run', '-d', '--name', name, '-p', '$port:$port/udp', command
      ]);
    } else {
      // Запуск нативного Windows процесса (HLDS.exe или CoD_MW3.exe)
      // Используем start для запуска в отдельном окне, чтобы не блокировать MCP
      result = await Process.run('cmd', ['/c', 'start', '/b', command, '+port', '$port']);
    }

    if (result.exitCode != 0) {
      return Response.internalServerError(
        body: jsonEncode({'error': result.stderr, 'code': result.exitCode}),
        headers: {'content-type': 'application/json'}
      );
    }

    return Response.ok(
      jsonEncode({'status': 'started', 'name': name, 'info': result.stdout.toString().trim()}),
      headers: {'content-type': 'application/json'}
    );
  } catch (e) {
    return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
  }
}

// Эндпоинт для проверки статуса
Future<Response> healthHandler(Request req) async {
  return Response.ok(jsonEncode({'status': 'Enok MCP is online', 'domain': 'bjfirstplaygamesworld.com'}));
}

// Новый обработчик: отдаёт Rain VoiceOver MP3
Future<Response> montanaVoiceHandler(Request req) async {
  // Путь к файлу voiceover
  final voicePath = Platform.isWindows ? '..\\assets\\montana_voiceover.mp3' : '../assets/montana_voiceover.mp3';
  final file = File(voicePath);

  if (!await file.exists()) {
    // Если файла нет — возвращаем понятную ошибку
    return Response.notFound(jsonEncode({
      'error': 'Voiceover file not found',
      'hint': 'Place montana_voiceover.mp3 in ../assets relative to the server executable'
    }), headers: {'content-type': 'application/json'});
  }

  try {
    final bytes = await file.readAsBytes();
    // Отдаём аудио с корректным Content-Type
    return Response.ok(bytes, headers: {
      'content-type': 'audio/mpeg',
      'content-length': bytes.length.toString(),
      // необязательно: подсказка браузю, что это вложение, если нужно скачать
      // 'content-disposition': 'inline; filename="rain_voiceover.mp3"'
    });
  } catch (e) {
    return Response.internalServerError(body: jsonEncode({'error': e.toString()}), headers: {'content-type': 'application/json'});
  }
}

// Examples:
//  - Start native HLDS via browser: http://localhost:8080/api/v1/start/native?command=C:\path\to\hlds.exe&port=27015
//  - Or via curl: curl "http://localhost:8080/api/v1/start/native?command=C:\path\to\hlds.exe&port=27015"
Future<Response> startNativeGetHandler(Request req) async {
  try {
    final q = req.url.queryParameters;
    final String command = q['command'] ?? '';
    if (command.isEmpty) {
      return Response(400,
          body: jsonEncode({'error': 'Missing required query parameter: command'}),
          headers: {'content-type': 'application/json'});
    }

    final int port = int.tryParse(q['port'] ?? '27015') ?? 27015;
    final String name = q['name'] ?? 'server_${DateTime.now().millisecondsSinceEpoch}';
    final String argsRaw = q['args'] ?? '';
    final List<String> args = argsRaw.isNotEmpty
        ? argsRaw.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList()
        : ['+port', '$port'];

    // Запуск в отсоединённом режиме, чтобы MCP не блокировал, а процесс продолжал работать независимо
    Process process;
    if (Platform.isWindows) {
      // Используем cmd start для отсоединения и запуска в фоновом режиме
      final cmdArgs = ['/c', 'start', '/b', command, ...args];
      process = await Process.start('cmd', cmdArgs, mode: ProcessStartMode.detached);
    } else {
      process = await Process.start(command, args, mode: ProcessStartMode.detached);
    }

    _logger.info('Запущен нативный сервер "$name" command="$command" args=$args pid=${process.pid}');
    return Response.ok(
        jsonEncode({'status': 'started', 'name': name, 'pid': process.pid, 'command': command, 'args': args}),
        headers: {'content-type': 'application/json'});
  } catch (e) {
    return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}), headers: {'content-type': 'application/json'});
  }
}

void main() async {
  // Добавляем новый роут для корневого адреса
  router.get('/', rootHandler); 
  
  router.post('/api/v1/start', startHandler);
  router.get('/health', healthHandler);
  router.post('/api/v1/fingerprint_data', handleFingerprintData); // Если используете сбор данных

  // Роут для Rain VoiceOver
  router.get('/voiceover/rain', montanaVoiceHandler);

  // Register the new GET route
  router.get('/api/v1/start/native', startNativeGetHandler);

  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addHandler(router);

  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await io.serve(handler, '0.0.0.0', port);
  
  print('--- MCP ENOK STARTED ---');
  print('Domain: bjfirstplaygamesworld.com');
  print('Local: http://localhost:$port');
  print('Listening on all interfaces...');
} */
///Wednesday, January 21, 2026 11:49:16 AM
///Пытался добавить ей внутриигровой голос....чтото не получилось =(
///Wednesday, January 21, 2026 7:24:33 PM Add to Her brain FULL DATA as She Conqueror.
/*import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:logging/logging.dart';
import 'package:web_socket_channel/io.dart';
final router = Router();
final log = Logger('MCPLogger');
// Unified handler for all 15+ CSV types defined in your nn_oop.py
Future<Response> handleFingerprintData(Request req) async {
  try {
    final body = await req.readAsString();
    final jsonData = jsonDecode(body);
    
    // We expect the client to send 'type' (e.g., 'keystroke', 'sensor_acc') and 'csv_data'
    final String type = jsonData['type'] ?? 'clicks'; 
    final String csvRow = jsonData['touch_data_csv'] ?? '';

    if (csvRow.isEmpty) return Response.badRequest(body: 'Empty data');
    // Maps to your classifier_service directory
    final fileName = '$type.csv';
    final filePath = Platform.isWindows
        ? '..\\classifier_service\\$fileName'
        : '../classifier_service/$fileName';

    final file = File(filePath);
    await file.writeAsString('$csvRow\n', mode: FileMode.append);
   
    log.info('Logged to $fileName'); 
    return Response.ok(jsonEncode({'status': 'saved', 'file': fileName}),
        headers: {'content-type': 'application/json'});
    } catch (e) {
    log.severe('IO Error: $e');
    return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
  }
}
Future<Response> rootHandler(Request req) async {
  return Response.ok(
      jsonEncode({
        'message': 'Welcome to Enok MCP v2026', 
        'status': 'online', 
        'domain': 'bjfirstplaygamesworld.com',
        'nn_compat': 'OOP_v2_LSTM_1024'
      }),
      headers: {'content-type': 'application/json'});
}
Future<Response> startHandler(Request req) async {
  try {
    final body = jsonDecode(await req.readAsString());
    final String name = body['name'] ?? 'server_${DateTime.now().millisecondsSinceEpoch}';
    final String type = body['type'] ?? 'docker'; // 'docker' или 'native'
    final String command = body['command'] ?? ''; // Путь к exe/bat или имя образа
    final int port = body['port'] ?? 27015;
    // Можно добавить сюда чтение списка аргументов "args" из JSON-тела запроса
    ProcessResult result;
    if (type == 'docker') {
      // Запуск через Docker
      result = await Process.run('docker', [
        'run', '-d', '--name', name, '-p', '$port:$port/udp', command
      ]);
    } else {
      // Запуск нативного Windows процесса (HLDS.exe или CoD_MW3.exe)
      // Используем start для запуска в отдельном окне, чтобы не блокировать MCP
      // Если нужны аргументы типа "-console", их нужно добавить в этот список:
      result = await Process.run('cmd', ['/c', 'start', '/b', command, '+port', '$port']);
    }

    if (result.exitCode != 0) {
      return Response.internalServerError(
          body: jsonEncode({'error': result.stderr, 'code': result.exitCode}),
          headers: {'content-type': 'application/json'});
    }
    return Response.ok(
        jsonEncode({'status': 'started', 'name': name, 'info': result.stdout.toString().trim()}),
        headers: {'content-type': 'application/json'});
  } catch (e) {
    return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
  }
}
// Эндпоинт для проверки статуса
Future<Response> healthHandler(Request req) async {
  return Response.ok(jsonEncode({'status': 'Enok MCP is online', 'domain': 'bjfirstplaygamesworld.com'}));
}
// Новый обработчик: отдаёт Rain VoiceOver MP3
Future<Response> montanaVoiceHandler(Request req) async {
  // Путь к файлу voiceover
  final voicePath = Platform.isWindows ? '..\\assets\\montana_voiceover.mp3' : '../assets/montana_voiceover.mp3';
  final file = File(voicePath);

  if (!await file.exists()) {
    // Если файла нет — возвращаем понятную ошибку
    return Response.notFound(jsonEncode({
      'error': 'Voiceover file not found',
      'hint': 'Place montana_voiceover.mp3 in ../assets relative to the server executable'
    }), headers: {'content-type': 'application/json'});
  }

  try {
    final bytes = await file.readAsBytes();
    // Отдаём аудио с корректным Content-Type
    return Response.ok(bytes, headers: {
      'content-type': 'audio/mpeg',
      'content-length': bytes.length.toString(),
      // необязательно: подсказка браузю, что это вложение, если нужно скачать
      // 'content-disposition': 'inline; filename="rain_voiceover.mp3"'
    });
  } catch (e) {
    return Response.internalServerError(body: jsonEncode({'error': e.toString()}), headers: {'content-type': 'application/json'});
  }
}
// Examples:
//  - Start native HLDS via browser: http://localhost:8080/api/v1/start/native?command=C:\path\to\hlds.exe&port=27015
//  - Or via curl: curl "http://localhost:8080/api/v1/start/native?command=C:\path\to\hlds.exe&port=27015"
Future<Response> startNativeGetHandler(Request req) async {
  try {
    final q = req.url.queryParameters;
    final String command = q['command'] ?? '';
    if (command.isEmpty) {
      return Response(400,
          body: jsonEncode({'error': 'Missing required query parameter: command'}),
          headers: {'content-type': 'application/json'});
    }

    final int port = int.tryParse(q['port'] ?? '27015') ?? 27015;
    final String name = q['name'] ?? 'server_${DateTime.now().millisecondsSinceEpoch}';
    final String argsRaw = q['args'] ?? '';
    final List<String> args = argsRaw.isNotEmpty
        ? argsRaw.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList()
        : ['+port', '$port'];

    // Запуск в отсоединённом режиме, чтобы MCP не блокировал, а процесс продолжал работать независимо
    Process process;
    if (Platform.isWindows) {
      // Используем cmd start для отсоединения и запуска в фоновом режиме
      final cmdArgs = ['/c', 'start', '/b', command, ...args];
      process = await Process.start('cmd', cmdArgs, mode: ProcessStartMode.detached);
    } else {
      process = await Process.start(command, args, mode: ProcessStartMode.detached);
    }

    print('Запущен нативный сервер "$name" command="$command" args=$args pid=${process.pid}');
    return Response.ok(
        jsonEncode({'status': 'started', 'name': name, 'pid': process.pid, 'command': command, 'args': args}),
        headers: {'content-type': 'application/json'});
  } catch (e) {
    return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}), headers: {'content-type': 'application/json'});
  }
}
void main() async {
  // Configure logging output
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((rec) {
    stderr.writeln('${rec.level.name}: ${rec.time}: ${rec.loggerName}: ${rec.message}');
  });

  router.get('/', rootHandler);
  router.get('/health', (Request r) => Response.ok('OK'));
  router.post('/api/v1/fingerprint_data', handleFingerprintData);
  router.post('/start_legacy', (Request req) async {
  // Путь к вашему selects.exe (2001 год)
  final toolkitPath = '..\\extra\\os2tk\\samples\\tcpiptk\\socket\\selects.exe';
  final process = await Process.start(toolkitPath, [], runInShell: true);

  return Response.ok(jsonEncode({'status': 'ok', 'pid': process.pid}));
});
  //router.get('/api/v1/start/native', startNativeHandler);
  router.get('/api/v1/start/native', startNativeGetHandler);

  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addHandler(router);

  final server = await io.serve(handler, '0.0.0.0', 8080);
  log.shout('--- ENOK MCP v2026 ACTIVE ---'); // SHOUT для красоты старта
  log.info('Listening on port ${server.port}'); 
} */
// filepath: c:\Games\INFINITYREBUILDINGTRUSTLOOPServerLIFEGAMESFORWINDOWSLIFE\mcp\bin\server.dart

import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:logging/logging.dart';

// Настройка логгера
final Logger _logger = Logger('ENOK_MCP_V2');
final router = Router();

// --- ОБРАБОТЧИКИ ДАННЫХ (FINGERPRINTING & C# LOGS) ---

Future<Response> handleFingerprintData(Request req) async {
  try {
    final body = await req.readAsString();
    final jsonData = jsonDecode(body);
    final String source = (jsonData['source'] ?? 'unknown').toString().toLowerCase();
    
    // Если данные пришли от вашего нового C# StarterManager/MiniKernel
    if (source == 'csharp' || source == 'mcore') {
      final logsPath = Platform.isWindows ? '..\\logs\\mcore_system.log' : '../logs/mcore_system.log';
      await File(logsPath).writeAsString(
        '${DateTime.now().toIso8601String()} [${jsonData['level'] ?? 'INFO'}] ${jsonData['message'] ?? jsonEncode(jsonData)}\n',
        mode: FileMode.append,
        flush: true
      );
      return Response.ok(jsonEncode({'status': 'logged_to_mcore'}), headers: {'content-type': 'application/json'});
    }

    // Стандартная обработка для NN (LSTM 1024)
    final String type = jsonData['type'] ?? 'clicks';
    final String csvRow = jsonData['touch_data_csv'] ?? '';
    if (csvRow.isEmpty) return Response.badRequest(body: 'Empty CSV payload');

    final filePath = Platform.isWindows 
        ? '..\\classifier_service\\$type.csv' 
        : '../classifier_service/$type.csv';
    
    await File(filePath).writeAsString('$csvRow\n', mode: FileMode.append);
    _logger.info('Data appended to $type.csv');
    
    return Response.ok(jsonEncode({'status': 'saved', 'target': type}), headers: {'content-type': 'application/json'});
  } catch (e) {
    _logger.severe('Data handling error: $e');
    return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
  }
}

// --- УПРАВЛЕНИЕ ЗАПУСКОМ (ROBLOX / HLDS / LEGACY) ---

Future<Response> startNativeHandler(Request req) async {
  try {
    final q = req.url.queryParameters;
    final command = q['command'] ?? '';
    final isGame = q['type'] == 'game'; // Специальный флаг для Roblox/Demon

    if (command.isEmpty) return Response.badRequest(body: 'No command provided');

    // Если это Roblox или современная игра, используем 'start' для отсоединения
    Process process;
    if (Platform.isWindows) {
      process = await Process.start('cmd', ['/c', 'start', '/b', command], mode: ProcessStartMode.detached);
    } else {
      process = await Process.start(command, [], mode: ProcessStartMode.detached);
    }

    _logger.shout('EXECUTION: ${isGame ? "LAUNCHING THE DEMON" : "STARTING NATIVE"} -> $command (PID: ${process.pid})');
    
    return Response.ok(jsonEncode({
      'status': 'executed',
      'pid': process.pid,
      'is_game': isGame,
      'timestamp': DateTime.now().toIso8601String()
    }), headers: {'content-type': 'application/json'});
  } catch (e) {
    return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
  }
}

// --- КОНФИГУРАЦИЯ ДЛЯ MCORE (C# SPLASH SCREEN) ---

Future<Response> getMcoreConfig(Request req) async {
  // Отдаем конфиг для вашего SplashScreenManager
  final configPath = Platform.isWindows ? '..\\config.xml' : '../config.xml';
  final file = File(configPath);
  if (await file.exists()) {
    return Response.ok(await file.readAsString(), headers: {'content-type': 'text/xml'});
  }
  return Response.notFound('Config not found');
}

// --- ОСНОВНЫЕ МАРШРУТЫ ---

Future<Response> rootHandler(Request req) async {
  return Response.ok(jsonEncode({
    'system': 'ENOK MCP v2026',
    'status': 'OPERATIONAL',
    'realogia': 'Conqueror_Brain_v2',
    'mcore_compat': true,
    'roblox_ready': true
  }), headers: {'content-type': 'application/json'});
}

void main() async {
  // Настройка логирования в файлы
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((rec) {
    print('${rec.time}: ${rec.level.name}: ${rec.message}');
  });

  // Роутинг
  router.get('/', rootHandler);
  router.get('/health', (Request r) => Response.ok('ALIVE'));
  
  // Конфиги для C# части
  router.get('/mcore/config', getMcoreConfig);
  
  // API для данных
  router.post('/api/v1/fingerprint_data', handleFingerprintData);
  
  // Запуск процессов (Нативные игры, Roblox, Legacy EXE)
  router.get('/api/v1/start/native', startNativeHandler);
  
  // Голос Монтаны
  router.get('/voiceover/montana', (Request req) async {
    final file = File(Platform.isWindows ? '..\\assets\\montana_voiceover.mp3' : '../assets/montana_voiceover.mp3');
    if (await file.exists()) {
      return Response.ok(file.openRead(), headers: {'content-type': 'audio/mpeg'});
    }
    return Response.notFound('Voice file missing');
  });

  // Запуск сервера
  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addHandler(router);

  final server = await io.serve(handler, '0.0.0.0', 8080);
  
  _logger.shout('''
  =========================================
  --- ENOK MCP v2026 : REALOGIA ACTIVE ---
  =========================================
  Listening on: http://${server.address.address}:${server.port}
  MCORE Bootstrap: http://localhost:8080/mcore/config
  Status: Waiting for C# Client & The Demon...
  =========================================
  ''');
}