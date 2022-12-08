import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'classapi/class.dart';
import 'main.dart';
import 'package:sizer/sizer.dart';

class login extends StatefulWidget {
  login({Key? key}) : super(key: key);

  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController usernameString = TextEditingController();
  TextEditingController passwordString = TextEditingController();
  int? status;
  int? status2;
  @override
  void initState() {
    super.initState();
  }

  // Future loginauto() async {
  //   SharedPreferences preferences1 = await SharedPreferences.getInstance();
  //   status = preferences1.getInt("status");
  // }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        backgroundColor: ColorConstants.backgroundbody,
        appBar: AppBar(
          toolbarHeight: 10.h,
          title: Text(
            "SENTOR",
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
                usernametext(),
                passwordtext(),
                buttonlogin(),
              ],
            ),
          ),
        ),
      );
    });
  }

  ///for usename tab
  Widget usernametext() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 4.h),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: "Username",
          hintStyle: TextStyle(fontFamily: "newbodyfont", fontSize: 15.sp),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: HexColor('#39474F'), width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.yellow.shade800, width: 2),
          ),
        ),
        controller: usernameString,
        validator: (input) {
          if (input!.length < 1) {
            return "Please enter Username";
          }
        },
      ),
    );
  }

  Widget passwordtext() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.h),
      child: TextFormField(
        decoration: InputDecoration(
          filled: false,
          hintText: "Password",
          hintStyle: TextStyle(fontFamily: "newbodyfont", fontSize: 15.sp),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: HexColor('#39474F'), width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.yellow.shade800, width: 2),
          ),
        ),
        obscureText: true,
        controller: passwordString,
        validator: (input) {
          if (input!.length < 1) {
            return "Please enter password";
          }
        },
      ),
    );
  }

  Widget buttonlogin() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.h),
      // ignore: deprecated_member_use
      child: FlatButton(
        height: 60,
        color: ColorConstants.buttoncolor,
        onPressed: doLogin,
        child: Center(
          child: Text(
            "Sign in",
            style: TextStyle(
                fontSize: 25.0.sp,
                color: Colors.black,
                fontFamily: 'newbodyfont'),
          ),
        ),
      ),
    );
  }

  Future doLogin() async {
    if (_formkey.currentState!.validate()) {
      try {
        String url = "http://185.78.165.189:3000/nodejsapi/login";

        var body = {
          "username": usernameString.text.trim(),
          "password": passwordString.text.trim()
        };

        http.Response response = await http.post(Uri.parse(url),
            headers: {'Content-Type': 'application/json; charset=utf-8'},
            body: JsonEncoder().convert(body));

        if (response.statusCode == 200) {
          var jsonRes = json.decode(response.body);
          if (jsonRes["success"] == 1) {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.setInt("userid", jsonRes["results"]["userid"]);

            List<String> stringpreferences1 = [
              jsonRes["results"]["codestore"],
              jsonRes["results"]["position"],
            ];

            SharedPreferences preferences1 =
                await SharedPreferences.getInstance();
            preferences1.setStringList("codestore", stringpreferences1);

            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (context) {
              return MyApp();
            }));
          } else {
            return showDialog(
                context: context,
                builder: (_) => new AlertDialog(
                      content: new Text("Email or password is not correct"),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ));
          }
        } else {
          print("Server error");
        }
      } catch (error) {
        print(error);
      }
    }
  }
}
