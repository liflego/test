import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../classapi/class.dart';
import 'package:http/http.dart' as http;
import 'package:sigma_space/login.dart';

class googlelogin extends StatefulWidget {
  googlelogin({Key? key}) : super(key: key);

  @override
  _googlelogin createState() => _googlelogin();
}

class _googlelogin extends State<googlelogin> {
  TextEditingController namestoreString = TextEditingController();
  TextEditingController productypString = TextEditingController();
  TextEditingController phonenumberSting = TextEditingController();

  GoogleSignIn _googleSignIn = GoogleSignIn();
  final _formkey = GlobalKey<FormState>();
  late int ttt;
  late String s;
  late String codestore;

  @override
  void initState() {
    // TODO: implement initState
    getnewuser();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        backgroundColor: ColorConstants.backgroundbody,
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 10.h,
          title: Text(
            "REGISTER",
            style: TextStyle(fontSize: 30.0.sp, fontFamily: 'newtitlefont'),
          ),
          backgroundColor: ColorConstants.appbarcolor,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 70.0),
                ),
                showname(),
                namestore(),
                productype(),
                phonenumber(),
                buttonregister(),
                goout1(),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget showname() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 0.h),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Hello Welcom",
                  style: TextStyle(
                      fontFamily: "newbodyfont",
                      fontSize: 45,
                      color: Colors.purple)),
              Text(FirebaseAuth.instance.currentUser!.uid!,
                  style: TextStyle(
                      fontFamily: "newbodyfont",
                      fontSize: 35,
                      color: Colors.purple)),
              Text(FirebaseAuth.instance.currentUser!.displayName!,
                  style: TextStyle(
                      fontFamily: "newbodyfont",
                      fontSize: 30,
                      color: Colors.purple)),
            ]));
  }

  Widget namestore() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 4.h),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: "Namestore",
          hintStyle: TextStyle(fontFamily: "newbodyfont", fontSize: 15.sp),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: HexColor('#39474F'), width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.yellow.shade800, width: 2),
          ),
        ),
        controller: namestoreString,
        // ignore: body_might_complete_normally_nullable
        validator: (input) {
          if (input!.length < 1) {
            return "Please enter Namestore";
          }
        },
      ),
    );
  }

  Widget productype() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 4.h),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: "Productype",
          hintStyle: TextStyle(fontFamily: "newbodyfont", fontSize: 15.sp),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: HexColor('#39474F'), width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.yellow.shade800, width: 2),
          ),
        ),
        controller: productypString,
        // ignore: body_might_complete_normally_nullable
        validator: (input) {
          if (input!.length < 1) {
            return "Please enter Productype";
          }
        },
      ),
    );
  }

  Widget phonenumber() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 4.h),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: "Phonenumber",
          hintStyle: TextStyle(fontFamily: "newbodyfont", fontSize: 15.sp),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: HexColor('#39474F'), width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.yellow.shade800, width: 2),
          ),
        ),
        controller: phonenumberSting,
        // ignore: body_might_complete_normally_nullable
        validator: (input) {
          if (input!.length < 1) {
            return "Please enter Productype";
          }
        },
      ),
    );
  }

  Widget buttonregister() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 10.h),
        // ignore: deprecated_member_use
        child: TextButton(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(ColorConstants.buttoncolor)),
          onPressed: doLogin,
          child: Center(
            child: Text(
              "Register",
              style: TextStyle(
                  fontSize: 25.0.sp,
                  color: Colors.white,
                  fontFamily: 'newbodyfont'),
            ),
          ),
        ));
  }

  Widget goout1() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 20.h),
      // ignore: deprecated_member_use
      child: TextButton(
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(ColorConstants.buttoncolor)),
        onPressed: () {
          signOut();
        },
        child: Center(
          child: Text(
            "Logout",
            style: TextStyle(
                fontSize: 25.0.sp,
                color: Colors.white,
                fontFamily: 'newbodyfont'),
          ),
        ),
      ),
    );
  }

  Future getnewuser() async {
    String url = "http://185.78.165.189:3000/nodejsapi/getnewuser";

    http.Response response = await http.get(Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=utf-8'});
    var jsonRes = await json.decode(response.body);

    String text = jsonRes[0]["codestore"];
    String txt = text.substring(1);
    ttt = int.parse(txt);

    setState(() {
      ttt = ttt + 1;

      s = ttt.toString();
      codestore = "A" + ttt.toRadixString(16);
    });
  }

  signOut() {
    _googleSignIn.signOut().then((value) {
      setState(() {});
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => (login()),
        ),
      );
    });
  }

  Future doLogin() async {
    getnewuser();
    if (_formkey.currentState!.validate()) {
      try {
        String url = "http://185.78.165.189:3000/nodejsapi/createuserwithgg";
        var body = {
          "username": FirebaseAuth.instance.currentUser!.email,
          "uid": FirebaseAuth.instance.currentUser!.uid,
          "name": FirebaseAuth.instance.currentUser!.displayName,
          "codestore": codestore,
          "namestore": namestoreString.text.trim(),
          "producttype": productypString.text.trim(),
          "position": "DEALER",
          "phonenumbers": phonenumberSting.text.trim(),
          "datecreate":
              DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
          "status": 1,
        };

        http.Response response = await http.post(Uri.parse(url),
            headers: {'Content-Type': 'application/json; charset=utf-8'},
            body: JsonEncoder().convert(body));

        print(body);

        // if (response.statusCode == 200) {
        //   var jsonRes = json.decode(response.body);
        //   if (jsonRes["success"] == 1) {
        //     SharedPreferences preferences =
        //         await SharedPreferences.getInstance();
        //     preferences.setInt("userid", jsonRes["results"]["userid"]);

        //     List<String> stringpreferences1 = [
        //       jsonRes["results"]["codestore"],
        //       jsonRes["results"]["position"],
        //     ];

        //     SharedPreferences preferences1 =
        //         await SharedPreferences.getInstance();
        //     preferences1.setStringList("codestore", stringpreferences1);

        //     Navigator.of(context)
        //         .pushReplacement(MaterialPageRoute(builder: (context) {
        //       return MyApp();
        //     }));
        //   } else {
        //     return showDialog(
        //         context: context,
        //         builder: (_) => new AlertDialog(
        //               content: new Text("Email or password is not correct"),
        //               actions: <Widget>[
        //                 TextButton(
        //                   child: Text('OK'),
        //                   onPressed: () {
        //                     Navigator.of(context).pop();
        //                   },
        //                 )
        //               ],
        //             ));
        //   }
        // } else {
        //   print("Server error");
        // }
      } catch (error) {
        print(error);
      }
    }
  }
}
