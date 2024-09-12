// Archivo usb_serial_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'usb_serial_state.dart'; // Asegúrate de que esta ruta sea correcta


class UsbSerialPage extends StatefulWidget {
  const UsbSerialPage({super.key});

  @override
  _UsbSerialPageState createState() => _UsbSerialPageState();
}

class _UsbSerialPageState extends State<UsbSerialPage> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final usbSerialState = Provider.of<UsbSerialState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('USB Serial App'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text(
              usbSerialState.ports.isNotEmpty
                  ? "Available Serial Ports"
                  : "No serial devices available",
              style: Theme.of(context).textTheme.headline6,
            ),
            ...usbSerialState.ports.map((device) {
              return ListTile(
                leading: const Icon(Icons.usb),
                title: Text(device.productName ?? "Unknown device"),
                subtitle: Text(device.manufacturerName ?? "Unknown manufacturer"),
                trailing: ElevatedButton(
                  child: Text(usbSerialState.device.deviceId == device.deviceId ? "Disconnect" : "Connect"),
                  onPressed: () {
                    usbSerialState.connectTo(device);
                  },
                ),
              );
            }).toList(),
            Text('Status: ${usbSerialState.device.status}\n'),
            ListTile(
              title: TextField(
                controller: _textEditingController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Text To Send',
                ),
              ),
              trailing: ElevatedButton(
                onPressed: usbSerialState.device.deviceId == null
                    ? null
                    : () async {
                        String data = _textEditingController.text;
                        await usbSerialState.sendData(data);
                      },
                child: const Text("Send"),
              ),
            ),
            Text(
              "Result Data",
              style: Theme.of(context).textTheme.headline6,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: usbSerialState.serialData.length,
                itemBuilder: (context, index) {
                  return Text(usbSerialState.serialData[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}


// class UsbSerialPage extends StatelessWidget {
//   const UsbSerialPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final usbSerialState = Provider.of<UsbSerialState>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('USB Serial app'),
//       ),
//       body: Center(
//         child: Column(
//           children: <Widget>[
//             Text(
//               usbSerialState.ports.isNotEmpty
//                   ? "Available Serial Ports"
//                   : "No serial devices available",
//               style: Theme.of(context).textTheme.headline6,
//             ),
//             ...usbSerialState.ports.map((device) {
//               return ListTile(
//                 leading: const Icon(Icons.usb),
//                 title: Text(device.productName ?? "Unknown device"),
//                 subtitle: Text(device.manufacturerName ?? "Unknown manufacturer"),
//                 trailing: ElevatedButton(
//                   child: Text(usbSerialState.device.deviceId == device.deviceId ? "Disconnect" : "Connect"),
//                   onPressed: () {
//                     usbSerialState.connectTo(device);
//                   },
//                 ),
//               );
//             }).toList(),
//             Text('Status: ${usbSerialState.device.status}\n'),
//             ListTile(
//               title: TextField(
//                 controller: TextEditingController(),
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   labelText: 'Text To Send',
//                 ),
//               ),
//               trailing: ElevatedButton(
//                 onPressed: usbSerialState.device.deviceId == null
//                     ? null
//                     : () async {
//                         String data = TextEditingController().text;
//                         await usbSerialState.sendData(data);
//                       },
//                 child: const Text("Send"),
//               ),
//             ),
//             Text(
//               "Result Data",
//               style: Theme.of(context).textTheme.headline6,
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: usbSerialState.serialData.length,
//                 itemBuilder: (context, index) {
//                   return Text(usbSerialState.serialData[index]);
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }




// import 'package:flutter/material.dart';
// import 'package:usb_serial/usb_serial.dart';
// import 'usb_serial_device.dart';


// class UsbSerialPage extends StatefulWidget {
//   const UsbSerialPage({super.key});

//   @override
//   _UsbSerialPageState createState() => _UsbSerialPageState();
// }

// class _UsbSerialPageState extends State<UsbSerialPage> {
//   final UsbSerialDevice _device = UsbSerialDevice();
//   List<Widget> _ports = [];
//   final TextEditingController _textController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();

//     UsbSerial.usbEventStream?.listen((UsbEvent event) {
//       _getPorts();
//     });

//     _getPorts();
//   }

//   void _getPorts() {
//     _device.getPorts((devices) {
//       setState(() {
//         _ports = devices.map((device) {
//           return ListTile(
//             leading: const Icon(Icons.usb),
//             title: Text(device.productName ?? "Unknown device"),
//             subtitle: Text(device.manufacturerName ?? "Unknown manufacturer"),
//             trailing: ElevatedButton(
//               child: Text(_device.deviceId == device.deviceId ? "Disconnect" : "Connect"),
//               onPressed: () {
//                 _device.connectTo(_device.deviceId == device.deviceId ? null : device)
//                     .then((res) {
//                   _getPorts();
//                 });
//               },
//             ),
//           );
//         }).toList();
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _device.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('USB Serial app'),
//       ),
//       body: Center(
//         child: Column(
//           children: <Widget>[
//             Text(
//               _ports.isNotEmpty
//                   ? "Available Serial Ports"
//                   : "No serial devices available",
//               style: Theme.of(context).textTheme.headline6,
//             ),
//             ..._ports,
//             Text('Status: ${_device.status}\n'),
//             ListTile(
//               title: TextField(
//                 controller: _textController,
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   labelText: 'Text To Send',
//                 ),
//               ),
//               trailing: ElevatedButton(
//                 onPressed: _device.deviceId == null
//                     ? null
//                     : () async {
//                         String data = _textController.text;
//                         await _device.sendData(data);
//                         _textController.clear();
//                       },
//                 child: const Text("Send"),
//               ),
//             ),
//             Text(
//               "Result Data",
//               style: Theme.of(context).textTheme.headline6,
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _device.serialData.length,
//                 itemBuilder: (context, index) {
//                   return Text(_device.serialData[index]);
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
