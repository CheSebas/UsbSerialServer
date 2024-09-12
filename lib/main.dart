// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'home.dart';
// import 'provider.dart';
// import 'server/server_state.dart';
// import 'usbSerial/usb_serial_state.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AppState()),
//         ChangeNotifierProvider(create: (_) => ServerState()), // Agregado aquí
//         ChangeNotifierProxyProvider<ServerState, UsbSerialState>(
//           create: (context) => UsbSerialState(Provider.of<ServerState>(context, listen: false)),
//           update: (context, serverState, usbSerialState) => UsbSerialState(serverState),
//         ),
//       ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'Flutter App',
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//         ),
//         home: const HomePage(),
//       ),
//     );
//   }
// }


// -------------------------------------------


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home.dart';
import 'provider.dart';
import 'server/server_state.dart'; // Agrega esta línea
import 'usbSerial/usb_serial_state.dart'; // Agrega esta línea

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => ServerState()), // Agrega esta línea
        ChangeNotifierProvider(create: (_) => UsbSerialState()), // Agrega esta línea
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
      ),
    );
  }
}






// import 'package:flutter/material.dart';
// import 'home.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const HomePage(),
//     );
//   }
// }
