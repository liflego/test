import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gallery_saver/files.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sigma_space/classapi/class.dart';
import 'package:sigma_space/login.dart';
import 'package:sigma_space/main.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class choose extends StatefulWidget {
  choose({Key? key}) : super(key: key);

  @override
  _chooseState createState() => _chooseState();
}

class _chooseState extends State<choose> {
  List<String> strintpre = [];
  late List<String> getuser;
  String namestore = "";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        backgroundColor: ColorConstants.backgroundbody,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          toolbarHeight: 10.h,
          title: Text(
            "SIGB",
            style: TextStyle(fontSize: 30.0.sp, fontFamily: 'newtitlefont'),
          ),
          backgroundColor: ColorConstants.appbarcolor,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 100.sp),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height / 10,
                child: TextButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            ColorConstants.buttoncolor)),
                    onPressed: () async {
                      SharedPreferences preferences1 =
                          await SharedPreferences.getInstance();
                      getuser = preferences1.getStringList("userid")!;

                      if (getuser[2] == "null") {
                        print("gotocreatecompanypage");
                      } else {
                        print("gotomain");
                      }
                    },
                    child: Text(
                      "SELLER",
                      style: TextConstants.textstyleforheader,
                    )),
              ),
              SizedBox(height: 20.sp),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height / 10,
                child: TextButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            ColorConstants.buttoncolor)),
                    onPressed: () async {
                      SharedPreferences preferences1 =
                          await SharedPreferences.getInstance();
                      getuser = preferences1.getStringList("userid")!;
                    },
                    child: Text(
                      "BUYER",
                      style: TextConstants.textstyleforheader,
                    )),
              ),
              logoutbt()
            ],
          ),
        ),
      );
    });
  }

  Widget logoutbt() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 1.0.h, vertical: 40.0.w),
      child: TextButton(
        onPressed: () async {
          SharedPreferences preferences1 =
              await SharedPreferences.getInstance();
          getuser = preferences1.getStringList("userid")!;
          String url2 =
              "http://185.78.165.189:3000/pythonapi/updateloginstatus";

          var body2 = {
            "loginstatus": "0",
            "username": getuser[1].toString(),
          };

          // ignore: unused_local_variable
          http.Response response2 = await http.patch(Uri.parse(url2),
              headers: {'Content-Type': 'application/json; charset=utf-8'},
              body: JsonEncoder().convert(body2));
          getuser.clear();

          preferences1.setStringList("userid", getuser);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => (login()),
            ),
          );
        },
        child: Text(
          "LOG OUT !",
          style: TextStyle(
              fontSize: 18.sp,
              fontFamily: 'newbodyfont',
              color: Colors.blue[400]),
        ),
      ),
    );
  }
  // Future getuserinfo() async {
  //   SharedPreferences preferences1 = await SharedPreferences.getInstance();
  //   getuser = preferences1.getStringList("userid")!;
  // }
}
