import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider.dart'; // Asegúrate de que la ruta sea correcta
import 'server/server_page.dart'; // Asegúrate de que esta página exista
import 'usbSerial/usb_serial_page.dart'; // Asegúrate de que esta página exista

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ServidorWs / UsbSerial'),
      ),
      body: PageView(
        controller: appState.pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          ServerPage(),
          UsbSerialPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: appState.currentIndex,
        selectedItemColor: Colors.blueGrey,
        onTap: (index) {
          appState.setIndex(index);
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dns),
            label: 'Servidor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.usb),
            label: 'USB Serial',
          ),
        ],
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'server/server_page.dart'; // Asegúrate de que esta página exista
// import 'usbSerial/usb_serial_page.dart'; // Asegúrate de que esta página exista

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int _selectedIndex = 0; // Índice inicial en la barra de navegación
//   final PageController _pageController = PageController();

//   // Lista de páginas para el PageView
//   final List<Widget> _pages = [
//     const ServerPage(),
//     const UsbSerialPage(),
//   ];

//   // Función para cambiar de página desde el BottomNavigationBar
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//     _pageController.jumpToPage(index);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('ServidorWs / UsbSerial'),
//       ),
//       body: PageView(
//         controller: _pageController,
//         physics: const NeverScrollableScrollPhysics(),
//         children: _pages,
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.blueGrey,
//         onTap: _onItemTapped,
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.dns),
//             label: 'Servidor',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.usb),
//             label: 'USB Serial',
//           ),
//         ],
//       ),
//     );
//   }
// }
