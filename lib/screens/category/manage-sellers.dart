import 'package:ecommerce_int2/app_properties.dart';
import 'package:ecommerce_int2/models/category.dart';
import 'package:ecommerce_int2/models/product.dart';
import 'package:ecommerce_int2/screens/shop/components/product_element.dart';
import 'package:ecommerce_int2/screens/shop/components/user_element.dart';
import 'package:ecommerce_int2/services/auth.services.dart';
import 'package:ecommerce_int2/services/engagement.services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ManageSeller extends StatefulWidget {
  @override
  _ManageSellerState createState() => _ManageSellerState();
}

class _ManageSellerState extends State<ManageSeller> {
  TextEditingController searchController = TextEditingController();
  TextEditingController emailCode = TextEditingController(text: '');
  dynamic currentUserId;
  bool isLoading = false;

  List<Seller> seller = [];

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
    List<Seller> temp = await getAllSellers(currentUserId['sub']);
    setState(() {
      seller = temp;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    createNewSubscription(currentUserId, email) async {
      Navigator.pop(context);
      dynamic decision = await createSubscription(currentUserId, email);
      print(decision);
      if (decision == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Succcessully added"),
        ));
        getListOfSellers();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Failed"),
        ));
      }
    }

    handleDelete(sellerId) async {
      Navigator.pop(context);
      dynamic decision =
          await deleteSubscription(currentUserId['sub'], sellerId);
      print(decision);
      if (decision == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Succcessully Deleted"),
        ));
        getListOfSellers();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Failed"),
        ));
      }
    }

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          'Manage Seller',
                          style: headerText,
                        ),
                      ),
                      RaisedButton(
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) {
                                return Container(
                                  height: 150,
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
                                      new ListTile(
                                        title: new TextField(
                                          style: title,
                                          controller: emailCode,
                                          decoration: new InputDecoration(
                                            hintText: "Seller's Email",
                                            hintStyle:
                                                TextStyle(color: quinary),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          if (this.emailCode.text.length != 0) {
                                            createNewSubscription(
                                                currentUserId['sub'],
                                                this.emailCode.text);
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
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0))),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 16.0),
                                          child: Center(
                                            child: Text(
                                              'Request',
                                              style: title,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                              elevation: 0,
                              backgroundColor: Colors.transparent);
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
                              'Add seller',
                              style: title,
                            )
                          ],
                        ),
                      )
                    ],
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
                  Flexible(
                    child: ListView.builder(
                      itemCount: seller.length,
                      itemBuilder: (_, index) => Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 0,
                        ),
                        child: UserElement(seller[index],
                            onRemove: (value) => {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return Container(
                                          height: 150,
                                          padding: EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                              color: secondary,
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(24),
                                                  topLeft:
                                                      Radius.circular(24))),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Dou you want to remove access for this Seller to view your item list?',
                                                style: subtitle,
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  handleDelete(
                                                      seller[index].seller_id);
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
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.0))),
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 16.0),
                                                  child: Center(
                                                    child: Text(
                                                      'Remove',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                      elevation: 0,
                                      backgroundColor: Colors.transparent)
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
