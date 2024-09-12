//Archivo usb_serial_device.dart
import 'dart:async';
import 'dart:typed_data';
import 'package:usb_serial/transaction.dart';
import 'package:usb_serial/usb_serial.dart';


// Controlador de flujo para gestionar los datos seriales
final StreamController<String> _serialStreamController = StreamController<String>();

class UsbSerialDevice {
  UsbPort? _port;
  String _status = "Idle";
  List<String> _serialData = [];
  StreamSubscription<String>? _subscription;
  Transaction<String>? _transaction;
  int? _deviceId;

  // Callback para notificar nuevos datos
  void Function(List<String>)? onDataReceived;

  Future<bool> connectTo(UsbDevice? device) async {
    if (_subscription != null) {
      await _subscription!.cancel();
      _subscription = null;
    }

    if (_transaction != null) {
      _transaction!.dispose();
      _transaction = null;
    }

    if (_port != null) {
      await _port!.close();
      _port = null;
    }

    if (device == null) {
      _deviceId = null;
      _status = "Disconnected";
      return true;
    }

    _port = await device.create();
    if (!await _port!.open()) {
      _status = "Failed to open port";
      return false;
    }

    _deviceId = device.deviceId;
    await _port!.setDTR(true);
    await _port!.setRTS(true);
    await _port!.setPortParameters(
        115200, UsbPort.DATABITS_8, UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);

    if (_port!.inputStream != null) {
      _transaction = Transaction.stringTerminated(
          _port!.inputStream!, Uint8List.fromList([13, 10]));

      _subscription = _transaction!.stream.listen((String line) {
        _serialData.add(line);
        if (_serialData.length > 20) {
          _serialData.removeAt(0);
        }
        // Notificar a los listeners
        onDataReceived?.call(_serialData);
      });
    } else {
      _status = "Failed to listen to port";
      return false;
    }

    _status = "Connected";
    return true;
  }

  void getPorts(Function(List<UsbDevice>) onDevicesRetrieved) async {
    List<UsbDevice> devices = await UsbSerial.listDevices();
    onDevicesRetrieved(devices);
  }

  void addDataListener(void Function(List<String>) onData) {
    onDataReceived = onData;
  }


  Future<void> sendData(String data) async {
    if (_port != null) {
      data = "${data}\r\n";
      await _port!.write(Uint8List.fromList(data.codeUnits));
    }
  }

  void dispose() async {
    await connectTo(null);
  }

  String get status => _status;
  List<String> get serialData => _serialData;
  int? get deviceId => _deviceId;
}


// -------------------------------------------------------


// import 'dart:async';
// import 'dart:typed_data';
// import 'package:usb_serial/transaction.dart';
// import 'package:usb_serial/usb_serial.dart';


// // Controlador de flujo para gestionar los datos seriales
// final StreamController<String> _serialStreamController = StreamController<String>();

// class UsbSerialDevice {
//   UsbPort? _port;
//   String _status = "Idle";
//   List<String> _serialData = [];
//   StreamSubscription<String>? _subscription;
//   Transaction<String>? _transaction;
//   int? _deviceId;

//   // Callback para notificar nuevos datos
//   void Function(List<String>)? onDataReceived;

//   Future<bool> connectTo(UsbDevice? device) async {
//     if (_subscription != null) {
//       await _subscription!.cancel();
//       _subscription = null;
//     }

//     if (_transaction != null) {
//       _transaction!.dispose();
//       _transaction = null;
//     }

//     if (_port != null) {
//       await _port!.close();
//       _port = null;
//     }

//     if (device == null) {
//       _deviceId = null;
//       _status = "Disconnected";
//       return true;
//     }

//     _port = await device.create();
//     if (!await _port!.open()) {
//       _status = "Failed to open port";
//       return false;
//     }

//     _deviceId = device.deviceId;
//     await _port!.setDTR(true);
//     await _port!.setRTS(true);
//     await _port!.setPortParameters(
//         115200, UsbPort.DATABITS_8, UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);

//     if (_port!.inputStream != null) {
//       _transaction = Transaction.stringTerminated(
//           _port!.inputStream!, Uint8List.fromList([13, 10]));

//       _subscription = _transaction!.stream.listen((String line) {
//         _serialData.add(line);
//         if (_serialData.length > 20) {
//           _serialData.removeAt(0);
//         }
//         // Notificar a los listeners
//         onDataReceived?.call(_serialData);
//       });
//     } else {
//       _status = "Failed to listen to port";
//       return false;
//     }

//     _status = "Connected";
//     return true;
//   }

//   void getPorts(Function(List<UsbDevice>) onDevicesRetrieved) async {
//     List<UsbDevice> devices = await UsbSerial.listDevices();
//     onDevicesRetrieved(devices);
//   }

//   void addDataListener(void Function(List<String>) onData) {
//     onDataReceived = onData;
//   }

//   Future<void> sendData(String data) async {
//     if (_port != null) {
//       data = "${data}\r\n";
//       await _port!.write(Uint8List.fromList(data.codeUnits));
//     }
//   }

//   void dispose() async {
//     await connectTo(null);
//   }

//   String get status => _status;
//   List<String> get serialData => _serialData;
//   int? get deviceId => _deviceId;
// }


// ---------------------------------------------------------------------------


// import 'dart:async';
// import 'dart:typed_data';
// import 'package:usb_serial/transaction.dart';
// import 'package:usb_serial/usb_serial.dart';


// // Controlador de flujo para gestionar los datos seriales
// final StreamController<String> _serialStreamController = StreamController<String>();

// class UsbSerialDevice {
//   UsbPort? _port;
//   String _status = "Idle";
//   List<String> _serialData = [];
//   StreamSubscription<String>? _subscription;
//   Transaction<String>? _transaction;
//   int? _deviceId;

//   Future<bool> connectTo(UsbDevice? device) async {
//     if (_subscription != null) {
//       await _subscription!.cancel();
//       _subscription = null;
//     }

//     if (_transaction != null) {
//       _transaction!.dispose();
//       _transaction = null;
//     }

//     if (_port != null) {
//       await _port!.close();
//       _port = null;
//     }

//     if (device == null) {
//       _deviceId = null;
//       _status = "Disconnected";
//       return true;
//     }

//     _port = await device.create();
//     if (!await _port!.open()) {
//       _status = "Failed to open port";
//       return false;
//     }

//     _deviceId = device.deviceId;
//     await _port!.setDTR(true);
//     await _port!.setRTS(true);
//     await _port!.setPortParameters(
//         115200, UsbPort.DATABITS_8, UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);

//     if (_port!.inputStream != null) {
//       _transaction = Transaction.stringTerminated(
//           _port!.inputStream!, Uint8List.fromList([13, 10]));

//       _subscription = _transaction!.stream.listen((String line) {
//         _serialData.add(line);
//         if (_serialData.length > 20) {
//           _serialData.removeAt(0);
//         }
//       });
//     } else {
//       _status = "Failed to listen to port";
//       return false;
//     }

//     _status = "Connected";
//     return true;
//   }

//   void getPorts(Function(List<UsbDevice>) onDevicesRetrieved) async {
//     List<UsbDevice> devices = await UsbSerial.listDevices();
//     onDevicesRetrieved(devices);
//   }

//   Future<void> sendData(String data) async {
//     if (_port != null) {
//       data = "${data}\r\n";
//       await _port!.write(Uint8List.fromList(data.codeUnits));
//     }
//   }

//   void dispose() async {
//     await connectTo(null);
//   }

//   String get status => _status;
//   List<String> get serialData => _serialData;
//   int? get deviceId => _deviceId;
// }
