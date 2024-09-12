// Archivo server_state.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'server.dart';


class ServerState extends ChangeNotifier {
  late WebSocketServer _server;
  bool _running = false;
  List<String> _logs = [];

  bool get running => _running;
  List<String> get logs => _logs;
  WebSocketServer get server => _server; // Agrega esto

  ServerState() {
    _server = WebSocketServer(
      onData: onData,
      onError: onError,
    );
  }

  void onData(Uint8List data) {
    DateTime time = DateTime.now();
    String log = "${time.hour}h${time.minute} : ${String.fromCharCodes(data)}";
    _logs.add(log);
    notifyListeners();
  }

  void onError(dynamic error) {
    _logs.add("Error: $error");
    notifyListeners();
  }

  Future<void> startServer() async {
    if (!_running) {
      _running = true;
      await _server.start();
      notifyListeners();
    }
  }

  Future<void> stopServer() async {
    if (_running) {
      _running = false;
      await _server.stop();
      _logs.clear();
      notifyListeners();
    }
  }

  void broadcast(String message) {
    if (_running) {
      _server.broadCast(message);
    }
  }

  @override
  void dispose() {
    _server.stop(); // Make sure stop() is awaited
    super.dispose();
  }
}


// --------------------------------------------------------------


// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'server.dart';

// class ServerState extends ChangeNotifier {
//   late WebSocketServer _server;
//   bool _running = false;
//   List<String> _logs = [];

//   bool get running => _running;
//   List<String> get logs => _logs;

//   ServerState() {
//     _server = WebSocketServer(
//       onData: onData,
//       onError: onError,
//     );
//   }

//   void onData(Uint8List data) {
//     DateTime time = DateTime.now();
//     String log = "${time.hour}h${time.minute} : ${String.fromCharCodes(data)}";
//     _logs.add(log);
//     notifyListeners();
//   }

//   void onError(dynamic error) {
//     _logs.add("Error: $error");
//     notifyListeners();
//   }

//   Future<void> startServer() async {
//     if (!_running) {
//       _running = true;
//       await _server.start();
//       notifyListeners();
//     }
//   }

//   Future<void> stopServer() async {
//     if (_running) {
//       _running = false;
//       await _server.stop();
//       _logs.clear();
//       notifyListeners();
//     }
//   }

//   void broadcast(String message) {
//     if (_running) {
//       _server.broadCast(message);
//     }
//   }

//   @override
//   void dispose() {
//     _server.stop();
//     super.dispose();
//   }
// }
