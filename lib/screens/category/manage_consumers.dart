import 'package:ecommerce_int2/app_properties.dart';
import 'package:ecommerce_int2/models/category.dart';
import 'package:ecommerce_int2/models/product.dart';
import 'package:ecommerce_int2/screens/shop/components/user_element.dart';
import 'package:ecommerce_int2/services/auth.services.dart';
import 'package:ecommerce_int2/services/engagement.services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ManageConsumersPage extends StatefulWidget {
  @override
  _ManageConsumersPageState createState() => _ManageConsumersPageState();
}

class _ManageConsumersPageState extends State<ManageConsumersPage> {
  TextEditingController searchController = TextEditingController();
  List<Consumer> consumer = [];
  dynamic currentUserId;
  bool isLoading = false;

  @override
  void initState() {
    getListOfConsumers();
    super.initState();
  }

  getListOfConsumers() async {
    setState(() {
      isLoading = true;
    });
    currentUserId = await getCurrentUserAuth();
    List<Consumer> temp = await getAllSubscribedConsumers(currentUserId['sub']);
    // print(temp);
    setState(() {
      consumer = temp;
      isLoading = false;
    });
  }

  handleDelete(consumerId) async {
    Navigator.pop(context);
    dynamic decision =
        await deleteSubscription(consumerId, currentUserId['sub']);
    print(decision);
    if (decision == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Succcessully Deleted"),
      ));
      getListOfConsumers();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  Align(
                    alignment: Alignment(-1, 0),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        'Consumer List',
                        style: headerText,
                      ),
                    ),
                  ),
                  // Container(
                  //   padding: EdgeInsets.only(left: 16.0),
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
                  Flexible(
                    child: ListView.builder(
                      itemCount: consumer.length,
                      itemBuilder: (_, index) => Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 0,
                        ),
                        child: UserElement(
                          consumer[index],
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
                                            topLeft: Radius.circular(24))),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Dou you want to remove access for this consumer to view your item list?',
                                          style: title,
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            handleDelete(
                                                consumer[index].consumer_id);
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
                                                'Remove',
                                                style: TextStyle(
                                                  color: quinary,
                                                  fontWeight: FontWeight.bold,
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
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
