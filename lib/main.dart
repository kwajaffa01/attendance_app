import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

// ==========================
// MAIN APP ENTRY
// ==========================
void main() {
  runApp(const MyApp());
}

// ==========================
// ROOT APP
// ==========================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Student Attendance System'),
    );
  }
}

// ==========================
// HOME SCREEN (LECTURER)
// ==========================
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Welcome to Attendance App',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Scan QR to mark attendance',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 15),

            // BUTTON 1: SCAN
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ScanScreen(),
                  ),
                );
              },
              child: const Text('Scan Attendance'),
            ),

            const SizedBox(height: 10),

            // BUTTON 2: SHOW QR
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StudentScreen(),
                  ),
                );
              },
              child: const Text('Show My QR'),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================
// SCAN SCREEN (QR SCANNER)
// ==========================
class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  String scannedCode = "No code scanned";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Attendance'),
      ),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              onDetect: (barcodeCapture) {
                final List<Barcode> barcodes = barcodeCapture.barcodes;

                for (final barcode in barcodes) {
                  final String? code = barcode.rawValue;
                  if (code != null) {
                    setState(() {
                      if (code.contains('|')) {
                        final parts = code.split('|');

                        final name = parts[0]
                            .replaceAll('Name:', '')
                            .trim();
                        final id = parts[1]
                            .replaceAll('ID:', '')
                            .trim();

                        scannedCode =
                            "Attendance marked for $name (ID: $id)";
                      } else {
                        scannedCode = "Invalid QR code";
                      }
                    });
                  }
                }
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              scannedCode,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================
// STUDENT SCREEN (QR GENERATOR - DYNAMIC)
// ==========================
class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  String name = "";
  String id = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My QR Code'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Enter your details',
              style: TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                ),
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'ID',
                ),
                onChanged: (value) {
                  setState(() {
                    id = value;
                  });
                },
              ),
            ),

            const SizedBox(height: 20),
Text(
  (name.isEmpty || id.isEmpty)
      ? "Please enter Name and ID"
      : "QR ready for scanning",
  style: TextStyle(
    color: (name.isEmpty || id.isEmpty)
        ? Colors.red
        : Colors.green,
    fontWeight: FontWeight.bold,
  ),
),
            QrImageView(
              data: (name.isNotEmpty && id.isNotEmpty)
    ? "Name: $name | ID: $id"
    : "Enter details",
              size: 200,
            ),
          ],
        ),
      ),
    );
  }
}