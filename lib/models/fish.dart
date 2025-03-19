import 'package:flutter/material.dart';
import 'dart:math';

class Fish {
  double x;
  double y;
  double size;
  double speedX;
  double speedY;
  Color color;

  Fish({
    required this.x,
    required this.y,
    required this.size,
    required this.speedX,
    required this.speedY,
    required this.color,
  });

  void move(double tankWidth, double tankHeight) {
    x += speedX;
    y += speedY;

    if (x < 0 || x > tankWidth) {
      speedX *= -1;
    }
    if (y < 0 || y > tankHeight) {
      speedY *= -1;
    }
  }

  static Fish createRandom(double tankWidth, double tankHeight) {
    final random = Random();
    return Fish(
      x: random.nextDouble() * tankWidth,
      y: random.nextDouble() * tankHeight,
      size: random.nextDouble() * 20 + 10,
      speedX: (random.nextDouble() - 0.5) * 2,
      speedY: (random.nextDouble() - 0.5) * 2,
      color: Color.fromRGBO(
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
        1,
      ),
+    );
+  }
+
+  Map<String, dynamic> toJson() {
+    return {
+      'x': x,
+      'y': y,
+      'size': size,
+      'speedX': speedX,
+      'speedY': speedY,
+      'color': color.value,
+    };
+  }
+
+  factory Fish.fromJson(Map<String, dynamic> json) {
+    return Fish(
+      x: json['x'],
+      y: json['y'],
+      size: json['size'],
+      speedX: json['speedX'],
+      speedY: json['speedY'],
+      color: Color(json['color']),
+    );
+  }
 }
