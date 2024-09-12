// Archivo usb_serial_state.dart
import 'package:app/server/server.dart';
import 'package:flutter/material.dart';
import 'package:usb_serial/usb_serial.dart';
import 'usb_serial_device.dart';

class UsbSerialState extends ChangeNotifier {
  UsbSerialDevice _device = UsbSerialDevice();
  List<UsbDevice> _ports = [];
  List<String> _serialData = [];
  WebSocketServer? _server; // Añade esto

  List<UsbDevice> get ports => _ports;
  List<String> get serialData => _serialData;
  UsbSerialDevice get device => _device;

  UsbSerialState() {
    UsbSerial.usbEventStream?.listen((UsbEvent event) {
      _getPorts();
    });

    _getPorts();

    // Escuchar datos recibidos desde el dispositivo
    _device.addDataListener((data) {
      _serialData = data;
      notifyListeners();
      _broadcastSerialData(); // Envía los datos al servidor WebSocket
    });
  }

  void _getPorts() async {
    _device.getPorts((devices) {
      _ports = devices;
      notifyListeners();
    });
  }

  Future<void> connectTo(UsbDevice device) async {
    if (_device.deviceId == device.deviceId) {
      _device.dispose(); // Limpia el dispositivo actual
    }
    await _device.connectTo(device);
    _getPorts(); // Actualiza la lista de puertos
    notifyListeners(); // Notifica a los listeners sobre el estado del dispositivo
  }

  Future<void> sendData(String data) async {
    if (_device.deviceId != null) {
      await _device.sendData(data);
    }
  }

  //
  void _broadcastSerialData() {
    if (_server != null) {
      final message = _serialData.join('\n'); // Convertir los datos a un formato adecuado
      _server!.broadCast(message);
    }
  }

  void setServer(WebSocketServer server) {
    _server = server;
  }
  //

  @override
  void dispose() {
    _device.dispose();
    super.dispose();
  }
}


// -----------------------------------------------------------------


// import 'package:flutter/material.dart';
// import 'package:usb_serial/usb_serial.dart';
// import 'usb_serial_device.dart';

// class UsbSerialState extends ChangeNotifier {
//   UsbSerialDevice _device = UsbSerialDevice();
//   List<UsbDevice> _ports = [];
//   List<String> _serialData = [];

//   List<UsbDevice> get ports => _ports;
//   List<String> get serialData => _serialData;
//   UsbSerialDevice get device => _device;

//   UsbSerialState() {
//     UsbSerial.usbEventStream?.listen((UsbEvent event) {
//       _getPorts();
//     });

//     _getPorts();

//     // Escuchar datos recibidos desde el dispositivo
//     _device.addDataListener((data) {
//       _serialData = data;
//       notifyListeners();
//     });
//   }

//   void _getPorts() async {
//     _device.getPorts((devices) {
//       _ports = devices;
//       notifyListeners();
//     });
//   }

//   Future<void> connectTo(UsbDevice device) async {
//     if (_device.deviceId == device.deviceId) {
//       _device.dispose(); // Limpia el dispositivo actual
//     }
//     await _device.connectTo(device);
//     _getPorts(); // Actualiza la lista de puertos
//     notifyListeners(); // Notifica a los listeners sobre el estado del dispositivo
//   }

//   Future<void> sendData(String data) async {
//     if (_device.deviceId != null) {
//       await _device.sendData(data);
//     }
//   }

//   @override
//   void dispose() {
//     _device.dispose();
//     super.dispose();
//   }
// }


// ----------------------------------------------------------------------


// class UsbSerialState extends ChangeNotifier {
//   UsbSerialDevice _device = UsbSerialDevice();
//   List<UsbDevice> _ports = [];
//   List<String> _serialData = [];

//   List<UsbDevice> get ports => _ports;
//   List<String> get serialData => _serialData;

//   UsbSerialDevice get device => _device;

//   UsbSerialState() {
//     UsbSerial.usbEventStream?.listen((UsbEvent event) {
//       _getPorts();
//     });

//     _getPorts();
//   }

//   void _getPorts() {
//     _device.getPorts((devices) {
//       _ports = devices;
//       notifyListeners();
//     });
//   }


//   Future<void> connectTo(UsbDevice device) async {
//   if (_device.deviceId == device.deviceId) { // Si la biblioteca tiene una forma de verificar la conexión
//     // Realiza cualquier limpieza o liberación necesaria aquí
//     _device.dispose(); // O usa un método similar para liberar recursos
//     _device = UsbSerialDevice(); // Re-inicializa el dispositivo
//   }
//   await _device.connectTo(device); // Conecta al nuevo dispositivo
//   _getPorts();
// }


//   Future<void> sendData(String data) async {
//     if (_device.deviceId != null) {
//       await _device.sendData(data);
//     }
//   }

//   @override
//   void dispose() {
//     _device.dispose();
//     super.dispose();
//   }
// }
