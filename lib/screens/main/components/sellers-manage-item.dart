import 'package:ecommerce_int2/models/product.dart';
import 'package:ecommerce_int2/screens/main/components/add-grouped-products.dart';
import 'package:ecommerce_int2/screens/main/components/add-product.dart';
import 'package:ecommerce_int2/screens/main/components/product-details.dart';
import 'package:ecommerce_int2/screens/shop/components/product_element.dart';
import 'package:ecommerce_int2/services/auth.services.dart';
import 'package:ecommerce_int2/services/engagement.services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import '../../../app_properties.dart';

Widget text(
  String text, {
  var fontSize = 10,
  textColor = Colors.green,
  var fontFamily,
  var isCentered = false,
  var maxLine = 1,
  var latterSpacing = 0.5,
  bool textAllCaps = false,
  var isLongText = false,
  bool lineThrough = false,
}) {
  return Text(
    textAllCaps ? text.toUpperCase() : text,
    textAlign: isCentered ? TextAlign.center : TextAlign.start,
    maxLines: isLongText ? null : maxLine,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontFamily: fontFamily ?? null,
      fontSize: fontSize,
      color: textColor,
      height: 1.5,
      letterSpacing: latterSpacing,
      decoration:
          lineThrough ? TextDecoration.lineThrough : TextDecoration.none,
    ),
  );
}

class SellerManageItemList extends StatefulWidget {
  @override
  _SellerManageItemState createState() => _SellerManageItemState();
}

class _SellerManageItemState extends State<SellerManageItemList> {
  List<Groups> groups = [];
  TextEditingController searchController = TextEditingController();
  String selectedControl = "Add Group";
  TextEditingController groupName = TextEditingController();
  TextEditingController startTime = TextEditingController();
  TextEditingController endTime = TextEditingController();
  bool isLoading = false;
  dynamic currentUserId;
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
    List<Groups> temp = await getAllGroupsSeller(currentUserId['sub']);

