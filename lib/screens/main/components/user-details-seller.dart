import 'dart:io';

import 'package:ecommerce_int2/models/product.dart';
import 'package:ecommerce_int2/screens/product/components/rating_bottomSheet.dart';
import 'package:ecommerce_int2/screens/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import '../../../app_properties.dart';

class UserDetailsSeller extends StatefulWidget {
  @override
  _UserDetailsSellerState createState() => _UserDetailsSellerState();
}

class _UserDetailsSellerState extends State<UserDetailsSeller> {
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
    File _image = File(
        "/data/user/0/com.int2.flutter_app/cache/image_picker520344366771868806.jpg");
    final picker = ImagePicker();
    bool isImage = false;
    _imgFromCamera() async {
      final PickedFile image =
          await picker.getImage(source: ImageSource.camera, imageQuality: 50);
      print(image.toString());

      this.setState(() {
        _image = File(image.path);
        isImage = true;
      });
    }

    _imgFromGallery() async {
      final PickedFile image =
          await picker.getImage(source: ImageSource.gallery);
      this.setState(() {
        _image = File(image.path);
        isImage = true;
        print(_image);
      });
    }

    void _showPicker(context) async {
      await _imgFromCamera();
      //   showModalBottomSheet(
      //       context: context,
      //       builder: (BuildContext bc) {
      //         return SafeArea(
      //           child: Container(
      //             child: new Wrap(
      //               children: <Widget>[
      //                 new ListTile(
      //                     leading: new Icon(Icons.photo_library),
      //                     title: new Text('Photo Library'),
      //                     onTap: () async {
      //                       await _imgFromGallery();
      //                       Navigator.of(context).pop();
      //                     }),
      //                 new ListTile(
      //                   leading: new Icon(Icons.photo_camera),
      //                   title: new Text('Camera'),
      //                   onTap: () async {
      //                     await _imgFromCamera();
      //                     Navigator.of(context).pop();
      //                   },
      //                 ),
      //               ],
      //             ),
      //           ),
      //         );
      //       });
    }

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: tertiary,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: IconThemeData(color: darkGrey),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () => {},
            )
          ],
          title: Text(
            'Edit User Details',
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
            child: new Column(
              children: <Widget>[
                CircleAvatar(
                  radius: 80.0,
                  backgroundImage: FileImage(_image),
                ),
                RaisedButton(
                  onPressed: () {
                    _showPicker(context);
                  },
                  child: Icon(Icons.add_a_photo),
                ),
                new ListTile(
                  title: new TextField(
                    style: TextStyle(color: quinary),
                    decoration: new InputDecoration(
                      hintText: "User Name",
                    ),
                  ),
                ),
                new ListTile(
                  title: new TextField(
                    style: TextStyle(color: quinary),
                    decoration: new InputDecoration(
                      hintText: "Phone Number",
                    ),
                  ),
                ),
                new ListTile(
                  title: new TextField(
                    style: TextStyle(color: quinary),
                    decoration: new InputDecoration(
                      hintText: "Business Category",
                    ),
                  ),
                ),
                new ListTile(
                  title: new TextField(
                    style: TextStyle(color: quinary),
                    decoration: new InputDecoration(
                      hintText: "Business Name",
                    ),
                  ),
                ),
                new ListTile(
                  title: new TextField(
                    style: TextStyle(color: quinary),
                    decoration: new InputDecoration(
                      hintText: "Adress",
                    ),
                  ),
                ),
                new ListTile(
                  title: new TextField(
                    style: TextStyle(color: quinary),
                    decoration: new InputDecoration(
                      hintText: "City",
                    ),
                  ),
                ),
                new ListTile(
                  title: new TextField(
                    style: TextStyle(color: quinary),
                    decoration: new InputDecoration(
                      hintText: "Zipcode",
                    ),
                  ),
                ),
                RaisedButton(
                  child: Text('Add Pickup Address'),
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
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
                                width: MediaQuery.of(context).size.width,
                                child: new Column(
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: IconButton(
                                        icon: Icon(Icons.check),
                                        color: primary,
                                        onPressed: () {},
                                      ),
                                    ),
                                    new ListTile(
                                      leading: const Icon(Icons.add),
                                      title: new TextField(
                                        style: TextStyle(color: quinary),
                                        decoration: new InputDecoration(
                                          hintText: "Add Addresses",
                                        ),
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        new ListTile(
                                          leading: Text('1'),
                                          trailing: IconButton(
                                            icon: Icon(Icons.delete),
                                            color: primary,
                                            onPressed: () {},
                                          ),
                                          title: Text(
                                              '8th Cross Street, Ghandi Nagar, New delhi'),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        elevation: 0,
                        backgroundColor: Colors.transparent);
                  },
                )
              ],
            ),
          ),
        ));
  }
}
