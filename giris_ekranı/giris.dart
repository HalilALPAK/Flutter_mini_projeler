import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(
    MaterialApp(debugShowCheckedModeBanner: false, home: AnimatedLoginScreen()),
  );
}

class AnimatedLoginScreen extends StatefulWidget {
  @override
  _AnimatedLoginScreenState createState() => _AnimatedLoginScreenState();
}

class _AnimatedLoginScreenState extends State<AnimatedLoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final Offset pointA = Offset(20, 50);
  final Offset pointB = Offset(280, 50);

  bool isDragging = false;
  Offset dragPosition = Offset.zero;

  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade100, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Container(
              width: 350,
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Hoşgeldiniz",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  SizedBox(height: 20),

                  // ---------------- Araba Animasyonu ----------------
                  SizedBox(
                    height: 100,
                    child: Stack(
                      children: [
                        CustomPaint(
                          size: Size(double.infinity, double.infinity),
                          painter: StraightPathPainter(pointA, pointB),
                        ),
                        AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            double y = pointA.dy;
                            double x;
                            if (isDragging) {
                              x = dragPosition.dx.clamp(pointA.dx, pointB.dx);
                            } else {
                              double t = _controller.value;
                              x = pointA.dx + (pointB.dx - pointA.dx) * t;
                            }
                            double left = (x - 40).clamp(0.0, 350 - 80);
                            double top = (y - 25).clamp(0.0, 100 - 50);
                            return Positioned(
                              left: left,
                              top: top,
                              child: child!,
                            );
                          },
                          child: GestureDetector(
                            onPanStart: (details) {
                              setState(() {
                                isDragging = true;
                                _controller.stop();
                                dragPosition = Offset(
                                  _controller.value * (pointB.dx - pointA.dx) +
                                      pointA.dx,
                                  pointA.dy,
                                );
                              });
                            },
                            onPanUpdate: (details) {
                              setState(() {
                                dragPosition = Offset(
                                  details.localPosition.dx,
                                  pointA.dy,
                                );
                              });
                            },
                            onPanEnd: (details) {
                              setState(() {
                                isDragging = false;
                                double totalLength =
                                    (pointB.dx - pointA.dx).abs();
                                double t = ((dragPosition.dx - pointA.dx) /
                                        totalLength)
                                    .clamp(0.0, 1.0);
                                _controller.value = t;
                                _controller.repeat();
                              });
                            },
                            child: Image.asset(
                              'assets/karavan.png',
                              width: 80,
                              height: 50,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  // ---------------- Giriş Formu ----------------
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Kullanıcı Adı",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Şifre",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      prefixIcon: Icon(Icons.lock, color: Colors.grey.shade600),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Checkbox(
                        value: rememberMe,
                        activeColor: Colors.grey.shade600,
                        onChanged: (value) {
                          setState(() {
                            rememberMe = value!;
                          });
                        },
                      ),
                      Text(
                        "Beni Hatırla",
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            backgroundColor: Colors.blueGrey.shade400,
                            foregroundColor: Colors.white,
                          ),
                          child: Text("Giriş"),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            backgroundColor: Colors.green.shade400,
                            foregroundColor: Colors.white,
                          ),
                          child: Text("Kayıt Ol"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

// ----------------- Düz yol çizimi -----------------
class StraightPathPainter extends CustomPainter {
  final Offset a;
  final Offset b;

  StraightPathPainter(this.a, this.b);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint =
        Paint()
          ..color = Colors.grey.shade500
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    double dashWidth = 10;
    double dashSpace = 5;

    double dx = b.dx - a.dx;
    double dy = b.dy - a.dy;
    double length = sqrt(dx * dx + dy * dy);
    int dashCount = (length / (dashWidth + dashSpace)).floor();
    double dashDx = dx / dashCount;
    double dashDy = dy / dashCount;

    for (int i = 0; i < dashCount; i += 2) {
      double x1 = a.dx + dashDx * i;
      double y1 = a.dy + dashDy * i;
      double x2 = a.dx + dashDx * (i + 1);
      double y2 = a.dy + dashDy * (i + 1);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
