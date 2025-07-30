import 'package:flutter/material.dart';
import 'dart:async';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double _opacity = 1.0;

  void initState() {
    super.initState();
    // her saniyede bir opacity değerini değiştir
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _opacity = _opacity == 1.0 ? 0.0 : 1.0;
      });
    });
  }

  String gosterilenYazi = ''; // Butonlara basıldıkça burası değişecek

  void butonaBas(String deger) {
    // Eğer deger bir işlem değilse, direkt ekle
    if (!['/', '-', 'x', '+', '%', ',', '='].contains(deger)) {
      setState(() {
        gosterilenYazi += deger;
      });
    }
    // Eğer deger bir işlemi temsil ediyorsa
    else {
      if (gosterilenYazi.isEmpty) return; // boşsa işlem ekleme

      String sonKarakter = gosterilenYazi[gosterilenYazi.length - 1];
      if (!['/', '-', 'x', '+', '%', ',', '='].contains(sonKarakter)) {
        setState(() {
          gosterilenYazi += deger;
        });
      }
    }
    String s = gosterilenYazi[gosterilenYazi.length - 1];
    if (s == '=') {
      double b = hesapla(gosterilenYazi);
      String c = b.toStringAsFixed(2);
      gosterilenYazi = '';
      gosterilenYazi += c;
    }
  }

  void karakterSil() {
    setState(() {
      if (gosterilenYazi.isNotEmpty) {
        gosterilenYazi = gosterilenYazi.substring(0, gosterilenYazi.length - 1);
      }
    });
  }

  double hesapla(String ifade) {
    // Eşittir varsa sondaki karakteri çıkar
    if (ifade.endsWith('=')) {
      ifade = ifade.substring(0, ifade.length - 1);
    }

    ifade = ifade.replaceAll('x', '*'); // Çarpma için 'x' yerine '*' kullan
    Parser p = Parser(); // math_expressions paketi gerekir
    Expression exp = p.parse(ifade);
    ContextModel cm = ContextModel();

    return exp.evaluate(EvaluationType.REAL, cm);
  }

  bool _isVisible = false;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: Scaffold(
        body: Column(
          children: [
            Container(
              width: w,
              height: h / 2,
              color: Colors.grey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 180),
                    child: SizedBox(
                      width: 600,
                      height: 100,
                      child: Card(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Text(
                                gosterilenYazi,
                                style: TextStyle(fontSize: 60.0),
                              ),
                              AnimatedOpacity(
                                opacity: _opacity,
                                duration: Duration(milliseconds: 300),
                                child: Text(
                                  style: TextStyle(fontSize: 50.0),
                                  "|",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _isVisible,
                    child: Container(
                      color: Colors.grey,
                      height: h / 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  fixedSize: Size(70, 50),
                                ),
                                child: Text(
                                  style: TextStyle(color: Colors.orangeAccent),
                                  "C",
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () => butonaBas('7'),
                                style: ElevatedButton.styleFrom(
                                  fixedSize: Size(70, 50),
                                ),
                                child: Text("7"),
                              ),
                              ElevatedButton(
                                onPressed: () => butonaBas('4'),
                                style: ElevatedButton.styleFrom(
                                  fixedSize: Size(70, 50),
                                ),
                                child: Text("4"),
                              ),
                              ElevatedButton(
                                onPressed: () => butonaBas('1'),
                                style: ElevatedButton.styleFrom(
                                  fixedSize: Size(70, 50),
                                ),
                                child: Text("1"),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  fixedSize: Size(70, 50),
                                ),
                                child: Text(
                                  style: TextStyle(color: Colors.orangeAccent),
                                  "C",
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () => butonaBas('7'),
                                style: ElevatedButton.styleFrom(
                                  fixedSize: Size(70, 50),
                                ),
                                child: Text("7"),
                              ),
                              ElevatedButton(
                                onPressed: () => butonaBas('4'),
                                style: ElevatedButton.styleFrom(
                                  fixedSize: Size(70, 50),
                                ),
                                child: Text("4"),
                              ),
                              ElevatedButton(
                                onPressed: () => butonaBas('1'),
                                style: ElevatedButton.styleFrom(
                                  fixedSize: Size(70, 50),
                                ),
                                child: Text("1"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.black12,
                child: Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Container(
                    color: Colors.black45,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(70, 50),
                              ),
                              child: Text(
                                style: TextStyle(color: Colors.orangeAccent),
                                "C",
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => butonaBas('7'),
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(70, 50),
                              ),
                              child: Text("7"),
                            ),
                            ElevatedButton(
                              onPressed: () => butonaBas('4'),
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(70, 50),
                              ),
                              child: Text("4"),
                            ),
                            ElevatedButton(
                              onPressed: () => butonaBas('1'),
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(70, 50),
                              ),
                              child: Text("1"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _isVisible =
                                      !_isVisible; // Değeri tersine çevir
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(70, 50),
                              ),
                              child: Text(
                                style: TextStyle(
                                  color: Colors.orangeAccent,
                                  fontSize: 20.0,
                                ),
                                "<>",
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () => karakterSil(),
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(70, 50),
                              ),
                              child: Text(
                                style: TextStyle(
                                  color: Colors.orangeAccent,
                                  fontSize: 20.0,
                                ),
                                "<<",
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => butonaBas('8'),
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(70, 50),
                              ),
                              child: Text("8"),
                            ),
                            ElevatedButton(
                              onPressed: () => butonaBas('5'),
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(70, 50),
                              ),
                              child: Text("5"),
                            ),
                            ElevatedButton(
                              onPressed: () => butonaBas('2'),
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(70, 50),
                              ),
                              child: Text("2"),
                            ),
                            ElevatedButton(
                              onPressed: () => butonaBas('0'),
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(70, 50),
                              ),
                              child: Text("0"),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () => butonaBas('%'),
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(70, 50),
                              ),
                              child: Text(
                                style: TextStyle(
                                  color: Colors.orangeAccent,
                                  fontSize: 20.0,
                                ),
                                "%",
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => butonaBas('9'),
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(70, 50),
                              ),
                              child: Text("9"),
                            ),
                            ElevatedButton(
                              onPressed: () => butonaBas('6'),
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(70, 50),
                              ),
                              child: Text("6"),
                            ),
                            ElevatedButton(
                              onPressed: () => butonaBas('3'),
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(70, 50),
                              ),
                              child: Text("3"),
                            ),
                            ElevatedButton(
                              onPressed: () => butonaBas(','),
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(70, 50),
                              ),
                              child: Text(","),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () => butonaBas('/'),
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(70, 50),
                              ),
                              child: Text(
                                style: TextStyle(
                                  color: Colors.orangeAccent,
                                  fontSize: 20.0,
                                ),
                                "/",
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => butonaBas('x'),
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(70, 50),
                              ),
                              child: Text(
                                style: TextStyle(
                                  color: Colors.orangeAccent,
                                  fontSize: 20.0,
                                ),
                                "x",
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => butonaBas('-'),
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(70, 50),
                              ),
                              child: Text(
                                style: TextStyle(
                                  color: Colors.orangeAccent,
                                  fontSize: 30.0,
                                ),
                                "-",
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => butonaBas('+'),
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(70, 50),
                              ),
                              child: Text(
                                style: TextStyle(
                                  color: Colors.orangeAccent,
                                  fontSize: 20.0,
                                ),
                                "+",
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => butonaBas('='),
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(70, 50),
                                backgroundColor: Colors.amber,
                              ),
                              child: Text(
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                                "=",
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
          ],
        ),
      ),
    );
  }
}
