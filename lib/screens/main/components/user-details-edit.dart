import 'package:ecommerce_int2/models/product.dart';
import 'package:ecommerce_int2/services/engagement.services.dart';
import 'package:ecommerce_int2/services/util.service.dart';
import 'package:flutter/material.dart';
import '../../../app_properties.dart';

class UserDetailsEdit extends StatefulWidget {
  final String consumerd;
  final bool isFirstTime;
  UserDetailsEdit(this.consumerd, this.isFirstTime);
  @override
  _UserDetailsEditState createState() => _UserDetailsEditState();
}

class _UserDetailsEditState extends State<UserDetailsEdit> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final username = TextEditingController();
  final phoneNumber = TextEditingController();
  final address = TextEditingController();
  final city = TextEditingController();
  final zipcode = TextEditingController();

  bool isLoading = false;

  checkIfFilled() async {
    setState(() {
      isLoading = true;
    });
    Consumer temp = await getConsumer(widget.consumerd);

    setState(() {
      isLoading = false;
      username.text = temp.name;
      phoneNumber.text = temp.phone_number;
      address.text = temp.address;
      city.text = temp.city;
      zipcode.text = temp.city;
    });
  }

  @override
  void initState() {
    if (widget.isFirstTime != true) {
      checkIfFilled();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool nullfinder(data) {
      return !(data?.isEmpty ?? true);
    }

    startUpdate() async {
      if (nullfinder(this.username.text) &&
          nullfinder(this.address.text) &&
          nullfinder(this.city.text) &&
          nullfinder(this.zipcode.text) &&
          nullfinder(this.phoneNumber.text)) {
        Consumer data = new Consumer(
            consumer_id: widget.consumerd,
            name: this.username.text,
            phone_number: this.phoneNumber.text,
            address: this.address.text,
            city: this.city.text,
            zipcode: this.zipcode.text,
            display_picture: null);
        print(data.toJson());

        Map m = data.toJson();
        m.remove('email');
        m.remove('created_at');
        m.remove('updated_at');
        m.remove('display_picture');
        getWithoutNull(m);
        bool temp = await updateConsumer(m);
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
        // dynamic finalData = ;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Something was not entered Properly"),
        ));
      }
    }

    return WillPopScope(
        onWillPop: () async => widget.isFirstTime == true ? false : true,
        child: new Scaffold(
            key: _scaffoldKey,
            backgroundColor: secondary,
            appBar: AppBar(
              backgroundColor: secondary,
              automaticallyImplyLeading:
                  widget.isFirstTime == true ? false : true,
              elevation: 0.0,
              iconTheme: IconThemeData(color: quinary),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () => {startUpdate()},
                )
              ],
              title: Text(
                'User details',
                style: headerText,
              ),
            ),
            body: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: new Column(
                        children: <Widget>[
                          new ListTile(
                            title: new TextField(
                              style: TextStyle(color: quinary),
                              controller: this.username,
                              decoration: new InputDecoration(
                                  hintText: "User Name", hintStyle: title
                                  // errorText: this.username.text.length = 0
                                  //     ? 'Value Can\'t Be Empty'
                                  //     : null
                                  ),
                            ),
                          ),
                          new ListTile(
                            title: new TextField(
                              style: TextStyle(color: quinary),
                              controller: this.phoneNumber,
                              decoration: new InputDecoration(
                                  hintText: "Phone Number", hintStyle: title),
                            ),
                          ),
                          new ListTile(
                            title: new TextField(
                              style: TextStyle(color: quinary),
                              controller: this.address,
                              decoration: new InputDecoration(
                                  hintText: "Adress", hintStyle: title),
                            ),
                          ),
                          new ListTile(
                            title: new TextField(
                              style: TextStyle(color: quinary),
                              controller: this.city,
                              decoration: new InputDecoration(
                                  hintText: "City", hintStyle: title),
                            ),
                          ),
                          new ListTile(
                            title: new TextField(
                              style: TextStyle(color: quinary),
                              controller: this.zipcode,
                              decoration: new InputDecoration(
                                  hintText: "Zipcode", hintStyle: title),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )));
  }
}
