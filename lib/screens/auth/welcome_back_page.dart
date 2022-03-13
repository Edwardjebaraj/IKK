import 'package:ecommerce_int2/app_properties.dart';
import 'package:ecommerce_int2/screens/main/main_page_seller.dart';
import 'package:ecommerce_int2/screens/main/main_page_consumer.dart';
import 'package:ecommerce_int2/screens/shared.dart';
import 'package:ecommerce_int2/services/auth.services.dart';
import 'package:flutter/material.dart';
import 'forgot_password_page.dart';
// import 'register_page.dart';

class UserDetails {
  final userAttributeKey;
  final value;

  UserDetails(this.userAttributeKey, this.value);
}

class WelcomeBackPage extends StatefulWidget {
  WelcomeBackPage();
  @override
  _WelcomeBackPageState createState() => _WelcomeBackPageState();
}

class _WelcomeBackPageState extends State<WelcomeBackPage> {
  String selectedControl = 'Log in';
  TextEditingController email = TextEditingController(text: '');

  TextEditingController password = TextEditingController(text: '');

  TextEditingController cmfPassword = TextEditingController(text: '');

  TextEditingController emailLogin = TextEditingController(text: '');

  TextEditingController passwordLogin = TextEditingController(text: '');
  dynamic currentUser;

  bool isLoading = false;
  bool isSwitched = false;

