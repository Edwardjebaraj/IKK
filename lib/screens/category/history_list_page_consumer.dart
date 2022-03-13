import 'package:ecommerce_int2/app_properties.dart';
import 'package:ecommerce_int2/models/category.dart';
import 'package:ecommerce_int2/models/product.dart';
import 'package:ecommerce_int2/screens/shop/components/product_element.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HistoryListPageConsumer extends StatefulWidget {
  @override
  _HistoryListPageConsumerState createState() =>
      _HistoryListPageConsumerState();
}

class _HistoryListPageConsumerState extends State<HistoryListPageConsumer> {
  List<Category> searchResults;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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

    return Material(
      color: tertiary,
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
                  'Shopping history',
                  style: TextStyle(
                    color: darkGrey,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
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
                    hintText: 'Search',
                    prefixIcon: SvgPicture.asset(
                      'assets/icons/search_icon.svg',
                      fit: BoxFit.scaleDown,
                    )),
                onChanged: (value) {},
              ),
            ),
            // Flexible(
            //   child: ListView.builder(
            //     itemCount: products.length,
            //     itemBuilder: (_, index) => Padding(
            //       padding: EdgeInsets.symmetric(
            //         vertical: 0,
            //       ),
            //       child: ProductElement(
            //         product: products[index],
            //         onClick: () {},
            //       ),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
