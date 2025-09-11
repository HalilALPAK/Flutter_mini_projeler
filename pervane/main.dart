import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: WindTurbine()),
      ),
    ),
  );
}

class WindTurbine extends StatefulWidget {
  @override
  _WindTurbineState createState() => _WindTurbineState();
}

class _WindTurbineState extends State<WindTurbine>
    with TickerProviderStateMixin {
  late AnimationController _controller; // Ana dönüş
  late AnimationController _swingController; // Y ekseni salınım
  late Animation<double> _swingAnimation;

  int speedLevel = 0;
  bool swingActive = false;

  @override
  void initState() {
    super.initState();

    // Ana dönme kontrolü
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    // Salınım kontrolü (Y ekseni)
    _swingController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    );

    // Tween: -45° ile +45° arası (radyan cinsinden)
    _swingAnimation = Tween<double>(
      begin: -pi / 4,
      end: pi / 4,
    ).animate(_swingController);

    // Sürekli tersine dönsün
    _swingController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _swingController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _swingController.forward();
      }
    });
  }

  void setSpeed(int level) {
    setState(() {
      speedLevel = level;
      if (level == 0) {
        _controller.stop();
      } else if (level == 1) {
        _controller.duration = Duration(seconds: 3);
        _controller.repeat();
      } else if (level == 2) {
        _controller.duration = Duration(seconds: 2);
        _controller.repeat();
      } else if (level == 3) {
        _controller.duration = Duration(seconds: 1);
        _controller.repeat();
      }
    });
  }

  void toggleSwing() {
    setState(() {
      swingActive = !swingActive;
      if (swingActive) {
        _swingController.forward();
      } else {
        _swingController.stop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: _swingController,
          builder: (context, child) {
            // Matrix4 ile Y ekseninde dönme
            final swingMatrix =
                Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // perspektif efekti
                  ..rotateY(swingActive ? _swingAnimation.value : 0);

            return Transform(
              transform: swingMatrix,
              alignment: Alignment.center,
              child: RotationTransition(
                turns: _controller,
                child: CustomPaint(
                  size: Size(200, 200),
                  painter: TurbinePainter(),
                ),
              ),
            );
          },
        ),
        SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < 4; i++)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () => setSpeed(i),
                  child: Text("$i"),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: toggleSwing,
                child: Text("Y↔"), // Y ekseni salınım butonu
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _swingController.dispose();
    super.dispose();
  }
}

class TurbinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.blue
          ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < 3; i++) {
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(2 * pi * i / 3);

      Path blade = Path();
      blade.moveTo(0, 0);
      blade.quadraticBezierTo(
        size.width * 0.2,
        -size.height * 0.1,
        size.width * 0.4,
        0,
      );
      blade.quadraticBezierTo(size.width * 0.2, size.height * 0.1, 0, 0);
      canvas.drawPath(blade, paint);

      canvas.restore();
    }

    // Göbek dairesi
    canvas.drawCircle(center, 10, Paint()..color = Colors.black);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