  var textValue = 'Seller';
  void toggleSwitch(bool value) async {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
      });
    } else {
      setState(() {
        isSwitched = false;
      });
    }
  }

  proceedToNavigate(userDetails) {
    if (userDetails == 'CONSUMER') {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => MainPageConsumer()));
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => MainPageSeller()));
    }
  }

  // bool isLoading = false;
  checkAlreadyLoggedin() async {
    try {
      setState(() {
        isLoading = true;
      });

      dynamic userData = await getCurrentUser();
      print(userData);
      if (userData != null && userData != "") {
        proceedToNavigate(userData["profile"]);
      }
      setState(() {
        isLoading = false;
      });
    } catch (err) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    checkAlreadyLoggedin();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setValue(String value) {
      setState(() {
        this.selectedControl = value;
      });
    }

    // confimSignUp(String otp) async {
    //   print(otp + "otp is this");
    //   try {
    // await Amplify.Auth.confirmSignUp(
    //         username: this.email.text, confirmationCode: otp)
    //     .then((response) => {
    //           Navigator.of(context).push(
    //               MaterialPageRoute(builder: (_) => WelcomeBackPage())),
    //           setState(() {
    //             isLoading = false;
    //           })
    //         })
    //     .catchError((error) => {
    //           showAlertDialog(context, "Error", error.message),
    //           setState(() {
    //             isLoading = false;
    //           })
    //         });
    //   } catch (error) {
    //     showAlertDialog(context, "Error", error.message);
    //     setState(() {
    //       isLoading = false;
    //     });
    //   }
    // }

    signup() async {
      if (this.password.text == this.cmfPassword.text) {
        setState(() {
          isLoading = true;
        });
        try {
          Map<String, String> userAttributes = {
            'email': this.email.text,
            'password': this.password.text,
          };
          dynamic temp = await createConsumerUser(userAttributes);

          if (temp == true) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => WelcomeBackPage()));
            setState(() {
              isLoading = false;
            });
            showAlertDialog(context, "Success", "Creating user");
          } else {
            showAlertDialog(context, "Error", "Failed to create user");
            setState(() {
              isLoading = false;
            });
          }
        } catch (error) {
          print(error.toString());
          showAlertDialog(context, "Error", "Failed to create user");
          setState(() {
            isLoading = false;
          });
        }
      }
    }

    // firstTimeDataEntry() async {
    //   List<AuthUserAttribute> data = await getCurrentUser();
    //   dynamic userDetails = {};
    //   data.forEach(
    //       (element) => {userDetails[element.userAttributeKey] = element.value});
    //   print(userDetails);

    //   dynamic body = createConsumer(userDetails);
    //   print(body);
    //   (userDetails['profile'] == 'CONSUMER'
    //           ? createConsumerUser(body)
    //           : createSellerUser(body))
    //       .then((value) => {
    //             print(value),
    //             if (json.decode(value.body)['success'] == true ||
    //                 json.decode(value.body)['type'] == 'DUPLICATE')
    //               {proceedToNavigate(userDetails)},
    //             setState(() {
    //               isLoading = false;
    //             })
    //           })
    //       .catchError((onError) => {
    //             showAlertDialog(context, "Error", onError.message),
    //             setState(() {
    //               isLoading = false;
    //             })
    //           });
    // }

    login() async {
      setState(() {
        isLoading = true;
      });
      try {
        Map<String, String> userAttributes = {
          'email': this.emailLogin.text,
          'password': this.passwordLogin.text
        };
        dynamic temp;
        dynamic way;
        if (isSwitched == true) {
          way = "SELLER";
          temp = await loginSeller(userAttributes);
        } else {
          way = "CONSUMER";
          temp = await loginConsumer(userAttributes);
        }

        if (temp == true) {
          proceedToNavigate(way);
          setState(() {
            isLoading = false;
          });
        } else {
          showAlertDialog(context, "Error", "Failed to verify user");
          setState(() {
            isLoading = false;
          });
        }
      } catch (error) {
        print(error.toString());
        showAlertDialog(context, "Error", "Invalid Credentials");
        setState(() {
          isLoading = false;
        });
      }
    }

    Widget welcomeBack = Text(
      selectedControl == 'Log in' ? 'Login' : 'Sign up',
      style: TextStyle(
          color: quinary,
          fontSize: 34.0,
          fontWeight: FontWeight.bold,
          shadows: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.15),
              offset: Offset(0, 5),
              blurRadius: 10.0,
            )
          ]),
    );
    Widget forgotPassword = Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            '',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: quinary,
              fontSize: 14.0,
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ForgotPasswordPage()));
            },
            child: Text(
              'Forgot password?',
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
    Widget buttonCreator(String text) {
      return InkWell(
        onTap: () {
          // widget.userType == 'SELLER'
          //     ? Navigator.of(context)
          //         .push(MaterialPageRoute(builder: (_) => MainPageSeller()))
          //     :
          text == 'Sign up' ? signup() : login();
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 40,
          child: Center(
              child: new Text(text,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                      fontSize: 17.0))),
          decoration: BoxDecoration(color: primary),
        ),
      );
    }

    ;
    Widget loginForm = Container(
      height: 240,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TextField(
              decoration: InputDecoration(
                  hintText: 'Email', prefixIcon: Icon(Icons.email)),
              controller: emailLogin,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TextField(
              decoration: InputDecoration(
                  hintText: 'Password', prefixIcon: Icon(Icons.password)),
              controller: passwordLogin,
              style: TextStyle(fontSize: 16.0),
              obscureText: true,
            ),
          ),
          forgotPassword,
          buttonCreator('Log in'),
        ],
      ),
    );

    Widget registerForm = Container(
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TextField(
              decoration: InputDecoration(
                  hintText: 'Email', prefixIcon: Icon(Icons.email)),
              controller: email,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TextField(
              decoration: InputDecoration(
                  hintText: 'Password', prefixIcon: Icon(Icons.password)),
              controller: password,
              style: TextStyle(fontSize: 16.0),
              obscureText: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TextField(
              decoration: InputDecoration(
                  hintText: 'Confirm password',
                  prefixIcon: Icon(Icons.password)),
              controller: cmfPassword,
              style: TextStyle(fontSize: 16.0),
              obscureText: true,
            ),
          ),
          buttonCreator('Sign up')
        ],
      ),
    );

    Widget customTabBarButtons(String text) {
      return ButtonTheme(
        buttonColor: selectedControl == text
            ? Color.fromRGBO(255, 255, 255, 1)
            : Color.fromRGBO(255, 255, 255, 0.5),
        minWidth: 150,
        child: RaisedButton(
          onPressed: () => {setValue(text)},
          child: Text(text, style: TextStyle(fontSize: 20)),
        ),
      );
    }

    Widget customTabBar = Container(
      padding: const EdgeInsets.only(right: 0, top: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          customTabBarButtons('Log in'),
          customTabBarButtons('Sign up')
        ],
      ),
    );

    Widget loginDescription = Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'New to iKadai? ',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: quinary,
              fontSize: 14.0,
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                setValue('Sign up');
              });
            },
            child: Text(
              'Register',
              style: title,
            ),
          ),
        ],
      ),
    );

    Widget signupDescription = Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Already Having an account? ',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: quinary,
              fontSize: 14.0,
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                setValue('Log in');
              });
            },
            child: Text(
              'Login',
              style: title,
            ),
          ),
        ],
      ),
    );

    Widget copyright = Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Powered by common Sense Software solutions LLP',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: quinary,
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      body: Stack(
        children: isLoading
            ? [
                Center(
                  child: CircularProgressIndicator(),
                )
              ]
            : <Widget>[
                Container(
                  decoration: BoxDecoration(color: secondary),
                ),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        // widget.userType == "SELLER"
                        //     ? <Widget>[
                        //         Spacer(flex: 3),
                        //         welcomeBack,
                        //         Spacer(),
                        //         subTitle,
                        //         Spacer(flex: 2),
                        //         loginForm,
                        //         Spacer(flex: 2),
                        //         forgotPassword
                        //       ]
                        //     :
                        <Widget>[
                      selectedControl == "Log in"
                          ? Row(
                              children: [
                                Switch(
                                  onChanged: toggleSwitch,
                                  value: isSwitched,
                                  activeColor: primary,
                                  activeTrackColor: primary,
                                ),
                                Text(
                                  textValue,
                                  style: TextStyle(color: quinary),
                                ),
                              ],
                            )
                          : Container(),
                      Spacer(),
                      welcomeBack,
                      Spacer(),
                      selectedControl == "Log in" ? loginForm : registerForm,
                      Spacer(flex: 2),
                      selectedControl == "Log in"
                          ? loginDescription
                          : signupDescription,
                      copyright
                    ],
                  ),
                )
              ],
      ),
    );
  }
}
