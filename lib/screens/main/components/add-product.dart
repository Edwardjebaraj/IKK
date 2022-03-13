import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:ecommerce_int2/models/product.dart';
import 'package:ecommerce_int2/screens/product/components/rating_bottomSheet.dart';
import 'package:ecommerce_int2/screens/search_page.dart';
import 'package:ecommerce_int2/services/engagement.services.dart';
import 'package:ecommerce_int2/services/util.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import '../../../app_properties.dart';

class AddProductPage extends StatefulWidget {
  final String sellerId;
  AddProductPage(this.sellerId);
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final productName = TextEditingController();
  final productDescription = TextEditingController();
  final price = TextEditingController();
  final productCategory = TextEditingController();
  final productImages = TextEditingController();

  ///list of product colors
  String base64;
  Widget bytes;

  final picker = ImagePicker();

  _imgFromCamera() async {
    final PickedFile image =
        await picker.getImage(source: ImageSource.camera, imageQuality: 50);
    dynamic temp = await image.readAsBytes();

    setState(() {
      base64 = base64Encode(temp);
      bytes = Image.memory(
        Base64Decoder().convert(base64),
        fit: BoxFit.fitWidth,
      );
    });
  }

  _imgFromGallery() async {
    final PickedFile image =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 50);

    dynamic temp = await image.readAsBytes();
    setState(() {
      base64 = base64Encode(temp);
      bytes = Image.memory(
        Base64Decoder().convert(base64),
        fit: BoxFit.fitWidth,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    bool nullfinder(data) {
      return !(data?.isEmpty ?? true);
    }

    startUpdate() async {
      if (nullfinder(this.productName.text) &&
          nullfinder(this.productDescription.text) &&
          nullfinder(this.productCategory.text) &&
          nullfinder(this.price.text)) {
        Products data = new Products(
          seller_id: widget.sellerId,
          product_name: this.productName.text,
          product_description: this.productDescription.text,
          product_category: this.productCategory.text,
          price: int.parse(this.price.text),
        );
        if (base64 != null) {
          data.product_images = base64;
        }

        Map m = data.toJson();
        m.remove('quantity');
        m.remove('product_id');
        m.remove('order_id');
        m.remove('group_id');
        m.remove('orderedQuantity');
        m.remove('start_time');
        m.remove('end_time');
        m.remove('delivery');
        m.remove('status');
        m.remove('order_status');
        m.remove('created_at');
        m.remove('updated_at');

        getWithoutNull(m);
        bool temp = await addProductSeller(m);
        print(temp);
        if (temp) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Success"),
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Failed retry"),
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Something was not entered Properly"),
        ));
      }
    }

    // void _showPicker(context) async {
    //   // await _imgFromCamera();
    //   showModalBottomSheet(
    //       context: context,
    //       builder: (BuildContext bc) {
    //         return StatefulBuilder(builder: (context, state) {
    //           return SafeArea(
    //             child: Container(
    //               child: new Wrap(
    //                 children: <Widget>[
    //                   new ListTile(
    //                       leading: new Icon(Icons.photo_library),
    //                       title: new Text('Photo Library'),
    //                       onTap: () async {
    //                         await _imgFromGallery();
    //                       }),
    //                   new ListTile(
    //                     leading: new Icon(Icons.photo_camera),
    //                     title: new Text('Camera'),
    //                     onTap: () async {
    //                       await _imgFromCamera();
    //                     },
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           );
    //         });
    //       });
    // }

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: secondary,
        appBar: AppBar(
          backgroundColor: secondary,
          elevation: 0.0,
          iconTheme: IconThemeData(color: quinary),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () => {startUpdate()},
            )
          ],
          title: Text(
            'Add a Product',
            style: headerText,
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: new Column(
              children: <Widget>[
                (base64 == null)
                    ? Container(
                        height: 200,
                        width: 200,
                        decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.circular(10),
                          color: primary,
                        ),
                      )
                    : Container(
                        height: 200,
                        width: 200,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: bytes),
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RaisedButton(
                      color: primary,
                      onPressed: () {
                        _imgFromCamera();
                      },
                      child: Icon(
                        Icons.photo_camera,
                        color: quinary,
                      ),
                    ),
                    RaisedButton(
                      color: primary,
                      onPressed: () {
                        _imgFromGallery();
                      },
                      child: Icon(
                        Icons.photo_library,
                        color: quinary,
                      ),
                    )
                  ],
                ),
                new ListTile(
                  leading: Icon(Icons.add_shopping_cart, color: quinary),
                  title: new TextField(
                    style: TextStyle(color: quinary),
                    controller: this.productName,
                    decoration: new InputDecoration(
                      hintText: "Product Name",
                      hintStyle: title,
                    ),
                  ),
                ),
                new ListTile(
                  leading: Icon(Icons.description, color: quinary),
                  title: new TextField(
                    style: TextStyle(color: quinary),
                    controller: this.productDescription,
                    decoration: new InputDecoration(
                        hintText: "Description", hintStyle: title),
                  ),
                ),
                new ListTile(
                  leading: Icon(Icons.category, color: quinary),
                  title: new TextField(
                    style: TextStyle(color: quinary),
                    controller: this.productCategory,
                    decoration: new InputDecoration(
                        hintText: "Category", hintStyle: title),
                  ),
                ),
                new ListTile(
                  leading: Icon(
                    Icons.attach_money,
                    color: quinary,
                  ),
                  title: new TextField(
                    style: TextStyle(color: quinary),
                    controller: this.price,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    decoration: new InputDecoration(
                        hintText: "Price", hintStyle: title),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
