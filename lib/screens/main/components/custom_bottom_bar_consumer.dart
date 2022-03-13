import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app_properties.dart';

class CustomBottomBarConsumer extends StatelessWidget {
  final TabController controller;

  const CustomBottomBarConsumer({Key key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: secondary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            width: 45,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: new IconTheme(
                    data: new IconThemeData(color: tertiary),
                    child: Icon(
                      Icons.home,
                      color: primaryHeavy,
                      size: 30.0,
                    ),
                  ),
                  onPressed: () {
                    controller.animateTo(0);
                  },
                ),
                // Text('i-Kadai', style: TextStyle(color: quinary, fontSize: 12))
              ],
            ),
            height: 50,
          ),
          Container(
            width: 45,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: new IconTheme(
                      data: new IconThemeData(color: tertiary),
                      child: Icon(
                        Icons.shopping_cart,
                        color: primaryHeavy,
                        size: 30.0,
                      ),
                    ),
                    onPressed: () {
                      controller.animateTo(1);
                    },
                  ),
                  // Text(
                  //   'Cart',
                  //   style: TextStyle(color: quinary, fontSize: 12),
                  // )
                ]),
            height: 50,
          ),
          Container(
            width: 45,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: new IconTheme(
                    data: new IconThemeData(color: tertiary),
                    child: Icon(
                      Icons.account_box,
                      color: primaryHeavy,
                      size: 30.0,
                    ),
                  ),
                  onPressed: () {
                    controller.animateTo(2);
                  },
                ),
                // Text('Accounts', style: TextStyle(color: quinary, fontSize: 12))
              ],
            ),
            height: 50,
          )
        ],
      ),
    );
  }
}
