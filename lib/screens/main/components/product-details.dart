import 'package:ecommerce_int2/app_properties.dart';
import 'package:ecommerce_int2/models/product.dart';
import 'package:ecommerce_int2/screens/product/components/product_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProductDetails extends StatefulWidget {
  final Product product;
  ProductDetails({Key key, this.product}) : super(key: key);
  @override
  _ProductDetailsState createState() => _ProductDetailsState(product);
}

class _ProductDetailsState extends State<ProductDetails> {
  final Product product;
  _ProductDetailsState(this.product);

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int active;

  ///list of product colors
  List<Widget> colors() {
    List<Widget> list = [];
    for (int i = 0; i < 5; i++) {
      list.add(
        InkWell(
          onTap: () {
            setState(() {
              active = i;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
            child: Transform.scale(
              scale: active == i ? 1.2 : 1,
              child: Card(
                elevation: 3,
                color: Colors.primaries[i],
                child: SizedBox(
                  height: 32,
                  width: 32,
                ),
              ),
            ),
          ),
        ),
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    Widget description = Padding(
      padding: const EdgeInsets.all(24.0),
      child: Text(
        product.description,
        maxLines: 8,
        semanticsLabel: '...',
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.6)),
      ),
    );

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: tertiary,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: IconThemeData(color: darkGrey),
          actions: <Widget>[],
          title: Text(
            product.name,
            style: const TextStyle(
                color: darkGrey,
                fontWeight: FontWeight.w500,
                fontFamily: "Montserrat",
                fontSize: 18.0),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 300,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 16.0,
                        child: Image.asset(
                          product.image,
                          height: 200,
                          width: 200,
                        ),
                      ),
                      Positioned(
                        right: 0.0,
                        child: Container(
                          height: 280,
                          width: 300,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0),
                                child: Text(product.name,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        shadows: shadow)),
                              ),
                              InkWell(
                                onTap: () async {},
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width / 2.5,
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      gradient: mainButton,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10.0),
                                          bottomLeft: Radius.circular(10.0))),
                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                  child: Center(
                                    child: Text(
                                      'Delete Product',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  // scaffoldKey.currentState.showBottomSheet((context) {
                                  //   return ShopBottomSheet();
                                  // });
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width / 2.5,
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      gradient: mainButton,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10.0),
                                          bottomLeft: Radius.circular(10.0))),
                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                  child: Center(
                                    child: Text(
                                      'Edit product',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 2.5,
                                decoration: BoxDecoration(
                                    color: secondary,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        bottomLeft: Radius.circular(10.0))),
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Quantity- 100",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: tertiary,
                                              shadows: shadow))
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 2.5,
                                decoration: BoxDecoration(
                                    color: secondary,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        bottomLeft: Radius.circular(10.0))),
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Price- " + product.price.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: tertiary,
                                              shadows: shadow))
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                description,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[],
                ),
              ],
            ),
          ),
        ));
  }
}
