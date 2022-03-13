import 'dart:convert';

import 'package:ecommerce_int2/models/product.dart';
import 'package:flutter/material.dart';

import '../../../app_properties.dart';

class ProductElement extends StatefulWidget {
  Products product;
  final onClick;
  ProductElement({this.product, this.onClick});

  @override
  _ProductElementState createState() => _ProductElementState();
}

class _ProductElementState extends State<ProductElement> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => widget.onClick(true),
        child: Container(
          margin: EdgeInsets.only(top: 20),
          height: 100,
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment(0, 0.8),
                child: Container(
                    height: 100,
                    margin: EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      // color: primary,
                      // boxShadow: shadow,
                      border: Border(
                          bottom: BorderSide(width: 0.5, color: Colors.grey)),
                      // borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                              height: 80,
                              width: 80,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: widget.product.product_images != null &&
                                        widget.product.product_images != ""
                                    ? Image.memory(
                                        Base64Decoder().convert(
                                            widget.product.product_images),
                                        fit: BoxFit.cover,
                                        alignment: Alignment.bottomRight,
                                      )
                                    : Container(
                                        color: primary,
                                      ),
                              )),
                          Container(
                            padding: EdgeInsets.only(top: 12.0, left: 12.0),
                            width: 270,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text(
                                  widget.product.product_name,
                                  textAlign: TextAlign.right,
                                  style: title,
                                ),
                                Text(
                                  'Pack of ' +
                                      widget.product.quantity.toString(),
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                  style: subtitle,
                                ),
                                Text(
                                  "\$ " + widget.product.price.toString(),
                                  style: subtitle,
                                )
                              ],
                            ),
                          )
                        ])),
              ),
              // Positioned(
              //   top: 5,
              //   right: 30,
              //   child: ,
              // ),
              Positioned(
                bottom: 25,
                right: 35,
                child: ElevatedButton(
                  onPressed: null,
                  child: Text('Add'),
                  style: ButtonStyle(
                      maximumSize: MaterialStateProperty.all(Size(100, 45)),
                      minimumSize: MaterialStateProperty.all(Size(100, 45)),
                      textStyle:
                          MaterialStateProperty.all(TextStyle(fontSize: 11)),
                      backgroundColor: MaterialStateProperty.all(secondary),
                      elevation: MaterialStateProperty.all(5)),
                ),
              ),
            ],
          ),
        ));
  }
}
