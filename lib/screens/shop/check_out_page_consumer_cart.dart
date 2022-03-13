import 'package:ecommerce_int2/app_properties.dart';
import 'package:ecommerce_int2/models/product.dart';
import 'package:ecommerce_int2/screens/shop/components/product_element.dart';
import 'package:ecommerce_int2/services/auth.services.dart';
import 'package:ecommerce_int2/services/engagement.services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_swiper/flutter_swiper.dart'; //TODO: NOT DONE. WHEEL SCROLL QUANTITY

class CheckOutPageConsumerCart extends StatefulWidget {
  @override
  _CheckOutPageConsumerCartState createState() =>
      _CheckOutPageConsumerCartState();
}

class _CheckOutPageConsumerCartState extends State<CheckOutPageConsumerCart> {
  SwiperController swiperController = SwiperController();
  List<dynamic> products = [];
  List<dynamic> addresses = [];
  List<String> paymentType = [
    'Cash',
    'Checks',
    'Debit cards',
    'Credit cards',
    'Mobile payments',
    'Electronic bank transfers'
  ];
  dynamic currentUserId;
  Addresses selectedAddress;
  dynamic selectedPayment;
  bool isLoading = false;
  @override
  void initState() {
    getOrders();

    super.initState();
  }

  getOrders() async {
    setState(() {
      isLoading = true;
      products = [];
    });
    currentUserId = await getCurrentUserAuth();
    dynamic temp = await getAllOrders(currentUserId['sub']);

    setState(() {
      products = temp['products']
          .where((element) => element.order_status == 'CART')
          .toList();

      products.forEach((element) {
        String formatted;
        if (element.pickup_time != null && element.pickup_time != '') {
          final DateTime now = DateTime.parse(element.pickup_time);
          final DateFormat formatter = DateFormat('yyyy-MM-dd h:m:s');
          formatted = formatter.format(now);
        } else {
          formatted = 'NA';
        }
        element.product_description = "Pickup Time: " + formatted;
      });

      addresses = temp['addresses'];
      isLoading = false;
    });
    print(addresses);
  }

