import 'package:app/api/authApi/auth_api_handler.dart';
import 'package:app/pages/common/common_page.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key, required this.snackbarController});
  final snackbarController;
  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  MobileScannerController cameraController = MobileScannerController();
  bool isDetected = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MobileScanner(
        controller: cameraController,
        onDetect: (barcodes) async {
          if (isDetected) return;
          isDetected = true;
          final data = barcodes.barcodes.first.rawValue;
          final res = await AuthApiServer.qrCodeApprove(data);
          var snackBar = SnackBar(content: Text(res.message));
          widget.snackbarController.showSnackBar(snackBar);
          Navigator.pop(context);
        },
      ),
    );
  }
}
