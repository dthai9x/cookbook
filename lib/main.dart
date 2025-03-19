import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'widgets/fishtank.dart';
import 'widgets/fish_selection_dialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fishtank Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Fishtank Game'),
    );
  }
+}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
+}

class _MyHomePageState extends State<MyHomePage> {
  double _waterQuality = 100.0;
  int _currency = 100; // Initial currency
  late Timer _waterQualityTimer;
  late Timer _currencyTimer;

  @override
  void initState() {
    super.initState();
    _loadGameState();

    _waterQualityTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _waterQuality = (_waterQuality - 0.1).clamp(0, 100);
      });
    });

    _currencyTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        _currency += 1; // Earn currency over time (representing fish health)
      });
    });
  }

  @override
  void dispose() {
    _waterQualityTimer.cancel();
    _currencyTimer.cancel();
    _saveGameState();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to the Fishtank Game!',
            ),
            const SizedBox(height: 20),
            const Fishtank(),
            const SizedBox(height: 20),
            Text('Water Quality: ${_waterQuality.toStringAsFixed(1)}%'),
            Text('Currency: $_currency'),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _waterQuality = 100;
                });
              },
              child: const Text('Clean Water'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return FishSelectionDialog(
                      onFishAdded: _addFish,
                      currency: _currency,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            // Find the Fishtank widget in the widget tree and call its feedFish method
            final fishtankState = _getFishtankState();
            if (fishtankState != null) {
              fishtankState.feedFish();
            }
          });
        },
        tooltip: 'Feed Fish',
        child: const Icon(Icons.food_bank),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  // Helper function to find the FishtankState
  _FishtankState? _getFishtankState() {
    _FishtankState? fishtankState;
    void visitor(Element element) {
      if (element.widget is Fishtank) {
        fishtankState = element.findAncestorStateOfType<_FishtankState>();
      } else {
        element.visitChildren(visitor);
      }
    }

    context.visitChildElements(visitor);
    return fishtankState;
  }

  void _addFish() {
    if (_currency >= 50) {
      setState(() {
        _currency -= 50;
        // Find the Fishtank widget and add a fish
        final fishtankState = _getFishtankState();
        if (fishtankState != null) {
          fishtankState.addFish();
        }
      });
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/game_state.json');
  }

  Future<void> _saveGameState() async {
    final file = await _localFile;
    final gameState = {
      'waterQuality': _waterQuality,
      'currency': _currency,
      'fishes': _getFishtankState()?.fishes.map((fish) => fish.toJson()).toList()
    };
    file.writeAsString(jsonEncode(gameState));
  }

  Future<void> _loadGameState() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      final gameState = jsonDecode(contents);
      setState(() {
        _waterQuality = gameState['waterQuality'] ?? 100.0;
        _currency = gameState['currency'] ?? 100;
        final fishesJson = gameState['fishes'] as List?;
        if (fishesJson != null) {
          final fishes = fishesJson.map((fishJson) => Fish.fromJson(fishJson)).toList();
          _getFishtankState()?.loadFishes(fishes);
        }
      });
    } catch (e) {
      // If encountering an error, default values will be used
    }
  }
}
