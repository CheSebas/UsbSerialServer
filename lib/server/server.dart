// Archivo server.dart
import 'dart:io';
import 'dart:typed_data';

import 'package:app/server/class/models.dart';

class WebSocketServer {
  WebSocketServer({required this.onError, required this.onData});

  Uint8ListCallback onData;
  DynamicCallback onError;

  HttpServer? _server; 
  bool running = false;
  List<WebSocket> _clients = [];

  Future<void> start() async {
    try {
      _server = await HttpServer.bind('localhost', 8910);
      this.running = true;
      _server?.listen((HttpRequest request) {
        if (WebSocketTransformer.isUpgradeRequest(request)) {
          WebSocketTransformer.upgrade(request).then((WebSocket socket) {
            _clients.add(socket);
            socket.listen(
              (data) {
                onData(Uint8List.fromList(data));
                broadCast(String.fromCharCodes(data)); // Broadcast the message
              },
              onDone: () {
                _clients.remove(socket);
              },
              onError: (error) {
                onError(error);
              },
            );
          });
        } else {
          request.response.statusCode = HttpStatus.forbidden;
          request.response.close();
        }
      });
      onData(Uint8List.fromList('WebSocket server listening on port 8910'.codeUnits));
    } catch (e) {
      onError(e);
    }
  }

  Future<void> stop() async {
    await _server?.close();
    _server = null;
    this.running = false;
  }

  void broadCast(String message) {
    onData(Uint8List.fromList('Broadcasting: $message'.codeUnits)); // Optional: log broadcasting
    for (var client in _clients) {
      client.add(message);
    }
  }
}



// -------------------------------------------------------------------------------------------------------


// // import 'dart:async';
// import 'dart:io';
// import 'dart:typed_data';
// import 'class/models.dart';

// class WebSocketServer {
//   WebSocketServer({required this.onError, required this.onData});

//   Uint8ListCallback onData;
//   DynamicCallback onError;

//   HttpServer? _server; 
//   bool running = false;
//   List<WebSocket> _clients = [];

//   start() async {
//     try {
//       _server = await HttpServer.bind('localhost', 8910);
//       this.running = true;
//       _server?.listen((HttpRequest request) {
//         if (WebSocketTransformer.isUpgradeRequest(request)) {
//           WebSocketTransformer.upgrade(request).then((WebSocket socket) {
//             _clients.add(socket);
//             socket.listen((data) {
//               this.onData(Uint8List.fromList(data.codeUnits));
//               broadCast(data); 
//             }, onDone: () {
//               _clients.remove(socket);
//             });
//           });
//         } else {
//           request.response.statusCode = HttpStatus.forbidden;
//           request.response.close();
//         }
//       });
//       this.onData(Uint8List.fromList('WebSocket server listening on port 8910'.codeUnits));
//     } catch (e) {
//       this.onError(e);
//     }
//   }

//   stop() async {
//     await _server?.close();
//     _server = null;
//     this.running = false;
//   }

//   broadCast(String message) {
//     this.onData(Uint8List.fromList('Broadcasting: $message'.codeUnits));
//     for (var client in _clients) {
//       client.add(message);
//     }
//   }
// }