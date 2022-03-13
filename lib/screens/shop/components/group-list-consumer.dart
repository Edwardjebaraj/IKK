import 'dart:convert';

import 'package:ecommerce_int2/models/product.dart';
import 'package:ecommerce_int2/screens/product/view_product_page.dart';
import 'package:ecommerce_int2/screens/shop/components/product_element.dart';
import 'package:ecommerce_int2/services/engagement.services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../app_properties.dart';
import 'items-list-consumer.dart';

class GroupBySellerList extends StatefulWidget {
  dynamic seller;
  String consumerId;
  GroupBySellerList(this.seller, this.consumerId);

  @override
  _GroupBySellerListState createState() => _GroupBySellerListState();
}

class _GroupBySellerListState extends State<GroupBySellerList> {
  List<Groups> groups = [];
  bool isLoading = false;
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    getGroups();

    super.initState();
  }

  getGroups() async {
    setState(() {
      isLoading = true;
      groups = [];
    });
    List<Groups> temp = await getAllGroups(widget.seller.seller_id);
    print(temp);
    setState(() {
      groups = temp;
      isLoading = false;
    });
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
          widget.seller?.name ?? '',
          style: headerText,
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.white,
                  ),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search for Sale',
                        prefixIcon: SvgPicture.asset(
                          'assets/icons/search_icon.svg',
                          fit: BoxFit.scaleDown,
                        )),
                    onChanged: (value) {},
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.0, bottom: 16),
                  child: Text(
                    'Currently active sales',
                    style: TextStyle(color: quinary, fontSize: 17),
                  ),
                ),
                SizedBox(
                  height: 500,
                  child: Scrollbar(
                    child: ListView.builder(
                      itemBuilder: (_, index) => Card(
                        child: ListTile(
                            onTap: () => {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => ItemsBySellerList(
                                          groups[index].groupId,
                                          widget.consumerId)))
                                },
                            trailing: Text(
                              groups[index].delivery == 1
                                  ? 'Delivery Available'
                                  : 'Delivery not Available',
                              style: subtitle,
                            ),
                            title: Text(
                              groups[index].groupName,
                              style: title,
                            ),
                            subtitle: Text(
                                'Expiry date: ' +
                                    DateFormat.yMMMd().format(
                                        DateTime.parse(groups[index].endTime)),
                                style: subtitle),
                            leading: SizedBox(
                                height: 65,
                                width: 65,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(1000),
                                  child: widget.seller.display_picture !=
                                              null &&
                                          widget.seller.display_picture != ""
                                      ? Image.memory(
                                          Base64Decoder().convert(
                                              widget.seller.display_picture),
                                          fit: BoxFit.cover,
                                          alignment: Alignment.bottomRight,
                                        )
                                      : Image.asset(
                                          'assets/profile-placeholder.png',
                                          fit: BoxFit.cover,
                                          alignment: Alignment.bottomRight,
                                        ),
                                ))),
                        elevation: 5,
                        margin:
                            EdgeInsets.only(left: 10, right: 10, bottom: 15),
                        shadowColor: Colors.grey,
                      ),
                      // new ListTile(
                      //   onTap: () => {
                      //     Navigator.of(context).push(MaterialPageRoute(
                      //         builder: (_) => ItemsBySellerList(
                      //             groups[index].groupId, widget.consumerId)))
                      //   },
                      //   leading: new Text(
                      //     (index + 1).toString(),
                      //     style: title,
                      //   ),
                      //   title: Text(
                      //     groups[index].groupName,
                      //     style: title,
                      //   ),
                      // ),
                      itemCount: groups.length,
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
