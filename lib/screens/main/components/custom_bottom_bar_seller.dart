import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app_properties.dart';

class CustomBottomBarSeller extends StatelessWidget {
  final TabController controller;

  const CustomBottomBarSeller({Key key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: secondary,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Image.asset(
                      'assets/icons/dashboard.png',
                    ),
                    onPressed: () {
                      controller.animateTo(0);
                    },
                  ),
                  // Text('Dashboard',
                  //     style: TextStyle(color: quinary, fontSize: 12))
                ],
              ),
              height: 80,
            ),
            Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Image.asset(
                        'assets/icons/groups.png',
                      ),
                      onPressed: () {
                        controller.animateTo(1);
                      },
                    ),
                    // Text(
                    //   'Groups',
                    //   style: TextStyle(color: quinary, fontSize: 12),
                    // )
                  ]),
              height: 80,
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Image.asset(
                      'assets/icons/skills.png',
                    ),
                    onPressed: () {
                      controller.animateTo(2);
                    },
                  ),
                  // Text('Settings', style: TextStyle(color: quinary, fontSize: 12))
                ],
              ),
              height: 80,
            )
          ]),
    );
  }
}
