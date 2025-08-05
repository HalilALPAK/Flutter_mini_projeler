import 'package:flutter/material.dart';

class GradientBlockNav extends StatefulWidget {
  const GradientBlockNav({Key? key}) : super(key: key);

  @override
  State<GradientBlockNav> createState() => _GradientBlockNavState();
}

class _GradientBlockNavState extends State<GradientBlockNav> {
  int? hoveredIndex;

  final List<List<Color>> gradients = [
    [Colors.purple, Colors.blue],
    [Colors.orange, Colors.red],
    [Colors.green, Colors.teal],
    [Colors.pink, Colors.purple],
    [Colors.yellow, Colors.orange],
    [Colors.cyan, Colors.indigo],
    [Colors.deepPurple, Colors.pink],
    [Colors.lime, Colors.green],
    [Colors.blueGrey, Colors.blue],
  ];

  double lerp(int distance) {
    switch (distance) {
      case 0:
        return 1.0;
      case 1:
        return 0.5625;
      case 2:
        return 0.25;
      case 3:
        return 0.0625;
      default:
        return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(gradients.length, (i) {
          int distance = hoveredIndex == null ? 4 : (i - hoveredIndex!).abs();
          // Hovered block yukarı çıksın, komşular da merdiven gibi yukarı kalksın
          double flex = 0.7 + lerp(distance) * 2.5;
          double height = 80 + lerp(distance) * 60; // yükseklik de artsın
          double translateY = 0.0;
          if (hoveredIndex != null) {
            if (distance == 0) {
              translateY = -40; // hovered block en yukarı
            } else if (distance == 1) {
              translateY = -25; // komşular biraz yukarı
            } else if (distance == 2) {
              translateY = -10; // daha uzak komşular az yukarı
            }
          }
          return MouseRegion(
            onEnter: (_) => setState(() => hoveredIndex = i),
            onExit: (_) => setState(() => hoveredIndex = null),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.ease,
              width: 80 * flex,
              height: height,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              transform: Matrix4.translationValues(0, translateY, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: gradients[i],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  if (hoveredIndex == i)
                    BoxShadow(
                      color: gradients[i][0].withOpacity(0.4),
                      blurRadius: 24,
                      offset: const Offset(0, 6),
                    ),
                ],
              ),
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.white.withOpacity(
                      hoveredIndex == i ? 0.7 : 0.3,
                    ),
                    border:
                        hoveredIndex == i
                            ? Border.all(color: gradients[i][0], width: 3)
                            : null,
                  ),
                  child: const SizedBox(),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
