import 'dart:convert';
import 'dart:io';

import 'package:ecommerce_int2/models/product.dart';
import 'package:ecommerce_int2/models/shared.dart';
import 'package:ecommerce_int2/screens/main/components/group-finalize.dart';
import 'package:ecommerce_int2/screens/main/components/select-multiple.dart';
import 'package:ecommerce_int2/screens/product/components/rating_bottomSheet.dart';
import 'package:ecommerce_int2/screens/search_page.dart';
import 'package:ecommerce_int2/screens/shop/components/product_element.dart';
import 'package:ecommerce_int2/services/auth.services.dart';
import 'package:ecommerce_int2/services/engagement.services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import '../../../app_properties.dart';
import 'add-product.dart';

class AddGroupedProductPage extends StatefulWidget {
  final isIfSoGroupId;
  AddGroupedProductPage(this.isIfSoGroupId);
  @override
  _AddGroupedProductPageState createState() => _AddGroupedProductPageState();
}

class _AddGroupedProductPageState extends State<AddGroupedProductPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController searchController = TextEditingController();
  String radioItem = '';

  List<Products> products = [];
  List<bool> checkbox = [];
  List<num> quantity = [];

  bool isLoading = false;
  dynamic currentUserId;
  bool isUpdate = false;
  @override
  void initState() {
    setState(() {
      if (widget.isIfSoGroupId == null) {
        isUpdate = false;
      } else {
        isUpdate = true;
      }
    });
    getListOfProducts();
    super.initState();
  }

  updateStuff() async {
    Map m = {"selected_products": {}, "group_id": widget.isIfSoGroupId};

    checkbox.toList().asMap().forEach((index, element) {
      if (element) {
        m["selected_products"][products[index].product_id] = quantity[index];
      }
    });
    if (m["selected_products"].length > 0) {
      bool temp2 = await updateProductGroup(m);
      if (temp2) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Success"),
        ));
      }
    }
  }

  completeStuff(data) async {
    Map m = {
      "data": {
        "group_name": data['group_name'],
        "seller_id": currentUserId['sub'],
        "start_time": data["start_time"],
        "end_time": data["end_time"],
        "delivery": true
      },
      "address": data["address"],
      "selected_products": {},
    };

    checkbox.toList().asMap().forEach((index, element) {
      if (element) {
        m["selected_products"][products[index].product_id] = quantity[index];
      }
    });
    if (m["selected_products"].length > 0) {
      bool temp2 = await addGroupSeller(m);
      if (temp2) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Success"),
        ));
      }
    }
  }

  getListOfProducts() async {
    setState(() {
      isLoading = true;
    });
    currentUserId = await getCurrentUserAuth();
    List<Products> temp;
    List<Products> temp2;
    temp = await getAllProductsSeller(currentUserId['sub']);
    if (isUpdate) {
      temp2 = await getAllProducts(widget.isIfSoGroupId);
    }
    setState(() {
      products = temp;
      quantity = List.filled(temp.length, 1);
      checkbox = List.filled(temp.length, false);
      if (isUpdate) {
        checkbox.toList().asMap().forEach((index1, element1) {
          temp2.forEach((element) {
            if (temp[index1].product_id == element.product_id &&
                temp[index1].group_id.contains(widget.isIfSoGroupId)) {
              checkbox[index1] = true;
              quantity[index1] = element.quantity;
            }
          });
        });
      }

      isLoading = false;
    });
  }

  add(value, index) {
    if (checkbox[index]) {
      setState(() {
        quantity[index] = int.parse(value);
      });
    }
  }

  subtract(index) {
    if (checkbox[index]) {
      if (quantity[index] == 1) {
        quantity = quantity;
      } else {
        setState(() {
          quantity[index]--;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: secondary,
        appBar: AppBar(
          backgroundColor: secondary,
          elevation: 0.0,
          iconTheme: IconThemeData(color: quaternary),
          actions: <Widget>[],
          title: Text(
            isUpdate ? 'Update a Group' : 'Add a Group',
            style: headerText,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            isUpdate
                ? updateStuff()
                : Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => GroupFinalizePage(completeStuff)));
          },
          child: const Icon(Icons.arrow_right),
          backgroundColor: primary,
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Container(
                      //   margin: const EdgeInsets.all(15),
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.all(Radius.circular(5)),
                      //     color: Colors.white,
                      //   ),
                      //   child: TextField(
                      //     controller: searchController,
                      //     decoration: InputDecoration(
                      //         border: InputBorder.none,
                      //         hintText: 'Search',
                      //         prefixIcon: SvgPicture.asset(
                      //           'assets/icons/search_icon.svg',
                      //           fit: BoxFit.scaleDown,
                      //         )),
                      //     onChanged: (value) {},
                      //   ),
                      // ),
                      SizedBox(
                          width: 150,
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(
                                      builder: (_) =>
                                          AddProductPage(currentUserId['sub'])))
                                  .then((value) => getListOfProducts());
                            },
                            color: primary,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Icon(
                                  Icons.add,
                                  color: quinary,
                                ),
                                Text(
                                  'Add Product',
                                  style: title,
                                )
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 500,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: products.length,
                            itemBuilder: (_, index) => Theme(
                                data: Theme.of(context).copyWith(
                                  unselectedWidgetColor: quinary,
                                ),
                                child: CheckboxListTile(
                                    contentPadding: EdgeInsets.only(bottom: 10),
                                    checkColor: secondary,
                                    activeColor: primaryHeavy,
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    dense: true,
                                    //font change
                                    title: new Text(
                                      products[index].product_name,
                                      style: title,
                                    ),
                                    value: checkbox[index],
                                    secondary: Visibility(
                                      child: Container(
                                        height: 50,
                                        width: 120,
                                        // alignment: Alignment.centerLeft,
                                        decoration: BoxDecoration(
                                            color: tertiary,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Row(
                                          children: [
                                            Container(
                                                decoration: BoxDecoration(
                                                  color: tertiary,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                width: 100.0,
                                                child: TextFormField(
                                                    initialValue:
                                                        quantity[index]
                                                                    .toString()
                                                                    .length ==
                                                                0
                                                            ? ''
                                                            : quantity[index]
                                                                .toString(),
                                                    keyboardType:
                                                        TextInputType.number,
                                                    onChanged: (value) =>
                                                        {add(value, index)},
                                                    style: TextStyle(
                                                        color: quinary),
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText: '  Quantity',
                                                      hintStyle: TextStyle(
                                                        color: secondary,
                                                        textBaseline:
                                                            TextBaseline
                                                                .alphabetic,
                                                      ),
                                                    )))
                                          ],
                                        ),
                                      ),
                                      maintainSize: true,
                                      maintainAnimation: true,
                                      maintainState: true,
                                      visible: checkbox[index],
                                    ),
                                    onChanged: (bool val) {
                                      setState(() {
                                        checkbox[index] = !checkbox[index];
                                      });
                                    }))
                            // Row(children: [
                            //   Padding(
                            //       padding: EdgeInsets.symmetric(
                            //         vertical: 0,
                            //       ),
                            //       child: Container(
                            //           width: 380,
                            //           child: ProductElement(
                            //             product: products[index],
                            //             onClick: () {},
                            //           ))),
                            //   Container(
                            //       width: 5,
                            //       child: Align(
                            //         alignment: Alignment.bottomCenter,
                            //         child: Checkbox(
                            //           value: true,
                            //           onChanged: (value) => {},
                            //           checkColor: secondary,
                            //           activeColor: primary,
                            //         ),
                            //       )),
                            // ]
                            ),
                      ),

                      // Column(
                      //   children: <Widget>[
                      //     ProductElement(
                      //       product: Product('assets/bag_1.png', 'New Item',
                      //           'This is a new Product for the Group', 12),
                      //       onClick: () {},
                      //     )
                      //   ],
                      // )
                    ],
                  ),
                ),
              ));
  }
}
