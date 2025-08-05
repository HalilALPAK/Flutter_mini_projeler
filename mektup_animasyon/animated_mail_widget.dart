import 'package:flutter/material.dart';

class AnimatedMailWidget extends StatefulWidget {
  const AnimatedMailWidget({Key? key}) : super(key: key);

  @override
  State<AnimatedMailWidget> createState() => _AnimatedMailWidgetState();
}

class _AnimatedMailWidgetState extends State<AnimatedMailWidget>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _flipAnimation;

  late AnimationController _paperController;
  late Animation<double> _paperSlide;

  @override
  void initState() {
    super.initState();

    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _flipAnimation = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );

    _paperController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _paperSlide = Tween<double>(begin: 50, end: -50).animate(
      CurvedAnimation(parent: _paperController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _paperController.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    if (isHovered) {
      _hoverController.forward();
      _paperController.forward();
    } else {
      _hoverController.reverse();
      _paperController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF323641),
      body: Center(
        child: MouseRegion(
          onEnter: (_) => _onHover(true),
          onExit: (_) => _onHover(false),
          child: SizedBox(
            width: 300,
            height: 250,
            child: AnimatedBuilder(
              animation: Listenable.merge([_hoverController, _paperController]),
              builder: (context, child) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Arka plan (arka fold)
                    Positioned(
                      bottom: 0,
                      child: Container(
                        width: 300,
                        height: 150,
                        color: const Color(0xFFCF4A43),
                      ),
                    ),

                    // Gövde (sağ üçgen)
                    Positioned(
                      bottom: 0,
                      child: CustomPaint(
                        size: const Size(300, 150),
                        painter: TrianglePainter(
                          color1: const Color(0xFFE95F55), // sol üst
                          color2: const Color(0xFFF7B2A9), // sağ alt
                        ),
                      ),
                    ),

                    // Üst kapak (kapalıyken en üstte)
                    if (_hoverController.value < 1.0)
                      Positioned(
                        top: 25,
                        left: 0,
                        child: Transform(
                          alignment: Alignment.bottomCenter,
                          transform:
                              Matrix4.identity()
                                ..scale(1.0, _flipAnimation.value),
                          child: CustomPaint(
                            size: const Size(300, 75),
                            painter: TopFoldPainter(
                              color: const Color(0xFFCF4A74),
                            ),
                          ),
                        ),
                      ),

                    // Üst kapak (tam açıldığında kağıdın altında, önce çiziliyor)
                    if (_hoverController.value == 1.0)
                      Positioned(
                        top: 25,
                        left: 0,
                        child: Transform(
                          alignment: Alignment.bottomCenter,
                          transform:
                              Matrix4.identity()
                                ..scale(1.0, _flipAnimation.value),
                          child: CustomPaint(
                            size: const Size(300, 75),
                            painter: TopFoldPainter(
                              color: const Color(0xFFCF4A74),
                            ),
                          ),
                        ),
                      ),

                    // Kağıt - üst kapak açıldığında önde ve yukarı kayıyor
                    if (_hoverController.value > 0.0)
                      Positioned(
                        top: 25 + _paperSlide.value,
                        left: 40,
                        child:
                            (_hoverController.value < 1.0)
                                ? ClipRect(
                                  clipper: PaperClipper(_hoverController.value),
                                  child: CustomPaint(
                                    size: const Size(220, 125),
                                    painter: PaperPainter(),
                                  ),
                                )
                                : CustomPaint(
                                  size: const Size(220, 125),
                                  painter: PaperPainter(),
                                ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// Gövde üçgeni
class TrianglePainter extends CustomPainter {
  final Color color1;
  final Color color2;
  TrianglePainter({required this.color1, required this.color2});

  @override
  void paint(Canvas canvas, Size size) {
    // Sol üstten sağ alta ayıran çizgiyle iki renkli üçgen
    final paint1 = Paint()..color = color1;
    final paint2 = Paint()..color = color2;

    // Sol üst üçgen
    final path1 = Path();
    path1.moveTo(0, size.height); // sol alt
    path1.lineTo(0, 0); // sol üst
    path1.lineTo(size.width, size.height); // sağ alt
    path1.close();
    canvas.drawPath(path1, paint1);

    // Sağ alt üçgen
    final path2 = Path();
    path2.moveTo(size.width, size.height); // sağ alt
    path2.lineTo(0, 0); // sol üst
    path2.lineTo(size.width, 0); // sağ üst
    path2.close();
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Üst kapak
class TopFoldPainter extends CustomPainter {
  final Color color;
  TopFoldPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Kağıt (ALPAK yazılı)
class PaperPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'ALPAK',
        style: TextStyle(
          color: Colors.black,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    textPainter.paint(canvas, Offset((size.width - textPainter.width) / 2, 20));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Sadece gövdenin üstünden taşan kısmı gösteren clipper
class PaperClipper extends CustomClipper<Rect> {
  final double progress; // 0.0 - 1.0
  PaperClipper(this.progress);

  @override
  Rect getClip(Size size) {
    // Animasyon ilerledikçe daha fazla kısmı göster
    // Başlangıçta 40px, sonunda tamamı
    double minHeight = 40;
    double maxHeight = size.height;
    double currentHeight = minHeight + (maxHeight - minHeight) * progress;
    return Rect.fromLTWH(0, 0, size.width, currentHeight);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) => true;
}
