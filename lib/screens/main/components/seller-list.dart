import 'dart:convert';
import 'dart:developer';

import 'package:ecommerce_int2/models/product.dart';
import 'package:ecommerce_int2/screens/shop/components/group-list-consumer.dart';
import 'package:ecommerce_int2/screens/shop/components/items-list-consumer.dart';
import 'package:ecommerce_int2/screens/shop/components/user_element.dart';
import 'package:ecommerce_int2/services/auth.services.dart';
import 'package:ecommerce_int2/services/engagement.services.dart';
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

class SellerList extends StatefulWidget {
  @override
  _SellerListState createState() => _SellerListState();
}

class _SellerListState extends State<SellerList> {
  List<Seller> seller = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;

  dynamic currentUserId;
  @override
  void initState() {
    getListOfSellers();
    super.initState();
  }

  getListOfSellers() async {
    setState(() {
      isLoading = true;
    });
    currentUserId = await getCurrentUserAuth();
    List<Seller> temp;
    try {
      temp = await getAllSellers(currentUserId['sub']);
    } catch (er) {}
    setState(() {
      seller = temp;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // return Column(children: [appBar, body]);
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Material(
            color: secondary,
            child: Container(
              margin: const EdgeInsets.only(top: kToolbarHeight),
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Align(
                    alignment: Alignment(-1, 0),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        'All Nearby Stores',
                        style: headerText,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Colors.white,
                    ),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search for Store',
                          prefixIcon: SvgPicture.asset(
                            'assets/icons/search_icon.svg',
                            fit: BoxFit.scaleDown,
                          )),
                      onChanged: (value) {},
                    ),
                  ),
                  Flexible(
                    child: ListView.builder(
                      itemCount: seller.length,
                      itemBuilder: (_, index) => Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 0,
                        ),
                        child: UserElement(seller[index], onRemove: (value) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => GroupBySellerList(
                                  seller[index], currentUserId['sub'])));
                        }),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
