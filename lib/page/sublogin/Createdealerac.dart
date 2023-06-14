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
import 'package:sigma_space/page/sublogin/googlelogin.dart';
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
  TextEditingController namestoreString = TextEditingController();
  TextEditingController producttypeString = TextEditingController();
  TextEditingController phoneString = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  late String codestore;
  late int ttt;
  late String s;

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
                  namestoretext(),
                  producttext(),
                  phonenumbers(),
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

  Widget namestoretext() {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 40, right: 40),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: "YOUR NAME STORE",
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
        controller: namestoreString,
        // ignore: body_might_complete_normally_nullable
        validator: (input) {
          if (input!.length < 1) {
            return "PLEASE ENTER NAME STORE";
          }
        },
      ),
    );
  }

  Widget producttext() {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 40, right: 40),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: "YOUR PRODUCT TYPE",
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
        controller: producttypeString,
        // ignore: body_might_complete_normally_nullable
        validator: (input) {
          if (input!.length < 1) {
            return "PLEASE ENTER PRODUCT TYPE";
          }
        },
      ),
    );
  }

  Widget phonenumbers() {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 40, right: 40),
      child: TextFormField(
        maxLength: 1,
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
      padding: EdgeInsets.only(top: 60, left: 40, right: 40),
      child: TextButton(
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(ColorConstants.buttoncolor)),
        onPressed: doregister,
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
    getnewuser();
    if (_formkey.currentState!.validate()) {
      try {
        String url = "http://185.78.165.189:3000/pythonapi/createuserwithgg";
        var body = {
          "username": usernameString.text.trim(),
          "uid": usernameString.text.trim(),
          "codestore": codestore,
          "namestore": namestoreString.text.trim(),
          "producttype": producttypeString.text.trim(),
          "position": 'DEALER',
          "phonenumbers": phoneString.text.trim(),
          "datecreate":
              DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
        };

        http.Response response = await http.post(Uri.parse(url),
            headers: {'Content-Type': 'application/json; charset=utf-8'},
            body: JsonEncoder().convert(body));

        return Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => (login()),
          ),
        );
      } catch (error) {
        print(error);
      }
    }
  }
}
