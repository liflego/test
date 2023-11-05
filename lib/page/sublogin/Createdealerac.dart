import 'dart:convert';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:sigma_space/login.dart';
import 'package:sigma_space/main.dart';
import 'package:sigma_space/page/sublogin/choose.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../classapi/class.dart';
import 'package:sizer/sizer.dart';
import 'package:email_otp/email_otp.dart';

class createAcountfordealer extends StatefulWidget {
  createAcountfordealer({Key? key}) : super(key: key);

  @override
  _createAcountfordealerState createState() => _createAcountfordealerState();
}

class _createAcountfordealerState extends State<createAcountfordealer> {
  TextEditingController usernameString = TextEditingController();
  TextEditingController nameString = TextEditingController();
  TextEditingController producttypeString = TextEditingController();
  TextEditingController phoneString = TextEditingController();
  TextEditingController passwordString = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  late String codestore;
  late int ttt;
  late String s;
  EmailOTP myauth = EmailOTP();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Sizer(builder: (context, orientation, deviceType) {
        return Scaffold(
          backgroundColor: ColorConstants.backgroundbody,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            toolbarHeight: 10.h,
            title: Text(
              "REGISTER",
              style: TextStyle(fontSize: 30.0.sp, fontFamily: 'newtitlefont'),
            ),
            backgroundColor: ColorConstants.appbarcolor,
            leading: IconButton(
                onPressed: () async {
                  SharedPreferences pagepref =
                      await SharedPreferences.getInstance();
                  pagepref.setInt("pagepre", 1);
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => login()));
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 20.sp,
                )),
          ),
          body: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 70.0),
                  ),
                  usernametext(),
                  nametext(),
                  phonenumbers(),
                  sentotp(),
                  OTPtext(),
                  registerbt()
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget usernametext() {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 40, right: 40),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: "YOUR EMAIL ADDRESS",
          hintStyle: TextStyle(
              fontFamily: "newbodyfont",
              fontSize: 15.sp,
              color: Colors.black45),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.amber, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.amber, width: 2),
          ),
        ),
        controller: usernameString,
        // ignore: body_might_complete_normally_nullable
        validator: (input) {
          if (input!.length < 1) {
            return "PLEASE ENTER USERNAME";
          }
        },
      ),
    );
  }

  Widget nametext() {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 40, right: 40),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: "YOUR NAME",
          hintStyle: TextStyle(
              fontFamily: "newbodyfont",
              fontSize: 15.sp,
              color: Colors.black45),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.amber, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.amber, width: 2),
          ),
        ),
        controller: nameString,
        // ignore: body_might_complete_normally_nullable
        validator: (input) {
          if (input!.length < 1) {
            return "PLEASE ENTER NAME";
          }
        },
      ),
    );
  }

  Widget phonenumbers() {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 40, right: 40),
      child: TextFormField(
        maxLength: 10,
        decoration: InputDecoration(
          hintText: "YOUR PHONE NUMBERS",
          hintStyle: TextStyle(
              fontFamily: "newbodyfont",
              fontSize: 15.sp,
              color: Colors.black45),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.amber, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.amber, width: 2),
          ),
        ),
        controller: phoneString,
        // ignore: body_might_complete_normally_nullable
        validator: (input) {
          if (input!.length < 1) {
            return "PLEASE ENTER PHONE NUMBERS";
          }
        },
      ),
    );
  }

  Widget registerbt() {
    return Padding(
      padding: EdgeInsets.only(top: 5, left: 40, right: 40),
      child: TextButton(
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(ColorConstants.buttoncolor)),
        onPressed: () async {
          if (await myauth.verifyOTP(otp: passwordString.text) == true) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("OTP is verified"),
            ));
            doregister();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Invalid OTP"),
            ));
          }
        },
        child: Center(
          child: Text(
            "REGISTER",
            style: TextStyle(
                fontSize: 20.0.sp,
                color: Colors.white,
                fontFamily: 'newbodyfont'),
          ),
        ),
      ),
    );
  }

  Widget sentotp() {
    return Padding(
      padding: EdgeInsets.only(top: 5, left: 40, right: 40),
      // ignore: deprecated_member_use
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 2, color: Colors.amber)),
        child: TextButton(
          onPressed: () async {
            myauth.setConfig(
                appEmail: usernameString.text,
                appName: "SIGB OTP",
                userEmail: usernameString.text,
                otpLength: 6,
                otpType: OTPType.digitsOnly);
            if (await myauth.sendOTP() == true) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("OTP has been sent"),
              ));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Oops, OTP send failed"),
              ));
            }
          },
          child: Center(
            child: Text(
              "SENT OTP",
              style: TextStyle(
                  fontSize: 20.0.sp,
                  color: ColorConstants.buttoncolor,
                  fontFamily: 'newbodyfont'),
            ),
          ),
        ),
      ),
    );
  }

  Widget OTPtext() {
    return Padding(
      padding: EdgeInsets.only(top: 60, left: 40, right: 40),
      child: TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          filled: false,
          hintText: "OTP VERIFICATION",
          hintStyle: TextStyle(
              fontFamily: "newbodyfont",
              fontSize: 15.sp,
              color: Colors.black45),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.amber, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.amber, width: 2),
          ),
        ),
        obscureText: false,
        controller: passwordString,
        validator: (input) {
          if (input!.isEmpty) {
            return "Please enter password";
          }
          return null;
        },
      ),
    );
  }

  Future getnewuser() async {
    String url = "http://185.78.165.189:3000/pythonapi/getnewuser";

    http.Response response = await http.get(Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=utf-8'});
    var jsonRes = await json.decode(response.body);

    String text = jsonRes["codestore"];
    String txt = text.substring(1);
    ttt = int.parse(txt);

    setState(() {
      ttt = ttt + 1;

      s = ttt.toString();
      codestore = "A" + ttt.toRadixString(16);

      print(s);
      print(codestore);
    });
  }

  Future doregister() async {
    // getnewuser();

    if (_formkey.currentState!.validate()) {
      try {
        String url = "http://185.78.165.189:3000/pythonapi/createuserwithgg";
        var body = {
          "username": usernameString.text.trim(),
          "name": nameString.text.trim(),
          "phonenumbers": phoneString.text.trim(),
          "datecreate":
              DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
          "loginstatus": "1"
        };

        http.Response response = await http.post(Uri.parse(url),
            headers: {'Content-Type': 'application/json; charset=utf-8'},
            body: JsonEncoder().convert(body));
      } catch (error) {
        print(error);
      }
    }
  }

  Future doLogin() async {
    try {
      String url = "http://185.78.165.189:3000/pythonapi/login";
      List<String> users;
      var body = {
        "username": usernameString.text.trim(),
      };

      http.Response response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json; charset=utf-8'},
          body: JsonEncoder().convert(body));

      var jsonRes = json.decode(response.body);

      if (jsonRes["success"] == 1 &&
          (jsonRes["loginstatus"] == null || jsonRes["loginstatus"] == 0)) {
        users = [
          jsonRes["userid"].toString(),
          jsonRes["username"].toString(),
          jsonRes["codestore"].toString(),
          jsonRes["name"].toString(),
          jsonRes["position"].toString(),
          jsonRes["namestore"].toString(),
          jsonRes["loginstatus"].toString(),
          jsonRes["auth"].toString(),
        ];
        SharedPreferences preferences1 = await SharedPreferences.getInstance();

        preferences1.setStringList("userid", users);

        return Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => (choose()),
          ),
        );
      }
    } catch (error) {
      return;
    }
  }
}
