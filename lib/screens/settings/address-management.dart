import 'dart:convert';

import 'package:ecommerce_int2/app_properties.dart';
import 'package:ecommerce_int2/custom_background.dart';
import 'package:ecommerce_int2/models/product.dart';
import 'package:ecommerce_int2/screens/auth/user_type_decider.dart';
import 'package:ecommerce_int2/screens/auth/welcome_back_page.dart';
import 'package:ecommerce_int2/screens/main/components/user-details-seller.dart';
import 'package:ecommerce_int2/screens/settings/change_country.dart';
import 'package:ecommerce_int2/screens/settings/change_password_page.dart';
import 'package:ecommerce_int2/screens/settings/legal_about_page.dart';
import 'package:ecommerce_int2/screens/settings/notifications_settings_page.dart';
import 'package:ecommerce_int2/screens/shop/check_out_page_consumer.dart';
import 'package:ecommerce_int2/services/auth.services.dart';
import 'package:ecommerce_int2/services/engagement.services.dart';
import 'package:flutter/material.dart';

import 'change_language_page.dart';

class AddressManagementPage extends StatefulWidget {
  AddressManagementPage();
  @override
  _AddressManagementPageState createState() => _AddressManagementPageState();
}

class _AddressManagementPageState extends State<AddressManagementPage> {
  String user;
  dynamic userList;
  bool isLoading = false;
  final newItem = TextEditingController();
  List<String> addresses = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    currentUserSeller();
    super.initState();
  }

  currentUserSeller() async {
    setState(() {
      isLoading = true;
    });
    userList = await getCurrentUserAuth();

    Seller userCurrent = await getSeller(userList['sub']);

    print(userCurrent);
    setState(() {
      addresses = userCurrent.businessAddresses;
    });
    if (userList['profile'] == 'CONSUMER') {
      setState(() {
        user = 'CONSUMER';
        isLoading = false;
      });
      return true;
    } else {
      setState(() {
        user = 'SELLER';
        isLoading = false;
      });
      return false;
    }
  }

  finishUpdate() async {
    setState(() {
      isLoading = true;
    });

    Map map = {
      "business_addresses": jsonEncode(addresses),
      "seller_id": userList['sub']
    };
    bool temp = await updateSeller(map);
    print(map);
    setState(() {
      isLoading = false;
    });
    if (temp) {
      Navigator.of(context).pop();
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          "Something wentWrong",
        ),
        duration: Duration(seconds: 2),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    addItem() {
      print((addresses.indexOf(this.newItem.text) != -1));

      if (this.newItem.text != null &&
          this.newItem.text != "" &&
          (addresses.indexOf(this.newItem.text) == -1)) {
        print(addresses.indexOf(this.newItem.text));
        setState(() {
          addresses.add(this.newItem.text);
          this.newItem.clear();
        });
      } else {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
            "Enter properly",
          ),
          duration: Duration(seconds: 2),
        ));
      }
    }

    deleteItem(index) {
      setState(() {
        addresses.removeAt(index);
      });
    }

    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            floatingActionButton: Visibility(
              child: FloatingActionButton(
                onPressed: () {
                  finishUpdate();
                },
                child: const Icon(Icons.check),
                backgroundColor: primary,
              ),
              visible: true, // set it to false
            ),
            key: _scaffoldKey,
            body: Material(
                child: CustomPaint(
              painter: MainBackground(),
              child: SafeArea(
                bottom: true,
                child: LayoutBuilder(
                    builder: (builder, constraints) => SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                                minHeight: constraints.maxHeight),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 24.0, left: 24.0, right: 24.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Text(
                                        'Settings',
                                        style: headerText,
                                      )),
                                  ListTile(
                                    title: new TextField(
                                      style: TextStyle(color: quinary),
                                      controller: this.newItem,
                                      maxLines: 8,
                                      minLines: 1,
                                      decoration: new InputDecoration(
                                          hintText: "Adress", hintStyle: title),
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(Icons.check, color: quinary),
                                      color: primary,
                                      onPressed: () {
                                        addItem();
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.75,
                                    child: ListView.builder(
                                      itemBuilder: (_, index) => new ListTile(
                                        title: ListTile(
                                          title: Text(
                                            addresses[index],
                                            style: title,
                                          ),
                                          // leading: Image.asset(
                                          //     'assets/icons/change_pass.png'),
                                          trailing: IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: quinary,
                                            ),
                                            color: primary,
                                            onPressed: () {
                                              deleteItem(index);
                                            },
                                          ),
                                        ),
                                      ),
                                      itemCount: addresses.length,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),
              ),
            )),
          );
  }
}
