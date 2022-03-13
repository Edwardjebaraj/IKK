import 'package:ecommerce_int2/models/product.dart';
import 'package:ecommerce_int2/screens/main/components/product-details.dart';
import 'package:ecommerce_int2/screens/shop/components/user_element.dart';
import 'package:ecommerce_int2/services/auth.services.dart';
import 'package:ecommerce_int2/services/engagement.services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'category_card.dart';
import '../../../app_properties.dart';

Widget text(
  String text, {
  var fontSize = 10,
  textColor = Colors.green,
  var fontFamily,
  var isCentered = false,
  var maxLine = 1,
  var latterSpacing = 0.5,
  bool textAllCaps = false,
  var isLongText = false,
  bool lineThrough = false,
}) {
  return Text(
    textAllCaps ? text.toUpperCase() : text,
    textAlign: isCentered ? TextAlign.center : TextAlign.start,
    maxLines: isLongText ? null : maxLine,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontFamily: fontFamily ?? null,
      fontSize: fontSize,
      color: textColor,
      height: 1.5,
      letterSpacing: latterSpacing,
      decoration:
          lineThrough ? TextDecoration.lineThrough : TextDecoration.none,
    ),
  );
}

class SellerOrderPreviewList extends StatefulWidget {
  @override
  _SellerOrderPreviewListState createState() => _SellerOrderPreviewListState();
}

class _SellerOrderPreviewListState extends State<SellerOrderPreviewList> {
  dynamic currentUserId;
  bool isLoading = false;
  List<Consumer> consumersNew = [];

  List<Consumer> consumersOld = [];
  String selectedControl = "Current Orders";

  @override
  void initState() {
    getListOfOrders();
    super.initState();
  }

  getListOfOrders() async {
    setState(() {
      isLoading = true;
    });
    currentUserId = await getCurrentUserAuth();
    List<Consumer> temp = await getAllOrdersSeller(currentUserId['sub']);
    setState(() {
      consumersOld =
          temp.where((element) => element.order_status == 'DELIVERED').toList();
      consumersNew =
          temp.where((element) => element.order_status == 'ORDERED').toList();
      isLoading = false;
    });
  }

  completeOrder(orderId) async {
    setState(() {
      isLoading = true;
    });
    bool temp = await updateOrderStatusByOrder(orderId, 'DELIVERED');

    if (temp) {
      getListOfOrders();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Something went wrong"),
      ));
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    showAlertDialog(BuildContext context, orderId) {
      // set up the button
      Widget okButton = FlatButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();

          completeOrder(orderId);
        },
      );
      Widget cancelButton = FlatButton(
        child: Text("Cancel"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text(
          "Complete Order",
        ),
        content: Text(
          "Are you sure you want to complete this order?.",
        ),
        actions: [
          cancelButton,
          okButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    Widget listOfItems(index, Products product) {
      return Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: ListTile(
          title: Text(
            product.product_name,
            style: title,
          ),
          subtitle: (product.address != null && product.pickup_time != null)
              ? Text(product.address + " (" + product.pickup_time + ")",
                  style: subtitle)
              : Text(""),
          isThreeLine: true,
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Q - ' + product.quantity.toString(),
                style: subtitle,
              ),
              Text(
                'P - ' + product.price.toString(),
                style: subtitle,
              )
            ],
          ),
          leading: selectedControl == "Current Orders"
              ? Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primary,
                    border: Border.all(width: 1.0, color: primaryHeavy),
                  ),
                  child: new IconButton(
                    icon: new Icon(
                      Icons.check,
                      color: quinary,
                    ),
                    onPressed: () {
                      showAlertDialog(context, product.order_id);
                    },
                  ))
              : Text(
                  index,
                  style: title,
                ),
          onTap: () {},
        ),
      );
    }

    onRemove(Consumer value) async {
      print(value);
      setState(() {
        isLoading = true;
      });
      List<Products> temp = await getAllOrdersConsumerSellers(
          value.consumer_id, currentUserId['sub']);
      temp = selectedControl == "Previous Orders"
          ? temp
              .where((element) => element.order_status == 'DELIVERED')
              .toList()
          : temp.where((element) => element.order_status == 'ORDERED').toList();
      setState(() {
        isLoading = false;
      });

      final num total = temp
          .map((e) => e.price * e.quantity)
          .toList()
          .reduce((a, b) => a + b);

      showModalBottomSheet(
          context: context,
          builder: (context) {
            return StatefulBuilder(builder: (context, state) {
              return Container(
                height: 600,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: secondary,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(24),
                        topLeft: Radius.circular(24))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(30),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Orders from this user',
                              style: title,
                            ),
                            Text(
                              'Total \$ $total',
                              style: title,
                            )
                          ]),
                    ),
                    Expanded(
                        child: Scrollbar(
                            child: ListView.builder(
                      itemBuilder: (_, index) =>
                          listOfItems((index + 1).toString(), temp[index]),
                      itemCount: temp.length,
                    )))
                  ],
                ),
              );
            });
          },
          elevation: 0,
          backgroundColor: Colors.transparent);
    }

    Widget appBar1 = Container(
        padding: EdgeInsets.only(top: 50),
        child: Text(
          'Order Management',
          style: headerText,
        ));
    Widget appBar = Container(
      padding: EdgeInsets.symmetric(horizontal: 32.0),
      height: 68.0,
      color: primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          selectedControl == 'Current Orders'
              ? RaisedButton(
                  color: secondary,
                  onPressed: () {
                    setState(() {
                      selectedControl = 'Current Orders';
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
                      selectedControl = 'Current Orders';
                    });
                  },
                  child: Text(
                    'Current Orders',
                    style: TextStyle(color: quinary),
                  ),
                ),
          selectedControl == 'Previous Orders'
              ? RaisedButton(
                  color: secondary,
                  onPressed: () {
                    setState(() {
                      selectedControl = 'Previous Orders';
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
                      selectedControl = 'Previous Orders';
                    });
                  },
                  child: Text(
                    'Previous Orders',
                    style: TextStyle(color: quinary),
                  ),
                ),
        ],
      ),
    );

    Widget body = isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Expanded(
            child: Scrollbar(
              child: ListView.builder(
                itemBuilder: (_, index) => UserElement(
                  selectedControl == "Previous Orders"
                      ? consumersOld[index]
                      : consumersNew[index],
                  onRemove: onRemove,
                ),
                itemCount: selectedControl == "Previous Orders"
                    ? consumersOld.length
                    : consumersNew.length,
              ),
            ),
          );

    return Column(children: [
      appBar1,
      isLoading ? Container() : CategoryCard(onRemove: onRemove),
      appBar,
      body
    ]);
  }
}
