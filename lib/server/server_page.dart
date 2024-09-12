// Archivo server_page.dart
import 'package:app/usbSerial/usb_serial_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'server_state.dart'; // Asegúrate de que esta ruta sea correcta


class ServerPage extends StatefulWidget {
  const ServerPage({super.key});

  @override
  _ServerPageState createState() => _ServerPageState();
}

class _ServerPageState extends State<ServerPage> {
  final TextEditingController _textController = TextEditingController();
  //
  late ServerState _serverState;
  late UsbSerialState _usbSerialState;
  //

  //
  @override
  void initState() {
    super.initState();
    _serverState = Provider.of<ServerState>(context, listen: false);
    _usbSerialState = Provider.of<UsbSerialState>(context, listen: false);
    _usbSerialState.setServer(_serverState.server); // Asegúrate de pasar el servidor
  }
  //

  @override
  Widget build(BuildContext context) {
    final serverState = Provider.of<ServerState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Server'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            bool exit = await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("ATTENTION"),
                  content: const Text("Salga de esta página y apague el servidor de socket"),
                  actions: <Widget>[
                    TextButton(
                      child: const Text("Salir", style: TextStyle(color: Colors.red)),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                    TextButton(
                      child: const Text("Cancelar", style: TextStyle(color: Colors.grey)),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                  ],
                );
              },
            );

