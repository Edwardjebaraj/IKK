import 'package:ecommerce_int2/app_properties.dart';
import 'package:ecommerce_int2/models/product.dart';
import 'package:ecommerce_int2/screens/main/main_page_consumer.dart';
import 'package:ecommerce_int2/screens/product/components/rating_bottomSheet.dart';
import 'package:ecommerce_int2/screens/shop/components/items-list-consumer.dart';
import 'package:flutter/material.dart';

class ConsumerItemList extends StatefulWidget {
  final Product product;
  final Function onRemove;

  ConsumerItemList(this.product, {Key key, this.onRemove}) : super(key: key);

  @override
  _ConsumerItemListState createState() => _ConsumerItemListState();
}

class _ConsumerItemListState extends State<ConsumerItemList> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        // onTap: () => Navigator.of(context).push(MaterialPageRoute(
        //     builder: (_) => ItemsBySellerList(widget.product))),
        onTap: () {
          widget.onRemove(true);
        },
        child: Container(
          margin: EdgeInsets.only(top: 10),
          height: 80,
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Container(
                    height: 100,
                    margin: EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                        color: quaternary,
                        boxShadow: shadow,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: 12.0, right: 12.0),
                            width: 200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  widget.product.name,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: darkGrey,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 12.0, right: 12.0),
                            width: 200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  widget.product.name,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: darkGrey,
                                  ),
                                )
                              ],
                            ),
                          )
                        ])),
              ),
              Positioned(
                top: 0,
                left: 40,
                child: SizedBox(
                    height: 90,
                    width: 90,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(1000),
                      child: Image.asset(
                        '${widget.product.image}',
                        fit: BoxFit.contain,
                      ),
                    )),
              ),
            ],
          ),
        ));
  }
}
