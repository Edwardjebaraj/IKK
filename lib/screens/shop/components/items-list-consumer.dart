import 'package:ecommerce_int2/models/product.dart';
import 'package:ecommerce_int2/screens/product/view_product_page.dart';
import 'package:ecommerce_int2/screens/shop/components/product_element.dart';
import 'package:ecommerce_int2/services/engagement.services.dart';
import 'package:flutter/material.dart';

import '../../../app_properties.dart';

class ItemsBySellerList extends StatefulWidget {
  String groupId;
  String consumerId;
  ItemsBySellerList(this.groupId, this.consumerId);

  @override
  _ItemsBySellerListState createState() => _ItemsBySellerListState();
}

class _ItemsBySellerListState extends State<ItemsBySellerList> {
  List<Products> products = [];
  bool isLoading = false;
  @override
  void initState() {
    getProducts();

    super.initState();
  }

  getProducts() async {
    setState(() {
      isLoading = true;
      products = [];
    });
    List<Products> temp = await getAllProducts(widget.groupId);
    setState(() {
      products = temp;
      isLoading = false;
    });
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  addProducts(int quantity, String productId, Products product) async {
    setState(() {
      isLoading = true;
    });
    dynamic temp = await createOrder(widget.groupId, widget.consumerId,
        productId, quantity, 'CART', product.quantity);
    if (temp == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Succcessully added"),
      ));
    } else if (temp == false) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed"),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 4),
        content: Text(
            "Some other Group Item has been added to cart,remove that and add this"),
      ));
    }
    setState(() {
      isLoading = false;
    });

    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: secondary,
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
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SizedBox(
                height: 500,
                child: Scrollbar(
                  child: ListView.builder(
                    itemBuilder: (_, index) => ProductElement(
                      product: products[index],
                      onClick: (value) {
                        int quantity = 0;
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) {
                              add(index, StateSetter state) {
                                if (products[index].quantity == quantity) {
                                  state(() {
                                    quantity = quantity;
                                  });
                                } else {
                                  state(() {
                                    quantity++;
                                  });
                                }
                                print(quantity);
                              }

                              subtract(indexm, StateSetter state) {
                                if (quantity == 0) {
                                  quantity = quantity;
                                } else {
                                  state(() {
                                    quantity--;
                                  });
                                }
                                print(quantity);
                              }

                              return Padding(
                                  padding: MediaQuery.of(context).viewInsets,
                                  child: StatefulBuilder(
                                      builder: (context, state) {
                                    return Container(
                                      height: 200,
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                          color: secondary,
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(24),
                                              topLeft: Radius.circular(24))),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Total Quantity  " +
                                                products[index]
                                                    .quantity
                                                    .toString(),
                                            style: title,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Text("QUANTITY", style: subtitle),
                                              Container(
                                                // alignment: Alignment.centerLeft,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Row(
                                                  children: [
                                                    // new IconButton(
                                                    //     icon:
                                                    //         new Icon(Icons.remove),
                                                    //     onPressed: () =>
                                                    //         subtract(index, state)),
                                                    Container(
                                                        width: 200.0,
                                                        child: TextField(
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            onChanged:
                                                                (value) => {
                                                                      print(int
                                                                          .parse(
                                                                              value)),
                                                                      state(() {
                                                                        quantity =
                                                                            int.parse(value);
                                                                      }),
                                                                      print(
                                                                          quantity)
                                                                    },
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black))),
                                                    // new Text('$quantity'),
                                                    // new IconButton(
                                                    //     icon: new Icon(Icons.add),
                                                    //     onPressed: () =>
                                                    //         add(index, state))
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.of(context).pop();

                                              if (quantity > 0 &&
                                                  quantity <=
                                                      products[index]
                                                          .quantity) {
                                                addProducts(
                                                    quantity,
                                                    products[index].product_id,
                                                    products[index]);
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "Quantity should be below available quantity"),
                                                ));
                                              }
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.5,
                                              decoration: BoxDecoration(
                                                  color: primary,
                                                  border: Border.all(
                                                      color: primaryHeavy),
                                                  // gradient: mainButton,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              10.0))),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 16.0),
                                              child: Center(
                                                child: Text(
                                                  'Add',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  }));
                            },
                            elevation: 0,
                            backgroundColor: Colors.transparent);
                      },
                    ),
                    itemCount: products.length,
                  ),
                ),
              ));
  }
}
