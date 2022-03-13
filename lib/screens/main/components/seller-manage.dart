import 'package:ecommerce_int2/models/product.dart';
import 'package:ecommerce_int2/screens/shop/components/user_element.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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

class ConsumerList extends StatefulWidget {
  @override
  _ConsumerListState createState() => _ConsumerListState();
}

class _ConsumerListState extends State<ConsumerList> {
  List<Product> products = [
    Product('assets/propic.png', 'Robert', 'description', 45.3),
    Product('assets/propic.png', 'Edward', 'description', 22.3),
    Product('assets/propic.png', 'Steven', 'description', 22.3),
    Product('assets/propic.png', 'Miachel', 'description', 22.3),
    Product('assets/propic.png', 'Toby', 'description', 22.3),
    Product('assets/propic.png', 'Raj', 'description', 22.3),
    Product('assets/propic.png', 'Kyle', 'description', 22.3),
    Product('assets/propic.png', 'Mbappe', 'description', 22.3),
    Product('assets/propic.png', 'Rooney', 'description', 22.3),
  ];

  @override
  Widget build(BuildContext context) {
    Widget appBar = Container(
        height: 60,
        color: secondary,
        child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // IconButton(
                //     onPressed: () => {},
                //     // Navigator.of(context)
                //     //     .push(MaterialPageRoute(builder: (_) => NotificationsPage()
                //     //     )
                //     // ),
                //     icon: Icon(Icons.notifications)),
                Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Text(
                      "Seller List",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: Colors.grey),
                    )),
                IconButton(
                    onPressed: () => {},
                    //  Navigator.of(context)
                    //     .push(MaterialPageRoute(builder: (_) => SearchPage())),
                    icon: SvgPicture.asset('assets/icons/search_icon.svg'))
              ],
            )));

    Widget body = Expanded(
      child: Scrollbar(
        child: ListView.builder(
          itemBuilder: (_, index) => UserElement(
            products[index],
            onRemove: () {
              setState(() {
                products.remove(products[index]);
              });
            },
          ),
          itemCount: products.length,
        ),
      ),
    );

    return Column(children: [appBar, body]);
  }
}
