import 'package:flutter/material.dart';

import 'models/product.dart';

const Color yellow = Color(0xffFDC054);
const Color mediumYellow = Color(0xffFDB846);
const Color darkYellow = Color(0xffE99E22);
const Color transparentYellow = Color.fromRGBO(253, 184, 70, 0.7);
const Color darkGrey = Color(0xff202020);

Color primary = Color.fromRGBO(110, 60, 255, 0.7);
Color primaryHeavy = Colors.white;
// Color secondary = Color.fromRGBO(240, 240, 240, 1);
// Color tertiary = Color.fromRGBO(66, 66, 66, 1);
// Color quaternary = Colors.black87;
// Color quinary = Colors.black54;

// Color primary = Color.fromRGBO(49, 38, 70, 1);
// Color primaryHeavy = Color.fromRGBO(140, 27, 255, 1);
Color secondary = Color.fromRGBO(33, 33, 33, 1);
Color tertiary = Colors.white;
Color quaternary = Colors.white;
Color quinary = Colors.white70;

const Color transparentPrimary = Color.fromRGBO(72, 126, 126, 0.7);

const LinearGradient mainButton = LinearGradient(colors: [
  Color.fromRGBO(236, 60, 3, 1),
  Color.fromRGBO(234, 60, 3, 1),
  Color.fromRGBO(216, 78, 16, 1),
], begin: FractionalOffset.topCenter, end: FractionalOffset.bottomCenter);

const List<BoxShadow> shadow = [
  BoxShadow(color: Colors.black12, offset: Offset(0, 3), blurRadius: 6)
];

screenAwareSize(int size, BuildContext context) {
  double baseHeight = 640.0;
  return size * MediaQuery.of(context).size.height / baseHeight;
}

TextStyle headerText = TextStyle(
  color: quinary,
  fontSize: 22,
  fontWeight: FontWeight.w900,
);

TextStyle title = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 12,
  color: quaternary,
);

TextStyle subtitle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 12,
  color: quinary,
);
void themeChange(isWhite) {
  if (isWhite) {
    primaryHeavy = Colors.black54;
    secondary = Color.fromRGBO(240, 240, 240, 1);
    tertiary = Color.fromRGBO(118, 118, 118, 1);
    quaternary = Colors.black87;
    quinary = Colors.black54;
  } else {
    primaryHeavy = Colors.white;
    secondary = Color.fromRGBO(33, 33, 33, 1);
    tertiary = Color.fromRGBO(66, 66, 66, 1);
    quaternary = Colors.white;
    quinary = Colors.white70;
  }

  headerText = TextStyle(
    color: quinary,
    fontSize: 22,
    fontWeight: FontWeight.w900,
  );

  title = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 12,
    color: quaternary,
  );

  subtitle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 12,
    color: quinary,
  );
}

  // color: primary,
  //  border: Border.all(
  //  color: primaryHeavy),