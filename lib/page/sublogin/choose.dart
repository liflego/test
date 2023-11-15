// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
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
  final _formkey = GlobalKey<FormState>();
  late List<String> getuser;
  TextEditingController namestore = TextEditingController();
  TextEditingController producttype = TextEditingController();
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
        body: Form(
          key: _formkey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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

                        if (getuser[4] == "null") {
                          return showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    content: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                2.sp,
                                        child: Column(
                                          children: [
                                            Text(
                                              "Input your info.",
                                              style: TextConstants
                                                  .textstyleforheader,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 15.0),
                                              child: TextFormField(
                                                controller: namestore,
                                                style: TextConstants
                                                    .textstyleforhistory,
                                                decoration: InputDecoration(
                                                  hintText:
                                                      "ชื่อบริษัทหรือชื่อร้านค้า",
                                                  hintStyle: TextStyle(
                                                      fontFamily: "newbodyfont",
                                                      fontSize: 15.sp,
                                                      color: Colors.black45),
                                                  enabledBorder:
                                                      const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.grey,
                                                        width: 2),
                                                  ),
                                                  focusedBorder:
                                                      const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.grey,
                                                        width: 2),
                                                  ),
                                                ),
                                                validator: (input) {
                                                  if (input!.isEmpty) {
                                                    return "ลืมใส่ชื่อบริษัทหรือร้านค้าหรือเปล่า";
                                                  }
                                                },
                                              ),
                                            ),
                                            TextFormField(
                                              controller: producttype,
                                              style: TextConstants
                                                  .textstyleforhistory,
                                              decoration: InputDecoration(
                                                hintText:
                                                    "ประเภทสินค้าหรือบริการ",
                                                hintStyle: TextStyle(
                                                    fontFamily: "newbodyfont",
                                                    fontSize: 15.sp,
                                                    color: Colors.black45),
                                                enabledBorder:
                                                    const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey,
                                                      width: 2),
                                                ),
                                                focusedBorder:
                                                    const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey,
                                                      width: 2),
                                                ),
                                              ),
                                              validator: (input) {
                                                if (input!.isEmpty) {
                                                  return "ลืมใส่ประเภทสินค้าหรือเปล่า";
                                                }
                                              },
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 15.0),
                                              child: Text("สำหรับพนักงาน",
                                                  style: TextConstants
                                                      .textstyleforheader),
                                            ),
                                            IconButton(
                                                onPressed: () {},
                                                icon: const Icon(
                                                  Icons.qr_code,
                                                  size: 35,
                                                ))
                                          ],
                                        )),
                                    contentPadding: const EdgeInsets.all(20),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: updatesuserstore,
                                        child: const Text('DONE'),
                                      )
                                    ],
                                  ));
                        } else {
                          print("ss");
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

  Future updatesuserstore() async {
    if (_formkey.currentState!.validate()) {
      try {
        String url2 = "http://185.78.165.189:3000/pythonapi/updateuserstore";
        SharedPreferences preferences1 = await SharedPreferences.getInstance();
        getuser = preferences1.getStringList("userid")!;
        var body2 = {
          "userid": getuser[0].toString(),
          "namestore": namestore.text.trim(),
          "producttype": producttype.text.trim(),
          "position": "owner",
        };

        http.Response response2 = await http.patch(Uri.parse(url2),
            headers: {'Content-Type': 'application/json; charset=utf-8'},
            body: const JsonEncoder().convert(body2));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyApp()),
        );
      } catch (error) {
        return showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  content: const Text("ไม่สามารถลงทะเบียนได้ กรุณาลองอีกครั้ง"),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('DONE'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ));
      }
    }
  }
}
