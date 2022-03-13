import 'package:ecommerce_int2/app_properties.dart';
import 'package:ecommerce_int2/screens/auth/welcome_back_page.dart';
import 'package:flutter/material.dart';

class UserTypeDecider extends StatefulWidget {
  @override
  _UserTypeDeciderState createState() => _UserTypeDeciderState();
}

class _UserTypeDeciderState extends State<UserTypeDecider> {
  @override
  Widget build(BuildContext context) {
    Widget welcomeBack = Text(
      'You might be,',
      style: TextStyle(
          color: Colors.white,
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

    Widget buttonCreator(String title, double top, double left) {
      return Positioned(
        left: left,
        top: top,
        child: InkWell(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => WelcomeBackPage()));
          },
          child: Container(
            width: MediaQuery.of(context).size.width / 2,
            height: 80,
            child: Center(
                child: new Text(title,
                    style: const TextStyle(
                        color: const Color(0xfffefefe),
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                        fontSize: 20.0))),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(236, 60, 3, 1),
                      Color.fromRGBO(234, 60, 3, 1),
                      Color.fromRGBO(216, 78, 16, 1),
                    ],
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.16),
                    offset: Offset(0, 5),
                    blurRadius: 10.0,
                  )
                ],
                borderRadius: BorderRadius.circular(9.0)),
          ),
        ),
      );
    }

    ;

    Widget subTitle = Padding(
        padding: const EdgeInsets.only(right: 56.0),
        child: Text(
          'Choose whether you are a Seller or a Consumer',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ));

    Widget typeForm = Container(
      height: 240,
      child: Stack(
        children: <Widget>[
          buttonCreator('SELLER', 0.0, 0.0),
          buttonCreator('CONSUMER', MediaQuery.of(context).size.height / 6,
              MediaQuery.of(context).size.width / 3)
        ],
      ),
    );

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/background.jpg'),
                    fit: BoxFit.cover)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Spacer(flex: 3),
                welcomeBack,
                Spacer(),
                subTitle,
                Spacer(flex: 2),
                typeForm,
                Spacer(flex: 2)
              ],
            ),
          )
        ],
      ),
    );
  }
}