            if (exit == true) {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text(
                        "Server",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: serverState.running ? Colors.green : Colors.red,
                          borderRadius: const BorderRadius.all(Radius.circular(3)),
                        ),
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          serverState.running ? 'ON' : 'OFF',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    child: Text(serverState.running ? 'Detener Servidor' : 'Iniciar Servidor'),
                    onPressed: () async {
                      if (serverState.running) {
                        await serverState.stopServer();
                      } else {
                        await serverState.startServer();
                      }
                    },
                  ),
                  const Divider(
                    height: 30,
                    thickness: 1,
                    color: Colors.black12,
                  ),
                  Expanded(
                    flex: 1,
                    child: ListView.builder(
                      itemCount: serverState.logs.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(serverState.logs[index]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.grey,
            height: 80,
            padding: const EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Mensaje para transmitir :',
                        style: TextStyle(
                          fontSize: 8,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: _textController,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 15),
                MaterialButton(
                  onPressed: () {
                    _textController.clear();
                  },
                  minWidth: 30,
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: const Icon(Icons.clear),
                ),
                const SizedBox(width: 15),
                MaterialButton(
                  onPressed: () {
                    final text = _textController.text;
                    if (text.isNotEmpty) {
                      serverState.broadcast(text);
                      _textController.clear();
                    }
                  },
                  minWidth: 30,
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// ---------------------------------------------------------------


// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'server_state.dart'; // Asegúrate de que esta ruta sea correcta

// class ServerPage extends StatelessWidget {
//   const ServerPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final serverState = Provider.of<ServerState>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Server'),
//         centerTitle: true,
//         automaticallyImplyLeading: false,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () async {
//             bool exit = await showDialog(
//               context: context,
//               builder: (context) {
//                 return AlertDialog(
//                   title: const Text("ATTENTION"),
//                   content: const Text("Salga de esta página y apague el servidor de socket"),
//                   actions: <Widget>[
//                     TextButton(
//                       child: const Text("Salir", style: TextStyle(color: Colors.red)),
//                       onPressed: () {
//                         Navigator.of(context).pop(true);
//                       },
//                     ),
//                     TextButton(
//                       child: const Text("Cancelar", style: TextStyle(color: Colors.grey)),
//                       onPressed: () {
//                         Navigator.of(context).pop(false);
//                       },
//                     ),
//                   ],
//                 );
//               },
//             );

//             if (exit == true) {
//               Navigator.of(context).pop();
//             }
//           },
//         ),
//       ),
//       body: Column(
//         children: <Widget>[
//           Expanded(
//             flex: 1,
//             child: Padding(
//               padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
//               child: Column(
//                 children: <Widget>[
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <Widget>[
//                       const Text(
//                         "Server",
//                         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                       ),
//                       Container(
//                         decoration: BoxDecoration(
//                           color: serverState.running ? Colors.green : Colors.red,
//                           borderRadius: const BorderRadius.all(Radius.circular(3)),
//                         ),
//                         padding: const EdgeInsets.all(5),
//                         child: Text(
//                           serverState.running ? 'ON' : 'OFF',
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 15),
//                   ElevatedButton(
//                     child: Text(serverState.running ? 'Detener Servidor' : 'Iniciar Servidor'),
//                     onPressed: () async {
//                       if (serverState.running) {
//                         await serverState.stopServer();
//                       } else {
//                         await serverState.startServer();
//                       }
//                     },
//                   ),
//                   const Divider(
//                     height: 30,
//                     thickness: 1,
//                     color: Colors.black12,
//                   ),
//                   Expanded(
//                     flex: 1,
//                     child: ListView.builder(
//                       itemCount: serverState.logs.length,
//                       itemBuilder: (context, index) {
//                         return Padding(
//                           padding: const EdgeInsets.only(top: 15),
//                           child: Text(serverState.logs[index]),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Container(
//             color: Colors.grey,
//             height: 80,
//             padding: const EdgeInsets.all(10),
//             child: Row(
//               children: <Widget>[
//                 Expanded(
//                   flex: 1,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       const Text(
//                         'Mensaje para transmitir :',
//                         style: TextStyle(
//                           fontSize: 8,
//                         ),
//                       ),
//                       Expanded(
//                         flex: 1,
//                         child: TextFormField(
//                           controller: TextEditingController(),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 15),
//                 MaterialButton(
//                   onPressed: () {
//                     // Clear button action
//                   },
//                   minWidth: 30,
//                   padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//                   child: const Icon(Icons.clear),
//                 ),
//                 const SizedBox(width: 15),
//                 MaterialButton(
//                   onPressed: () {
//                     final textController = TextEditingController();
//                     if (textController.text.isNotEmpty) {
//                       serverState.broadcast(textController.text);
//                       textController.clear();
//                     }
//                   },
//                   minWidth: 30,
//                   padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//                   child: const Icon(Icons.send),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


// -----------------------------------------------------------------


// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'server.dart';

// class ServerPage extends StatefulWidget {
//   const ServerPage({super.key});

//   @override
//   _ServerPageState createState() => _ServerPageState();
// }

// class _ServerPageState extends State<ServerPage> {
//   // late Server server;
//   late WebSocketServer server;
//   List<String> serverLogs = [];
//   TextEditingController controller = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     // server = Server(
//     server = WebSocketServer(
//       onData: this.onData,
//       onError: this.onError,
//     );
//   }

//   void onData(Uint8List data) {
//     DateTime time = DateTime.now();
//     String log = "${time.hour}h${time.minute} : ${String.fromCharCodes(data)}";
//     setState(() {
//       serverLogs.add(log);
//     });
//   }

//   void onError(dynamic error) {
//     print(error);
//     setState(() {
//       serverLogs.add("Error: $error");
//     });
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     server.stop();
//     super.dispose();
//   }

//   Future<void> confirmReturn() async {
//     bool exit = await showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text("ATTENTION"),
//           content: Text("Salga de esta página y apague el servidor de socket"),
//           actions: <Widget>[
//             TextButton(
//               child: Text("Salir", style: TextStyle(color: Colors.red)),
//               onPressed: () {
//                 Navigator.of(context).pop(true);
//               },
//             ),
//             TextButton(
//               child: Text("Cancelar", style: TextStyle(color: Colors.grey)),
//               onPressed: () {
//                 Navigator.of(context).pop(false);
//               },
//             ),
//           ],
//         );
//       },
//     );

//     if (exit == true) {
//       Navigator.of(context).pop();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Server'),
//         centerTitle: true,
//         automaticallyImplyLeading: false,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: confirmReturn,
//         ),
//       ),
//       body: Column(
//         children: <Widget>[
//           Expanded(
//             flex: 1,
//             child: Padding(
//               padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
//               child: Column(
//                 children: <Widget>[
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <Widget>[
//                       Text(
//                         "Server",
//                         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                       ),
//                       Container(
//                         decoration: BoxDecoration(
//                           color: server.running ? Colors.green : Colors.red,
//                           borderRadius: BorderRadius.all(Radius.circular(3)),
//                         ),
//                         padding: EdgeInsets.all(5),
//                         child: Text(
//                           server.running ? 'ON' : 'OFF',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 15),
//                   ElevatedButton(
//                     child: Text(server.running ? 'Detener Servidor' : 'Iniciar Servidor'),
//                     onPressed: () async {
//                       setState(() {
//                         server.running = !server.running;
//                       });
//                       if (server.running) {
//                         await server.start();
//                       } else {
//                         await server.stop();
//                         setState(() {
//                           serverLogs.clear();
//                         });
//                       }
//                     },
//                   ),
//                   Divider(
//                     height: 30,
//                     thickness: 1,
//                     color: Colors.black12,
//                   ),
//                   Expanded(
//                     flex: 1,
//                     child: ListView.builder(
//                       itemCount: serverLogs.length,
//                       itemBuilder: (context, index) {
//                         return Padding(
//                           padding: EdgeInsets.only(top: 15),
//                           child: Text(serverLogs[index]),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Container(
//             color: Colors.grey,
//             height: 80,
//             padding: EdgeInsets.all(10),
//             child: Row(
//               children: <Widget>[
//                 Expanded(
//                   flex: 1,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Text(
//                         'Mensaje para transmitir :',
//                         style: TextStyle(
//                           fontSize: 8,
//                         ),
//                       ),
//                       Expanded(
//                         flex: 1,
//                         child: TextFormField(
//                           controller: controller,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(width: 15),
//                 MaterialButton(
//                   onPressed: () {
//                     controller.clear();
//                   },
//                   minWidth: 30,
//                   padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//                   child: Icon(Icons.clear),
//                 ),
//                 SizedBox(width: 15),
//                 MaterialButton(
//                   onPressed: () {
//                     if (controller.text.isNotEmpty) {
//                       // server.broadCast(controller.text);
//                       server.broadCast(controller.text as String);
//                       controller.clear();
//                     }
//                   },
//                   minWidth: 30,
//                   padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//                   child: Icon(Icons.send),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
