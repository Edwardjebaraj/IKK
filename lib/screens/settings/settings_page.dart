import 'dart:convert';

import 'package:ecommerce_int2/app_properties.dart';
import 'package:ecommerce_int2/custom_background.dart';
import 'package:ecommerce_int2/screens/auth/user_type_decider.dart';
import 'package:ecommerce_int2/screens/auth/welcome_back_page.dart';
import 'package:ecommerce_int2/screens/main/components/user-details-edit-seller.dart';
import 'package:ecommerce_int2/screens/main/components/user-details-edit.dart';
import 'package:ecommerce_int2/screens/main/components/user-details-seller.dart';
import 'package:ecommerce_int2/screens/settings/address-management.dart';
import 'package:ecommerce_int2/screens/settings/change_country.dart';
import 'package:ecommerce_int2/screens/settings/change_password_page.dart';
import 'package:ecommerce_int2/screens/settings/legal_about_page.dart';
import 'package:ecommerce_int2/screens/settings/notifications_settings_page.dart';
import 'package:ecommerce_int2/screens/shop/check_out_page_consumer.dart';
import 'package:ecommerce_int2/services/auth.services.dart';
import 'package:ecommerce_int2/services/engagement.services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'change_language_page.dart';

class SettingsPage extends StatefulWidget {
  final notifyParent;
  SettingsPage({Key key, @required this.notifyParent}) : super(key: key);
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String user;
  dynamic userList;
  bool isLoading = false;
  String base64;
  Widget bytes;
  final picker = ImagePicker();
  bool isSwitched = false;
  var textValue = 'White Mode';
  SharedPreferences prefs;
  void toggleSwitch(bool value) async {
    prefs = await SharedPreferences.getInstance();
    if (isSwitched == false) {
      setState(() {
        prefs.setBool('theme', true);
        themeChange(true);
        isSwitched = true;
      });
    } else {
      setState(() {
        prefs.setBool('theme', false);
        themeChange(false);
        isSwitched = false;
      });
    }
    widget.notifyParent();
  }

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
    updateUserPic();
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
    updateUserPic();
  }

  @override
  void initState() {
    currentUserConsumer();
    super.initState();
  }

  updateUserPic() async {
    bool userDp = (user == 'CONSUMER')
        ? await updateConsumer(
            {"consumer_id": userList['sub'], "display_picture": base64})
        : await updateSeller(
            {"seller_id": userList['sub'], "display_picture": base64});
    print(userDp);
  }

  getUserPic() async {
    dynamic userDp = (user == 'CONSUMER')
        ? await getConsumer(userList['sub'])
        : await getSeller(userList['sub']);
    print(userDp.toJson());
    setState(() {
      base64 = userDp.display_picture;
      if (base64 != null && base64 != "") {
        bytes = Image.memory(
          Base64Decoder().convert(base64),
          fit: BoxFit.fitWidth,
        );
      }
    });
  }

  currentUserConsumer() async {
    setState(() {
      isLoading = true;
    });
    userList = await getCurrentUserAuth();
    if (userList['profile'] == 'CONSUMER') {
      setState(() {
        user = 'CONSUMER';
        isLoading = false;
      });
    } else {
      setState(() {
        user = 'SELLER';
        isLoading = false;
      });
    }
    getUserPic();
  }

  signOut() async {
    userList = await getCurrentUserAuth();

    await logout({"email": userList['email']});

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => WelcomeBackPage()));
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : CustomPaint(
            painter: MainBackground(),
            child: SafeArea(
              bottom: true,
              child: LayoutBuilder(
                  builder: (builder, constraints) => SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(minHeight: constraints.maxHeight),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 24.0, left: 24.0, right: 24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Text(
                                      userList['name'] ?? "",
                                      style: headerText,
                                    )),

                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceEvenly,
                                //   crossAxisAlignment: CrossAxisAlignment.center,
                                //   children: [],
                                // ),

                                // Padding(
                                //   padding: const EdgeInsets.only(bottom: 8.0),
                                //   child: Text(
                                //     'General',
                                //     style: TextStyle(
                                //         color: Colors.black,
                                //         fontWeight: FontWeight.bold,
                                //         fontSize: 18.0),
                                //   ),
                                // ),
                                ListTile(
                                  title: Text('My Contact info', style: title),
                                  // onTap: () => Navigator.of(context).push(
                                  //     MaterialPageRoute(
                                  //         builder: (_) =>
                                  //             ChangeLanguagePage())),
                                ),
                                ListTile(
                                  title: Text('Country', style: title),
                                  trailing:
                                      Image.asset('assets/icons/country.png'),
                                  // onTap: () => Navigator.of(context).push(
                                  //     MaterialPageRoute(
                                  //         builder: (_) => ChangeCountryPage())),
                                ),
                                // ListTile(
                                //   title: Text('Notifications'),
                                //   leading:
                                //       Image.asset('assets/icons/notifications.png'),
                                //   onTap: () => Navigator.of(context).push(
                                //       MaterialPageRoute(
                                //           builder: (_) =>
                                //               NotificationSettingsPage())),
                                // ),
                                // ListTile(
                                //   title: Text(
                                //     'Legal & About',
                                //     style: title,
                                //   ),
                                //   leading: Icon(
                                //     Icons.book,
                                //     color: quinary,
                                //   ),
                                //   onTap: () => Navigator.of(context).push(
                                //       MaterialPageRoute(
                                //           builder: (_) => LegalAboutPage())),
                                // ),
                                // ListTile(
                                //   title: Text('Account Settings'),
                                //   leading: Icon(Icons.person),
                                //   onTap: () => Navigator.of(context).push(
                                //       MaterialPageRoute(
                                //           builder: (_) => UserDetailsSeller())),
                                // ),
                                ...(user != 'CONSUMER')
                                    ? [
                                        ListTile(
                                          title: Text(
                                            'Address management',
                                            style: title,
                                          ),
                                          onTap: () => Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (_) =>
                                                      AddressManagementPage())),
                                        ),
                                        ListTile(
                                          title: Text(
                                            'User details',
                                            style: title,
                                          ),
                                          onTap: () => Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (_) =>
                                                      UserDetailsEditSeller(
                                                          userList['sub'],
                                                          false))),
                                        )
                                      ]
                                    : [
                                        ListTile(
                                          title: Text(
                                            'Recent Orders',
                                            style: title,
                                          ),
                                          onTap: () => Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (_) =>
                                                      CheckOutPageConsumer())),
                                        ),
                                        ListTile(
                                          title: Text(
                                            'My Contact info',
                                            style: title,
                                          ),
                                          onTap: () => Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (_) =>
                                                      UserDetailsEdit(
                                                          userList['sub'],
                                                          false))),
                                        )
                                      ],

                                // ListTile(
                                //   title: Text('About Us'),
                                //   leading: Image.asset('assets/icons/about_us.png'),
                                //   onTap: () {},
                                // ),
                                // Padding(
                                //   padding:
                                //       const EdgeInsets.only(top: 8.0, bottom: 8.0),
                                //   child: Text(
                                //     'Account',
                                //     style: TextStyle(
                                //         color: Colors.black,
                                //         fontWeight: FontWeight.bold,
                                //         fontSize: 18.0),
                                //   ),
                                // ),
                                // ListTile(
                                //   title: Text('Change Password', style: title),
                                //   leading: Icon(
                                //     Icons.password,
                                //     color: quinary,
                                //   ),
                                //   onTap: () => Navigator.of(context).push(
                                //       MaterialPageRoute(
                                //           builder: (_) =>
                                //               ChangePasswordPage())),
                                // ),

                                ListTile(
                                  title: Text('Sign out', style: title),
                                  onTap: () => signOut(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )),
            ),
          );
  }
}
