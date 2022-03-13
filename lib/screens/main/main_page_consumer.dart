import 'package:ecommerce_int2/custom_background.dart';
import 'package:ecommerce_int2/models/product.dart';
import 'package:ecommerce_int2/screens/category/manage-sellers.dart';
import 'package:ecommerce_int2/screens/settings/settings_page.dart';
import 'package:ecommerce_int2/screens/shop/check_out_page_consumer_cart.dart';
import 'package:ecommerce_int2/services/auth.services.dart';
import 'package:ecommerce_int2/services/engagement.services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'components/custom_bottom_bar_consumer.dart';
import 'components/seller-list.dart';
import 'components/user-details-edit.dart';

class MainPageConsumer extends StatefulWidget {
  @override
  _MainPageConsumerState createState() => _MainPageConsumerState();
}

List<String> timelines = ['Weekly featured', 'Best of June', 'Best of 2018'];
String selectedTimeline = 'Weekly featured';

class _MainPageConsumerState extends State<MainPageConsumer>
    with TickerProviderStateMixin<MainPageConsumer> {
  SwiperController swiperController;
  TabController bottomTabController;
  dynamic currentUserId;
  checkIfFilled() async {
    currentUserId = await getCurrentUserAuth();
    bool temp = await checkIfFilledService(currentUserId['sub']);
    if (!temp) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => UserDetailsEdit(currentUserId['sub'], true)));
    }
    ;
  }

  @override
  void initState() {
    super.initState();
    bottomTabController = TabController(length: 3, vsync: this);
    checkIfFilled();
  }

  @override
  Widget build(BuildContext context) {
    refresh() {
      setState(() {
        bottomTabController = TabController(length: 3, vsync: this);
      });
    }

    return new WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          bottomNavigationBar:
              CustomBottomBarConsumer(controller: bottomTabController),
          body: CustomPaint(
            painter: MainBackground(),
            child: TabBarView(
              controller: bottomTabController,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                SellerList(),
                // ManageSeller(),
                // CheckOutPageConsumer(),
                CheckOutPageConsumerCart(),
                SettingsPage(notifyParent: refresh)
              ],
            ),
          ),
        ));
  }
}