    setState(() {
      groups = temp;
      isLoading = false;
    });
  }

  void toggleSwitch(bool value, index) async {
    if (!value) {
      setState(() {
        groups[index].disabled = 1;
      });
    } else {
      setState(() {
        groups[index].disabled = 0;
      });
    }
  }

  bool nullfinder(data) {
    return !(data?.isEmpty ?? true);
  }

  updateGroup(index, disabled) async {
    groups[index].disabled = disabled == false ? 0 : 1;
    if (nullfinder(this.groupName.text) &&
        nullfinder(this.startTime.text) &&
        nullfinder(this.endTime.text)) {
      Map m = {
        "group_name": this.groupName.text,
        "start_time": this.startTime.text,
        "end_time": this.endTime.text,
        "group_id": groups[index].groupId,
        "disabled": groups[index].disabled,
      };

      bool temp2 = await editGroupSeller(m);
      if (temp2) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Success"),
        ));
        getListOfSellers();
      } else {
        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Something was not entered Properly"),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Something was not entered Properly"),
      ));
    }
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: secondary,
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 50),
                        child: Text(
                          'Item Manage',
                          style: headerText,
                        ),
                      ),
                      RaisedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (_) => AddGroupedProductPage(null)))
                              .then((value) => getListOfSellers());
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
                              'Add Group',
                              style: title,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Flexible(
                    child: ListView.builder(
                      itemCount: groups.length,
                      itemBuilder: (_, index) => Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 0,
                        ),
                        child: ListTile(
                          leading: new Text(
                            (index + 1).toString(),
                            style: title,
                          ),
                          title: Text(
                            groups[index].groupName,
                            style: title,
                          ),
                          onTap: () {
                            setState(() {
                              groupName.text = groups[index].groupName;
                              startTime.text = groups[index]
                                  .startTime
                                  .replaceAll('T', ' ')
                                  .replaceAll('Z', '');
                              endTime.text = groups[index]
                                  .endTime
                                  .replaceAll('T', ' ')
                                  .replaceAll('Z', '');
                            });

                            bool checker =
                                groups[index].disabled == 0 ? false : true;
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) {
                                  return StatefulBuilder(
                                      builder: (context, state) {
                                    return Container(
                                      height: 400,
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                          color: secondary,
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(24),
                                              topLeft: Radius.circular(24))),
                                      child: SingleChildScrollView(
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: new Column(
                                            children: <Widget>[
                                              Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: IconButton(
                                                  icon: Icon(Icons.check),
                                                  color: quinary,
                                                  onPressed: () {
                                                    updateGroup(index, checker);
                                                  },
                                                ),
                                              ),
                                              new ListTile(
                                                leading: Icon(
                                                    Icons.add_shopping_cart,
                                                    color: quinary),
                                                title: new TextField(
                                                  style:
                                                      TextStyle(color: quinary),
                                                  controller: this.groupName,
                                                  decoration:
                                                      new InputDecoration(
                                                          hintText:
                                                              "Group Name",
                                                          hintStyle: title),
                                                ),
                                              ),
                                              const Divider(
                                                height: 1.0,
                                              ),
                                              new ListTile(
                                                leading: Icon(
                                                    Icons.add_shopping_cart,
                                                    color: quinary),
                                                title: new Text("Start Time",
                                                    style: title),
                                                subtitle: new Text(
                                                    DateFormat(
                                                            'dd MMM yyyy : hh:mm a')
                                                        .format(DateTime.parse(
                                                            startTime.text)),
                                                    style: subtitle),
                                                onTap: () => {
                                                  DatePicker.showDatePicker(
                                                      context,
                                                      showTitleActions: true,
                                                      minTime: DateTime.now(),
                                                      maxTime:
                                                          DateTime(2200, 1, 1),
                                                      onChanged: (date) {
                                                    print('change $date');
                                                  }, onConfirm: (date) {
                                                    DatePicker.showTimePicker(
                                                        context,
                                                        showTitleActions: true,
                                                        onChanged: (time) {},
                                                        onConfirm: (time) {
                                                      setState(() {
                                                        this.startTime.text =
                                                            time.toString();
                                                      });
                                                    },
                                                        currentTime: date,
                                                        locale: LocaleType.en);
                                                  },
                                                      currentTime:
                                                          DateTime.now(),
                                                      locale: LocaleType.en)
                                                },
                                              ),
                                              new ListTile(
                                                leading: Icon(
                                                    Icons.add_shopping_cart,
                                                    color: quinary),
                                                title: new Text("End Time",
                                                    style: title),
                                                subtitle: new Text(
                                                    DateFormat(
                                                            'dd MMM yyyy : hh:mm a')
                                                        .format(DateTime.parse(
                                                            endTime.text)),
                                                    style: subtitle),
                                                onTap: () => {
                                                  DatePicker.showDatePicker(
                                                      context,
                                                      showTitleActions: true,
                                                      minTime: DateTime.now(),
                                                      maxTime:
                                                          DateTime(2200, 1, 1),
                                                      onChanged: (date) {
                                                    print('change $date');
                                                  }, onConfirm: (date) {
                                                    DatePicker.showTimePicker(
                                                        context,
                                                        showTitleActions: true,
                                                        onChanged: (time) {},
                                                        onConfirm: (time) {
                                                      setState(() {
                                                        this.endTime.text =
                                                            time.toString();
                                                      });
                                                    },
                                                        currentTime: date,
                                                        locale: LocaleType.en);
                                                  },
                                                      currentTime:
                                                          DateTime.now(),
                                                      locale: LocaleType.en)
                                                },
                                              ),
                                              ListTile(
                                                title: Text(
                                                  'Disable Group',
                                                  style: title,
                                                ),
                                                leading: Checkbox(
                                                  fillColor:
                                                      MaterialStateProperty
                                                          .resolveWith(
                                                              getColor),
                                                  checkColor: Colors.white,
                                                  value: checker,
                                                  onChanged: (val) => {
                                                    state(() => {checker = val})
                                                  },
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () => {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (_) =>
                                                              AddGroupedProductPage(
                                                                  groups[index]
                                                                      .groupId)))
                                                },
                                                child: Text(
                                                  'View Group items',
                                                  style:
                                                      TextStyle(color: quinary),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                                },
                                elevation: 0,
                                backgroundColor: Colors.transparent);
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
