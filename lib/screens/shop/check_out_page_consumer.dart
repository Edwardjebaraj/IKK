import 'package:ecommerce_int2/app_properties.dart';
import 'package:ecommerce_int2/models/product.dart';
import 'package:ecommerce_int2/screens/address/add_address_page.dart';
import 'package:ecommerce_int2/screens/product/view_product_page.dart';
import 'package:ecommerce_int2/screens/shop/components/product_element.dart';
import 'package:ecommerce_int2/services/auth.services.dart';
import 'package:ecommerce_int2/services/engagement.services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:intl/intl.dart'; //TODO: NOT DONE. WHEEL SCROLL QUANTITY

class CheckOutPageConsumer extends StatefulWidget {
  @override
  _CheckOutPageConsumerState createState() => _CheckOutPageConsumerState();
}

class _CheckOutPageConsumerState extends State<CheckOutPageConsumer> {
  dynamic user;
  bool isLoading = false;

  SwiperController swiperController = SwiperController();

  List<dynamic> current = [];
  List<dynamic> previous = [];

  String currentTab = 'Current Orders';

  @override
  void initState() {
    getOrders();
    super.initState();
  }

  getOrders() async {
    setState(() {
      isLoading = true;
      current = [];
      previous = [];
    });
    user = await getCurrentUserAuth();
    dynamic temp = await getAllOrders(user['sub']);
    setState(() {
      current = temp['products']
          .where((element) => element.order_status == 'ORDERED')
          .toList();

      previous = temp['products']
          .where((element) => element.order_status == 'DELIVERED')
          .toList();
      previous.forEach((element) {
        final DateTime now = DateTime.parse(element.created_at);
        final DateFormat formatter = DateFormat('yyyy-MM-dd');
        final String formatted = formatter.format(now);
        element.product_description =
            element.group_name + " (x${element.quantity})" + " " + formatted;
        element.product_name = element.product_name + " " + element.order_id;
      });
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondary,
      appBar: AppBar(
        backgroundColor: secondary,
        elevation: 0.0,
        iconTheme: IconThemeData(color: quinary),
        actions: <Widget>[],
        title: Text(
          'Orders',
          style: headerText,
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : LayoutBuilder(
              builder: (_, constraints) => SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 32.0),
                        height: 68.0,
                        color: primary,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            currentTab == 'Current Orders'
                                ? RaisedButton(
                                    color: secondary,
                                    onPressed: () {
                                      setState(() {
                                        currentTab = 'Current Orders';
                                      });
                                    },
                                    child: Text(
                                      'Current Orders',
                                      style: TextStyle(color: quinary),
                                    ),
                                  )
                                : FlatButton(
                                    color: primary,
                                    onPressed: () {
                                      setState(() {
                                        currentTab = 'Current Orders';
                                      });
                                    },
                                    child: Text(
                                      'Current Orders',
                                      style: TextStyle(color: quinary),
                                    ),
                                  ),
                            currentTab == 'Previous Orders'
                                ? RaisedButton(
                                    color: secondary,
                                    onPressed: () {
                                      setState(() {
                                        currentTab = 'Previous Orders';
                                      });
                                    },
                                    child: Text(
                                      'Previous Orders',
                                      style: TextStyle(color: quinary),
                                    ),
                                  )
                                : FlatButton(
                                    color: primary,
                                    onPressed: () {
                                      setState(() {
                                        currentTab = 'Previous Orders';
                                      });
                                    },
                                    child: Text(
                                      'Previous Orders',
                                      style: TextStyle(color: quinary),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 700,
                        child: Scrollbar(
                          child: currentTab == 'Current Orders'
                              ? ListView.builder(
                                  itemBuilder: (_, index) => ProductElement(
                                    product: current[index],
                                    onClick: (value) {},
                                  ),
                                  itemCount: current.length,
                                )
                              : ListView.builder(
                                  itemBuilder: (_, index) => ProductElement(
                                    product: previous[index],
                                    onClick: (value) {},
                                  ),
                                  itemCount: previous.length,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class Scroll extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint

    LinearGradient grT = LinearGradient(
        colors: [Colors.transparent, Colors.black26],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter);
    LinearGradient grB = LinearGradient(
        colors: [Colors.transparent, Colors.black26],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter);

    canvas.drawRect(
        Rect.fromLTRB(0, 0, size.width, 30),
        Paint()
          ..shader = grT.createShader(Rect.fromLTRB(0, 0, size.width, 30)));

    canvas.drawRect(Rect.fromLTRB(0, 30, size.width, size.height - 40),
        Paint()..color = Color.fromRGBO(50, 50, 50, 0.4));

    canvas.drawRect(
        Rect.fromLTRB(0, size.height - 40, size.width, size.height),
        Paint()
          ..shader = grB.createShader(
              Rect.fromLTRB(0, size.height - 40, size.width, size.height)));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}
