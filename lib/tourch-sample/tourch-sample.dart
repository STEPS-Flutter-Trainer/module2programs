import 'package:flutter/material.dart';
import 'package:torch_light/torch_light.dart';

void main() {
  runApp(TorchApp());
}

class TorchApp extends StatefulWidget {
  @override
  _TorchAppState createState() => _TorchAppState();
}

class _TorchAppState extends State<TorchApp> {
  bool _isTorchEnabled = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TorchController(
        isTorchEnabled: _isTorchEnabled,
        onTorchToggle: _toggleTorch,
      ),
    );
  }

  void _toggleTorch() async {
    if (_isTorchEnabled) {
      await TorchLight.disableTorch();
    } else {
      await TorchLight.enableTorch();
    }
    setState(() {
      _isTorchEnabled = !_isTorchEnabled;
    });
  }
}

class TorchController extends StatelessWidget {
  final bool isTorchEnabled;
  final VoidCallback onTorchToggle;

  const TorchController({
    Key? key,
    required this.isTorchEnabled,
    required this.onTorchToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Torch Light App'),
      ),
      body: FutureBuilder<bool>(
        future: _isTorchAvailable(context),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data!) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isTorchEnabled ? Icons.flash_on : Icons.flash_off,
                    size: 100,
                    color: isTorchEnabled ? Colors.yellow : Colors.grey,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: onTorchToggle,
                    child: Text(isTorchEnabled ? 'Disable Torch' : 'Enable Torch'),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text('No torch available.'),
            );
          }
        },
      ),
    );
  }

  Future<bool> _isTorchAvailable(BuildContext context) async {
    try {
      return await TorchLight.isTorchAvailable();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not check if the device has an available torch'),
        ),
      );
      return false;
    }
  }
}
