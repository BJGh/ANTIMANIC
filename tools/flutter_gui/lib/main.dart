import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;

class IpxEmulatorScreen extends StatefulWidget {
  @override
  _IpxEmulatorScreenState createState() => _IpxEmulatorScreenState();
}

class _IpxEmulatorScreenState extends State<IpxEmulatorScreen> {
  WebSocketChannel? _channel;
  bool _gameLaunched = false;
  String _wsStatus = "Disconnected";

  Future<String> _startLegacyServer() async {
    final response = await http.post(Uri.parse('http://localhost:8080/start_legacy'));
    if (response.statusCode == 200) {
      return "2001 Server Active (PID: ${jsonDecode(response.body)['pid']})";
    } else {
      throw "Failed to start legacy system";
    }
  }

  void _connectWS() {
    // Подключаемся к эмулятору через WebSocket
    setState(() {
      _wsStatus = "Connecting...";
    });
    final ws = IOWebSocketChannel.connect('ws://localhost:4040'); // Укажи тут свой порт, если другой!
    ws.sink.done.catchError((_) {
      setState(() {
        _wsStatus = "Disconnected";
      });
    });
    ws.stream.listen((msg) {
      setState(() {
        _wsStatus = "WS Message: $msg";
      });
    }, onDone: () {
      setState(() {
        _wsStatus = "Disconnected";
      });
    }, onError: (e) {
      setState(() {
        _wsStatus = "Error: $e";
      });
    });
    setState(() {
      _channel = ws;
      _wsStatus = "Connected";
    });
  }

  void _launchInsaneGame() {
    _channel?.sink.add(jsonEncode({"cmd":"start_game","payload":"1nsane"}));
    setState(() {
      _gameLaunched = true;
      _wsStatus = "Sent start_game command";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("1nsanetTM Legacy Bridge")),
      body: FutureBuilder<String>(
        future: _startLegacyServer(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Ждем оживления прошлого
          } else if (snapshot.hasError) {
            return Center(child: Text("ERROR: ${snapshot.error}"));
          } else {
            // Сервер запущен! Теперь подключаем ваш WebSocket-трюк и меню
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Legacy Server: ${snapshot.data}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: Icon(Icons.usb),
                    label: Text("Подключиться по WebSocket"),
                    onPressed: _channel == null ? _connectWS : null,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    icon: Icon(Icons.sports_esports),
                    label: Text("Запустить 1nsane VideogameTM"),
                    onPressed: (_channel != null && !_gameLaunched) ? _launchInsaneGame : null,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Статус WebSocket: $_wsStatus",
                    style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                  ),
                  SizedBox(height: 30),
                  if (_gameLaunched)
                    Text(
                      "🎮 1nsane VideogameTM В ДЕЙСТВИИ!",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 18),
                    ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}