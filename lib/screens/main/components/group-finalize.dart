import 'dart:convert';

import 'package:ecommerce_int2/models/product.dart';
import 'package:ecommerce_int2/screens/main/components/select-multiple.dart';
import 'package:ecommerce_int2/screens/search_page.dart';
import 'package:ecommerce_int2/services/auth.services.dart';
import 'package:ecommerce_int2/services/engagement.services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../../app_properties.dart';

class GroupFinalizePage extends StatefulWidget {
  final completeStuff;
  GroupFinalizePage(this.completeStuff);

  @override
  _GroupFinalizePageState createState() => _GroupFinalizePageState();
}

class _GroupFinalizePageState extends State<GroupFinalizePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController groupName = TextEditingController();
  TextEditingController startTime = TextEditingController();
  TextEditingController endTime = TextEditingController();
  bool isLoading = false;
  List<String> addresses = [];
  List<dynamic> selectedAddresses = [];
  dynamic userList;

  String radioItem = '';
  int active;

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
    print('userCurrent');

    print(userCurrent);
    setState(() {
      addresses = userCurrent.businessAddresses;
      isLoading = false;
    });
  }

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
    addItem(data, time, StateSetter state) {
      if (selectedAddresses
              .map((dynamic title) => title['address'])
              .toList()
              .indexOf(data) ==
          -1) {
        state(() {
          selectedAddresses
              .add({"address": data, "pickup_time": time.toString()});
        });
      } else {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
            "Enter properly",
          ),
          duration: Duration(seconds: 2),
        ));
      }
      setState(() {});
    }

    deleteItem(index, StateSetter state) {
      state(() {
        selectedAddresses.removeAt(index);
      });
      setState(() {});
    }

    bool nullfinder(data) {
      return !(data?.isEmpty ?? true);
    }

    check() {
      if (nullfinder(this.groupName.text) &&
          nullfinder(this.startTime.text) &&
          nullfinder(this.endTime.text) &&
          (this.selectedAddresses.length > 0)) {
        Map m = {
          "group_name": this.groupName.text,
          "start_time": this.startTime.text,
          "end_time": this.endTime.text,
          "address": this.selectedAddresses
        };

        widget.completeStuff(m);
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Something was not entered Properly"),
        ));
      }
    }

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: secondary,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            check();
          },
          child: const Icon(Icons.check),
          backgroundColor: primary,
        ),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: IconThemeData(color: quinary),
          actions: <Widget>[],
          title: Text(
            'Group Details',
            style: headerText,
          ),
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(color: secondary),
                child: SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: new Column(
                      children: <Widget>[
                        new ListTile(
                          leading:
                              Icon(Icons.add_shopping_cart, color: quinary),
                          title: new TextField(
                            style: TextStyle(color: quinary),
                            controller: this.groupName,
                            decoration: new InputDecoration(
                                hintText: "Group Name", hintStyle: title),
                          ),
                        ),

                        const Divider(
                          height: 1.0,
                        ),

                        new ListTile(
                          leading:
                              Icon(Icons.add_shopping_cart, color: quinary),
                          title: new Text("Start Time", style: title),
                          subtitle: new Text(
                              startTime.text.length != 0
                                  ? DateFormat('dd MMM yyyy : hh:mm a')
                                      .format(DateTime.parse(startTime.text))
                                  : '',
                              style: subtitle),
                          onTap: () => {
                            DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                minTime: DateTime.now(),
                                maxTime: DateTime(2200, 1, 1),
                                onChanged: (date) {}, onConfirm: (date) {
                              DatePicker.showTimePicker(context,
                                  showTitleActions: true,
                                  onChanged: (time) {}, onConfirm: (time) {
                                setState(() {
                                  this.startTime.text =
                                      time.toString().replaceAll('T', ' ');
                                });
                              }, currentTime: date, locale: LocaleType.en);
                            },
                                currentTime: DateTime.now(),
                                locale: LocaleType.en)
                          },
                        ),
                        new ListTile(
                          leading:
                              Icon(Icons.add_shopping_cart, color: quinary),
                          title: new Text("End Time", style: title),
                          subtitle: new Text(
                              endTime.text.length != 0
                                  ? DateFormat('dd MMM yyyy : hh:mm a')
                                      .format(DateTime.parse(endTime.text))
                                  : '',
                              style: subtitle),
                          onTap: () => {
                            DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                minTime: DateTime.now(),
                                maxTime: DateTime(2200, 1, 1),
                                onChanged: (date) {
                              print('change $date');
                            }, onConfirm: (date) {
                              DatePicker.showTimePicker(context,
                                  showTitleActions: true,
                                  onChanged: (time) {}, onConfirm: (time) {
                                setState(() {
                                  this.endTime.text =
                                      time.toString().replaceAll('T', ' ');
                                });
                              }, currentTime: date, locale: LocaleType.en);
                            },
                                currentTime: DateTime.now(),
                                locale: LocaleType.en)
                          },
                        ),
                        // new ListTile(
                        //   leading: const Icon(Icons.delivery_dining),
                        //   title: Text('Delivery'),
                        //   trailing: Switch(
                        //     onChanged: (value) {},
                        //     value: true,
                        //     activeColor: primary,
                        //     activeTrackColor: secondary,
                        //     inactiveThumbColor: tertiary,
                        //     inactiveTrackColor: secondary,
                        //   ),
                        // ),
                        new ListTile(
                          leading: Icon(Icons.description, color: quinary),
                          title: GestureDetector(
                            onTap: () => {
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
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: new Column(
                                              children: <Widget>[
                                                Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: IconButton(
                                                    icon: Icon(Icons.check),
                                                    color: primary,
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ),
                                                new ListTile(
                                                    leading: Icon(
                                                        Icons.event_available,
                                                        color: quinary),
                                                    title: new DropdownButton<
                                                        String>(
                                                      dropdownColor: quinary,
                                                      items: addresses
                                                          .map((String value) {
                                                        return new DropdownMenuItem<
                                                            String>(
                                                          value: value,
                                                          child:
                                                              new Text(value),
                                                        );
                                                      }).toList(),
                                                      hint: Text(
                                                          "Pickup Locations",
                                                          style: title),
                                                      onChanged: (data) {
                                                        DatePicker
                                                            .showDatePicker(
                                                                context,
                                                                showTitleActions:
                                                                    true,
                                                                minTime:
                                                                    DateTime
                                                                        .now(),
                                                                maxTime:
                                                                    DateTime(
                                                                        2200,
                                                                        1,
                                                                        1),
                                                                onChanged:
                                                                    (date) {
                                                          print('change $date');
                                                        }, onConfirm: (date) {
                                                          DatePicker
                                                              .showTimePicker(
                                                                  context,
                                                                  showTitleActions:
                                                                      true,
                                                                  onChanged:
                                                                      (time) {},
                                                                  onConfirm:
                                                                      (time) {
                                                            addItem(data, time,
                                                                state);
                                                          },
                                                                  currentTime:
                                                                      date,
                                                                  locale:
                                                                      LocaleType
                                                                          .en);
                                                        },
                                                                currentTime:
                                                                    DateTime
                                                                        .now(),
                                                                locale:
                                                                    LocaleType
                                                                        .en);
                                                      },
                                                    )),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.75,
                                                  child: ListView.builder(
                                                    itemCount: selectedAddresses
                                                        .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return ListTile(
                                                        trailing: IconButton(
                                                          icon: Icon(
                                                              Icons.delete),
                                                          color: primary,
                                                          onPressed: () {
                                                            deleteItem(
                                                                index, state);
                                                          },
                                                        ),
                                                        title: Text(
                                                          selectedAddresses[
                                                              index]['address'],
                                                          style: title,
                                                        ),
                                                        subtitle: Text(
                                                          DateFormat(
                                                                  'dd MMM yyyy : hh:mm a')
                                                              .format(DateTime.parse(
                                                                  selectedAddresses[
                                                                          index]
                                                                      [
                                                                      'pickup_time'])),
                                                          style: subtitle,
                                                        ),
                                                      );
                                                    },
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
                                  backgroundColor: Colors.transparent)
                            },
                            child: Text('Delivery Addresses and EOS',
                                style: title),
                          ),
                          trailing: Icon(Icons.arrow_right, color: quinary),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.75,
                          child: ListView.builder(
                            itemCount: selectedAddresses.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                  selectedAddresses[index]['address'],
                                  style: title,
                                ),
                                subtitle: Text(
                                  DateFormat('dd MMM yyyy : hh:mm a').format(
                                      DateTime.parse(selectedAddresses[index]
                                          ['pickup_time'])),
                                  style: subtitle,
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ));
  }
}
