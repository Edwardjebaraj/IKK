import 'package:ecommerce_int2/custom_background.dart';
import 'package:ecommerce_int2/screens/category/manage_consumers.dart';
import 'package:ecommerce_int2/screens/main/components/custom_bottom_bar_seller.dart';
import 'package:ecommerce_int2/screens/main/components/user-details-edit-seller.dart';
import 'package:ecommerce_int2/screens/settings/settings_page.dart';
import 'package:ecommerce_int2/services/auth.services.dart';
import 'package:ecommerce_int2/services/engagement.services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'components/custom_bottom_bar_seller.dart';
import 'components/seller-order-preview-list.dart';
import 'components/sellers-manage-item.dart';

class MainPageSeller extends StatefulWidget {
  @override
  _MainPageSellerState createState() => _MainPageSellerState();
}

class _MainPageSellerState extends State<MainPageSeller>
    with TickerProviderStateMixin<MainPageSeller> {
  SwiperController swiperController;
  TabController tabController;
  TabController bottomTabController;
  dynamic currentUserId;

  checkIfFilled() async {
    currentUserId = await getCurrentUserAuth();
    bool temp = await checkIfFilledSellerService(currentUserId['sub']);
    print('Seller');
    if (!temp) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => UserDetailsEditSeller(currentUserId['sub'], true)));
    }
  }

  @override
  void initState() {
    super.initState();
    checkIfFilled();
    bottomTabController = TabController(length: 3, vsync: this);
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
              CustomBottomBarSeller(controller: bottomTabController),
          body: CustomPaint(
            painter: MainBackground(),
            child: TabBarView(
              controller: bottomTabController,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                SellerOrderPreviewList(),
                SellerManageItemList(),
                SettingsPage(notifyParent: refresh)
              ],
            ),
          ),
        ));
  }
}