  deleteProducts(Products product) async {
    setState(() {
      isLoading = true;
    });
    bool temp = await deleteOrderFromCart(product.group_id, product.order_id,
        product.product_id, product.quantity);
    if (temp) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Succcessully deleted"),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed"),
      ));
    }
    setState(() {
      isLoading = false;
    });

    getOrders();
  }

  orderProducts() async {
    if (selectedAddress != null && selectedPayment != null) {
      setState(() {
        isLoading = true;
      });
      dynamic temp = await updateOrderStatus(
          currentUserId['sub'], selectedAddress.addressId, selectedPayment);
      if (temp == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Succcessully Ordered"),
        ));
      } else if (temp == false) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Failed"),
        ));
      } else if (temp == 'outOfStock') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Some Items are out of stock"),
        ));
      }
      setState(() {
        isLoading = false;
      });

      getOrders();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Select output address and payment method"),
      ));
    }
  }

  String currentTab = 'Current Orders';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Visibility(
        child: FloatingActionButton(
          onPressed: () {
            orderProducts();
          },
          child: const Icon(Icons.check),
          backgroundColor: primary,
        ),
        visible: products.length == 0 ? false : true, // set it to false
      ),
      backgroundColor: secondary,
      appBar: AppBar(
        backgroundColor: secondary,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: darkGrey),
        actions: [],
        title: Text(
          'Karthicks Kitchen',
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
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 200,
                        child: Scrollbar(
                          child: ListView.builder(
                            itemBuilder: (_, index) => ProductElement(
                              product: products[index],
                              onClick: (value) {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Container(
                                        height: 200,
                                        padding: EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                            color: secondary,
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(24),
                                                topLeft: Radius.circular(24))),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: 10, bottom: 10),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Quantity ' +
                                                        products[index]
                                                            .quantity
                                                            .toString(),
                                                    style: subtitle,
                                                  ),
                                                  Text(
                                                    'Price ' +
                                                        (products[index].price *
                                                                products[index]
                                                                    .quantity)
                                                            .toString(),
                                                    style: subtitle,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              'Dou you want to remove ${products[index].product_name} from the cart? ',
                                              style: title,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Navigator.of(context).pop();
                                                deleteProducts(products[index]);
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2.5,
                                                decoration: BoxDecoration(
                                                    color: primary,
                                                    border: Border.all(
                                                        color: primaryHeavy),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10.0))),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 16.0),
                                                child: Center(
                                                  child: Text(
                                                    'Remove',
                                                    style: title,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                    elevation: 0,
                                    backgroundColor: Colors.transparent);
                              },
                            ),
                            itemCount: products.length,
                          ),
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.all(25),
                        height: 250,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: [
                                  Switch(
                                    onChanged: null,
                                    value: true,
                                    activeColor: primary,
                                    activeTrackColor: primary,
                                  ),
                                  Text(
                                    'Pickup',
                                    style: TextStyle(color: quinary),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Pickup Location',
                                    style:
                                        TextStyle(fontSize: 12, color: quinary),
                                  ),
                                  Container(
                                      child: DropdownButton<String>(
                                    hint: Text(
                                      'Address',
                                      style: TextStyle(color: quinary),
                                    ),
                                    dropdownColor: quinary,
                                    items:
                                        addresses.asMap().entries.map((entry) {
                                      return DropdownMenuItem<String>(
                                          value: entry.key.toString(),
                                          child: new Text(entry.value.address));
                                    }).toList(),
                                    onChanged: (_) {
                                      setState(() {
                                        selectedAddress =
                                            addresses[int.parse(_)];
                                      });
                                      print(_);
                                    },
                                  ))
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Pickup Slot',
                                    style:
                                        TextStyle(fontSize: 12, color: quinary),
                                  ),
                                  Text(
                                    '\$5',
                                    style:
                                        TextStyle(fontSize: 15, color: quinary),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Payment Mode',
                                    style:
                                        TextStyle(fontSize: 12, color: quinary),
                                  ),
                                  Container(
                                      child: DropdownButton<String>(
                                    hint: Text(
                                      'Payment Type',
                                      style: TextStyle(color: quinary),
                                    ),
                                    dropdownColor: quinary,
                                    items: paymentType
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                      return DropdownMenuItem<String>(
                                          value: entry.key.toString(),
                                          child: new Text(entry.value));
                                    }).toList(),
                                    onChanged: (_) {
                                      setState(() {
                                        selectedPayment =
                                            paymentType[int.parse(_)];
                                      });
                                      print(_);
                                    },
                                  ))
                                ],
                              )
                            ]),
                      ),
                      Container(
                        padding: EdgeInsets.all(25),
                        height: 150,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Order Details',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: quinary,
                                    fontWeight: FontWeight.w500),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Item Total',
                                    style:
                                        TextStyle(fontSize: 15, color: quinary),
                                  ),
                                  Text(
                                    '\$85',
                                    style:
                                        TextStyle(fontSize: 15, color: quinary),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Handling Fees',
                                    style:
                                        TextStyle(fontSize: 15, color: quinary),
                                  ),
                                  Text(
                                    '\$5',
                                    style:
                                        TextStyle(fontSize: 15, color: quinary),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total Order Value',
                                    style:
                                        TextStyle(fontSize: 15, color: quinary),
                                  ),
                                  Text(
                                    '\$90',
                                    style:
                                        TextStyle(fontSize: 15, color: quinary),
                                  )
                                ],
                              )
                            ]),
                      )
                      // Padding(
                      //   padding: const EdgeInsets.all(16.0),
                      //   child: Text(
                      //     'Payment',
                      //     style: TextStyle(
                      //         fontSize: 20,
                      //         color: darkGrey,
                      //         fontWeight: FontWeight.bold),
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 250,
                      //   child: Swiper(
                      //     itemCount: 2,
                      //     itemBuilder: (_, index) {
                      //       return CreditCard();
                      //     },
                      //     scale: 0.8,
                      //     controller: swiperController,
                      //     viewportFraction: 0.6,
                      //     loop: false,
                      //     fade: 0.7,
                      //   ),
                      // ),
                      // SizedBox(height: 24),
                      // Center(
                      //     child: Padding(
                      //   padding: EdgeInsets.only(
                      //       bottom: MediaQuery.of(context).padding.bottom == 0
                      //           ? 20
                      //           : MediaQuery.of(context).padding.bottom),
                      //   child: checkOutButton,
                      // ))
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
