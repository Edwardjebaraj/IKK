import 'package:ecommerce_int2/app_properties.dart';
import 'package:ecommerce_int2/models/category.dart';
import 'package:ecommerce_int2/services/auth.services.dart';
import 'package:ecommerce_int2/services/engagement.services.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatefulWidget {
  final Function onRemove;
  const CategoryCard({Key key, this.onRemove});

  @override
  _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  dynamic currentUserId;
  bool isLoading = false;
  List<dynamic> list = [];

  @override
  void initState() {
    getListOfOrders();
    super.initState();
  }

  getListOfOrders() async {
    setState(() {
      isLoading = true;
    });
    currentUserId = await getCurrentUserAuth();
    List<dynamic> temp = await getDashboardContent(currentUserId['sub']);
    setState(() {
      list = temp;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Card(
            color: primary,
            margin: const EdgeInsets.all(15),
            shape: RoundedRectangleBorder(
              side: new BorderSide(color: primaryHeavy, width: 1.0),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ClipRRect(
              child: Container(
                height: 200,
                padding: EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemBuilder: (_, index) => SizedBox(
                    // height: 50,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: ListTile(
                        title: Text(list[index]['product_name'], style: title),
                        subtitle:
                            Text(list[index]['group_name'], style: subtitle),
                        trailing: Text(
                            "Q- " +
                                list[index]['ordered'].toString() +
                                "/" +
                                list[index]['total'].toString(),
                            style: title),
                        leading: Text((index + 1).toString(), style: title),
                        onTap: () {},
                      ),
                    ),
                  ),
                  itemCount: list.length,
                ),
              ),
            ),
          );
  }
}
