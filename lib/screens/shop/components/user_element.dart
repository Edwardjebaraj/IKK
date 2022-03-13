import 'dart:convert';

import 'package:ecommerce_int2/app_properties.dart';
import 'package:ecommerce_int2/models/product.dart';
import 'package:ecommerce_int2/screens/main/main_page_consumer.dart';
import 'package:ecommerce_int2/screens/shop/components/items-list-consumer.dart';
import 'package:flutter/material.dart';

class UserElement extends StatefulWidget {
  final dynamic user;
  final Function onRemove;

  UserElement(this.user, {Key key, this.onRemove}) : super(key: key);

  @override
  _UserElementState createState() => _UserElementState();
}

class _UserElementState extends State<UserElement> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => widget.onRemove(widget.user),
        child: Container(
          margin: EdgeInsets.only(top: 10),
          height: 80,
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Container(
                    height: 100,
                    margin: EdgeInsets.symmetric(horizontal: 0.0),
                    decoration: BoxDecoration(
                        color: secondary,
                        boxShadow: shadow,
                        // border: Border.all(color: primaryHeavy),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(
                                top: 00,
                                // right: 12.0,
                                left: MediaQuery.of(context).size.width / 2 -
                                    120),
                            width: 300,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  widget.user?.name ?? '',
                                  textAlign: TextAlign.right,
                                  style: headerText,
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                top: 12.0,
                                // right: 12.0,
                                left: MediaQuery.of(context).size.width / 2 -
                                    120),
                            width: 300,
                            child: Wrap(
                              children: <Widget>[
                                Icon(
                                  Icons.star,
                                  color: primaryHeavy,
                                  size: 13.0,
                                ),
                                Text(
                                  '4.9 |',
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  style: subtitle,
                                ),
                                Container(
                                    padding:
                                        EdgeInsets.only(left: 10, right: 30),
                                    width: 300,
                                    child: Text(
                                      '${widget.user.business_name != null ? widget.user.business_name : ''}',
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      style: subtitle,
                                    )),
                                Text(
                                  '${widget.user.business_name != null ? widget.user.business_name : ''}',
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  style: subtitle,
                                ),
                                Text(
                                  '${widget.user.business_name != null ? widget.user.business_name : ''}',
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  style: subtitle,
                                )
                              ],
                            ),
                          )
                        ])),
              ),
              Positioned(
                top: 10,
                left: 40,
                child: SizedBox(
                    height: 65,
                    width: 65,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(1000),
                      child: widget.user.display_picture != null &&
                              widget.user.display_picture != ""
                          ? Image.memory(
                              Base64Decoder()
                                  .convert(widget.user.display_picture),
                              fit: BoxFit.cover,
                              alignment: Alignment.bottomRight,
                            )
                          : Image.asset(
                              'assets/profile-placeholder.png',
                              fit: BoxFit.cover,
                              alignment: Alignment.bottomRight,
                            ),
                    )),
              ),
            ],
          ),
        ));
  }
}
