import 'package:ecommerce_int2/app_properties.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConfirmOtpPageSignUp extends StatefulWidget {
  final sendOtp;

  ConfirmOtpPageSignUp({this.sendOtp});
  @override
  _ConfirmOtpPageSignUpState createState() => _ConfirmOtpPageSignUpState();
}

class _ConfirmOtpPageSignUpState extends State<ConfirmOtpPageSignUp> {
  TextEditingController otp = TextEditingController(text: '');

  Widget otpBox(TextEditingController otpController) {
    return Container(
        decoration: BoxDecoration(
            color: quinary,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: TextField(
            controller: otpController,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
                border: InputBorder.none, contentPadding: EdgeInsets.zero),
            style: TextStyle(fontSize: 16.0, letterSpacing: 40),
            inputFormatters: [
              LengthLimitingTextInputFormatter(6),
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ]));
  }

  @override
  Widget build(BuildContext context) {
    Widget title = Text(
      'Confirm your OTP',
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

    Widget subTitle = Padding(
        padding: const EdgeInsets.only(right: 56.0),
        child: Text(
          'Please wait, we are confirming your OTP',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ));

    Widget verifyButton = Center(
      child: InkWell(
        onTap: () {
          if (otp.text.length != 0 && otp.text.length == 6) {
            widget.sendOtp(otp.text);
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: 80,
          child: Center(
              child: new Text("Verify",
                  style: TextStyle(
                      color: quinary,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      fontSize: 20.0))),
          decoration: BoxDecoration(
              color: primaryHeavy,
              border: Border.all(color: primaryHeavy),
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

    Widget otpCode = Container(
      padding: const EdgeInsets.only(right: 28.0),
      height: 50,
      child: otpBox(otp),
    );

    Widget resendText = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Resend again after ",
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Color.fromRGBO(255, 255, 255, 0.5),
            fontSize: 14.0,
          ),
        ),
        // InkWell(
        //   onTap: () {},
        //   child: Text(
        //     '0:39',
        //     style: TextStyle(
        //       color: Colors.white,
        //       fontWeight: FontWeight.bold,
        //       fontSize: 14.0,
        //     ),
        //   ),
        // ),
      ],
    );

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Container(
        decoration: BoxDecoration(
          color: secondary,
        ),
        child: Container(
          decoration: BoxDecoration(color: secondary),
          child: Scaffold(
            backgroundColor: secondary,
            appBar: AppBar(
              backgroundColor: secondary,
              elevation: 0.0,
            ),
            body: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 28.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Spacer(flex: 3),
                      title,
                      Spacer(),
                      subTitle,
                      Spacer(flex: 1),
                      otpCode,
                      Spacer(flex: 1),
                      Padding(
                        padding: const EdgeInsets.only(right: 28.0),
                        child: verifyButton,
                      ),
                      Spacer(flex: 2),
                      resendText,
                      Spacer()
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
