import 'package:ecommerce_int2/screens/product/view_product_page.dart';
import 'package:ecommerce_int2/screens/shop/components/product_element.dart';
import 'package:flutter/material.dart';

import '../../../app_properties.dart';

class ItemsBySellerListForSeller extends StatefulWidget {
  dynamic product;
  dynamic products = [1, 2, 3, 4];
  ItemsBySellerListForSeller(this.product);

  @override
  _ItemsBySellerListState createState() => _ItemsBySellerListState();
}

class _ItemsBySellerListState extends State<ItemsBySellerListForSeller> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: tertiary,
        appBar: AppBar(
          backgroundColor: secondary,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.grey),
          // actions: <Widget>[
          //   IconButton(
          //     icon: Image.asset('assets/icons/denied_wallet.png'),
          //     onPressed: () => Navigator.of(context)
          //         .push(MaterialPageRoute(builder: (_) => MainPageConsumer())),
          //   )
          // ],
          title: Text(
            'Items by Seller',
            style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
                fontSize: 18.0),
          ),
        ),
        body: SizedBox(
          height: 500,
          child: Scrollbar(
            child: ListView.builder(
              itemBuilder: (_, index) => ProductElement(
                product: widget.products[index],
                onClick: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => ViewProductPage()));
                },
              ),
              itemCount: widget.products.length,
            ),
          ),
        ));
  }
}
