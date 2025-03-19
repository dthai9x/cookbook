import 'package:flutter/material.dart';

import 'dart:math';
import 'package:flutter/material.dart';
import '../models/fish.dart';

class Fishtank extends StatefulWidget {
  const Fishtank({super.key});

  @override
  State<Fishtank> createState() => _FishtankState();
}

class _FishtankState extends State<Fishtank> with SingleTickerProviderStateMixin {
  List<Fish> fishes = [];
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    fishes.addAll(List.generate(5, (index) => Fish.createRandom(300, 400)));
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        for (var fish in fishes) {
          fish.move(300, 400);
        }
        return Container(
          width: 300,
          height: 400,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent, width: 2),
            color: Colors.lightBlue.withOpacity(0.3),
          ),
          child: Stack(
            children: fishes.map((fish) {
              return Positioned(
                left: fish.x,
                top: fish.y,
                child: Container(
                  width: fish.size,
                  height: fish.size,
                  decoration: BoxDecoration(
                    color: fish.color,
                    borderRadius: BorderRadius.circular(fish.size / 2),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
+    );
+  }
+
+  void feedFish() {
+    setState(() {
+      for (var fish in fishes) {
+        fish.size = min(fish.size + 5, 50);
+      }
     });
+  }
+
+  void addFish() {
+    setState(() {
+      fishes.add(Fish.createRandom(300, 400));
+    });
+  }
 }
