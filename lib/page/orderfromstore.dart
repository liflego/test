import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sigma_space/login.dart';
import 'package:sigma_space/main.dart';
import 'package:sigma_space/page/suborders/orderforadminedit.dart';
import 'package:sigma_space/page/suborders/orderforedit.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../classapi/class.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class orderfromstore extends StatefulWidget {
  orderfromstore({Key? key}) : super(key: key);

  @override
  _orderfromstoreState createState() => _orderfromstoreState();
}

class _orderfromstoreState extends State<orderfromstore> {
  final _formkey = GlobalKey<FormState>();
  List<String>? stringpreferences1;
  List<Getallorders> allorders = [];
  List<Getallorders> allordersfordisplay = [];
  TextEditingController companyString = TextEditingController();
  TextEditingController trackString = TextEditingController();
  String namestore = "";
  String auth = "";
  @override
  void initState() {
    fectalldata().then((value) {
      if (mounted)
        setState(() {
          allorders.addAll(value);
          allordersfordisplay = allorders;
        });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return SafeArea(
        top: false,
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading:
                  stringpreferences1?[1] == "ADMIN" ? true : false,
              backgroundColor: ColorConstants.appbarcolor,
              toolbarHeight: 7.h,
              title: Text(
                "ORDER",
                style: TextConstants.appbartextsyle,
              ),
            ),
            backgroundColor: ColorConstants.backgroundbody,
            body: Form(
              key: _formkey,
              child: ListView.builder(
                itemCount: allordersfordisplay.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Slidable(
                          endActionPane: stringpreferences1?[1] == "ADMIN" &&
                                  allordersfordisplay[index].price != null
                              // ignore: prefer_const_constructors
                              ? ActionPane(
                                  motion: ScrollMotion(),
                                  // ignore: prefer_const_literals_to_create_immutables
                                  children: [
                                    Container(
                                      color: Colors.green,
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      height:
                                          MediaQuery.of(context).size.height,
                                      child: OutlinedButton(
                                        onPressed: () {
                                          inputnumber(index);
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.fire_truck,
                                              color: Colors.white,
                                              size: 22.sp,
                                            ),
                                            Text(
                                              "ADD TRACK",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'newbodyfont',
                                                  fontSize: 15.sp),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : ActionPane(
                                  motion: ScrollMotion(),
                                  children: [
                                    Container(
                                      color: Colors.red,
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      height:
                                          MediaQuery.of(context).size.height,
                                      child: OutlinedButton(
                                        onPressed: () {
                                          cancelorder(index);
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.cancel,
                                              color: Colors.white,
                                              size: 22.sp,
                                            ),
                                            Text(
                                              "Cancel",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'newbodyfont',
                                                  fontSize: 15.sp),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                          // The child of the Slidable is what the user sees when the
                          // component is not dragged.
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                backgroundColor:
                                    allordersfordisplay[index].price != null
                                        ? HexColor("#F6D55C")
                                        : ColorConstants.colorcardorder),
                            onPressed: () {
                              if (stringpreferences1?[1] == "ADMIN") {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (context) {
                                  return orderforadminedit(
                                    ordernumber:
                                        allordersfordisplay[index].ordernumber,
                                    cuscode: allordersfordisplay[index].cuscode,
                                    cusname: allordersfordisplay[index].cusname,
                                    pay: allordersfordisplay[index].pay,
                                    amountlist: allordersfordisplay[index]
                                        .amountlist
                                        .toString(),
                                    date: allordersfordisplay[index]
                                        .date
                                        .substring(5, 25),
                                  );
                                }));
                              } else {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (context) {
                                  return orderforedit(
                                    ordernumber:
                                        allordersfordisplay[index].ordernumber,
                                    cuscode: allordersfordisplay[index].cuscode,
                                    cusname: allordersfordisplay[index].cusname,
                                    pay: allordersfordisplay[index].pay,
                                    amountlist: allordersfordisplay[index]
                                        .amountlist
                                        .toString(),
                                    date: allordersfordisplay[index]
                                        .date
                                        .substring(5, 25),
                                  );
                                }));
                              }
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${allordersfordisplay[index].cusname}",
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: 16.0.sp,
                                          fontFamily: 'newbodyfont',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      allordersfordisplay[index]
                                          .date
                                          .substring(5, 25),
                                      style: TextConstants.textstyle,
                                    ),
                                  ],
                                ),
                                Text(
                                  "คำสั่งซื้อที่ : ${allordersfordisplay[index].ordernumber}",
                                  style: TextConstants.textstyle,
                                ),
                                Text(
                                  "วิธีการชำระ : ${allordersfordisplay[index].pay}",
                                  style: TextConstants.textstyle,
                                ),
                                Text(
                                  "จำนวน ${allordersfordisplay[index].amountlist} รายการ",
                                  style: TextConstants.textstyle,
                                ),
                              ],
                            ),
                          ),
                        )),
                  );
                },
              ),
            ),
            drawer: Drawer(
              backgroundColor: Colors.grey[300],
              child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    child: Column(
                      children: [
                        Text(
                          namestore,
                          style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'newtitlefont'),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: auth == "null"
                                ? TextButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.greenAccent[700]),
                                    ),
                                    child: Text(
                                      "รับการแจ้งเตือนผ่าน LINE",
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.black,
                                          fontFamily: 'newtitlefont'),
                                    ),
                                    onPressed: () {
                                      insertlineuid();
                                      _openline();
                                      setState(() {
                                        auth = "notnull";
                                      });
                                    },
                                  )
                                : TextButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.red[400]),
                                    ),
                                    child: Text(
                                      "ยกเลิกรับการแจ้งเตือนผ่าน LINE",
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.white,
                                          fontFamily: 'newtitlefont'),
                                    ),
                                    onPressed: () {
                                      cancellinenoti();
                                    },
                                  ))),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 400.0, left: 8.0, right: 8.0),
                    child: Center(
                        child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                        ),
                        child: Text(
                          "LOG OUT",
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.black,
                              fontFamily: 'newtitlefont'),
                        ),
                        onPressed: () async {
                          SharedPreferences pagepref =
                              await SharedPreferences.getInstance();
                          pagepref.setInt("pagepre", 0);
                          stringpreferences1!.clear();
                          SharedPreferences preferences1 =
                              await SharedPreferences.getInstance();
                          preferences1.setStringList(
                              "codestore", stringpreferences1!);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => (login()),
                            ),
                          );
                        },
                      ),
                    )),
                  )
                ],
              ),
            )),
      );
    });
  }

  Future addamount() async {
    try {
      String url = "http://185.78.165.189:3000/pythonapi/addamount";
      SharedPreferences preferences1 = await SharedPreferences.getInstance();
      stringpreferences1 = preferences1.getStringList("codestore");
      for (var i = 0; i < 5; i++) {
        var body = {
          "amount": int.parse("1"),
          "codeproduct": "",
          "codestore": stringpreferences1![0],
        };

        http.Response response = await http.patch(Uri.parse(url),
            headers: {'Content-Type': 'application/json; charset=utf-8'},
            body: JsonEncoder().convert(body));
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List<Getallorders>> fectalldata() async {
    SharedPreferences preferences1 = await SharedPreferences.getInstance();
    stringpreferences1 = preferences1.getStringList("codestore");

    namestore = stringpreferences1![3];
    auth = stringpreferences1![4];

    String url = "http://185.78.165.189:3000/pythonapi/getallorders";
    var body = {
      "codestore": stringpreferences1![0],
    };

    http.Response response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: JsonEncoder().convert(body));

    dynamic jsonres = json.decode(response.body);
    List<Getallorders>? _allorders = [];
    List getgrouptype = [];
    for (var u in jsonres) {
      Getallorders data = Getallorders(
          u["MAX(a.cuscode)"],
          u["MAX(a.ordernumber)"],
          u["MAX(a.pay)"],
          u["MAX(a.price)"],
          u["MAX(a.saleconfirm)"],
          u["MAX(b.cusname)"],
          u["countorder"],
          u["date"],
          u["auth"]);

      _allorders.add(data);
      getgrouptype.add(u["type"]);
    }

    return _allorders;
  }

  void inputnumber(index) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: SizedBox(
              height: 200.sp,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  new Text("ADD TRACK"),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          child: Center(
                        child: TextFormField(
                          controller: companyString,
                          validator: (input) {
                            if (input!.length < 1) {
                              return "Please enter Company";
                            }
                          },
                          textAlign: TextAlign.center,
                          autofocus: true,
                          decoration: InputDecoration(hintText: "Company"),
                        ),
                      )),
                      Padding(padding: EdgeInsets.all(10.0)),
                      SizedBox(
                          child: Center(
                        child: TextFormField(
                          controller: trackString,
                          validator: (input) {
                            if (input!.length < 1) {
                              return "Please enter Track number";
                            }
                          },
                          textAlign: TextAlign.center,
                          autofocus: true,
                          decoration: InputDecoration(hintText: "Track number"),
                        ),
                      )),
                      Padding(padding: EdgeInsets.only(top: 30.0)),
                      TextButton(
                          child: Container(
                              width: 18.w,
                              height: 5.h,
                              color: ColorConstants.buttoncolor,
                              child: Center(
                                  child: Text(
                                "DONE",
                                style: TextStyle(color: Colors.white),
                              ))),
                          onPressed: () {
                            insertdelivery(index);
                          }),

                      // ignore: unnecessary_new
                    ],
                  ),
                ],
              ),
            ),
          ));
  void cancelorder(index) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: SizedBox(
            height: 80.sp,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                new Text("Cancel order ?"),
                Padding(padding: EdgeInsets.only(top: 20.0)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        child: Container(
                            width: 18.w,
                            height: 5.h,
                            color: Colors.green,
                            child: Center(
                                child: Text(
                              "Yes",
                              style: TextStyle(color: Colors.white),
                            ))),
                        onPressed: () {
                          deleteorders(index);
                        }),
                    TextButton(
                        child: Container(
                            width: 18.w,
                            height: 5.h,
                            color: Colors.red,
                            child: Center(
                                child: Text(
                              "No",
                              style: TextStyle(color: Colors.white),
                            ))),
                        onPressed: () {
                          Navigator.canPop(context)
                              ? Navigator.pop(context)
                              : null;
                        })
                  ],
                ),
                // ignore: unnecessary_new
              ],
            ),
          ),
        ),
      );

  Future insertdelivery(index) async {
    if (_formkey.currentState!.validate()) {
      try {
        String url = "http://185.78.165.189:3000/pythonapi/insertdelivery";
        if (companyString.text.trim().length < 1 ||
            trackString.text.trim().length < 1) {
          return showDialog(
              context: context,
              builder: (_) => new AlertDialog(
                    content: new Text("Plese enter your info."),
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
        var body = {
          "ordernumber": allordersfordisplay[index].ordernumber,
          "company": companyString.text.trim(),
          "track": trackString.text.trim()
        };

        http.Response response = await http.post(Uri.parse(url),
            headers: {'Content-Type': 'application/json; charset=utf-8'},
            body: JsonEncoder().convert(body));
        if (response.statusCode == 200) {
          companyString.clear();
          trackString.clear();

          return showDialog(
              context: context,
              builder: (_) => new AlertDialog(
                    content: new Text("Message send successfully"),
                    actions: <Widget>[
                      TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          companyString.clear();
                          trackString.clear();
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) {
                            return MyApp();
                          }));
                        },
                      )
                    ],
                  ));
        } else {
          return showDialog(
              context: context,
              builder: (_) => new AlertDialog(
                    content: new Text("Server error"),
                    actions: <Widget>[
                      TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          companyString.clear();
                          trackString.clear();
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) {
                            return MyApp();
                          }));
                        },
                      )
                    ],
                  ));
        }
      } catch (error) {
        print(error);
      }
    }
  }

  Future deleteorders(index) async {
    try {
      String url = "http://185.78.165.189:3000/pythonapi/deleteorders/" +
          allordersfordisplay[index].ordernumber.toString();

      http.Response response = await http.delete(Uri.parse(url),
          headers: {'Content-Type': 'application/json; charset=utf-8'});
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return MyApp();
      }));
    } catch (e) {
      print(e);
    }
  }

  Future insertlineuid() async {
    try {
      String url = "http://185.78.165.189:3000/pythonapi/insertlineuid";

      var body = {
        "userid": stringpreferences1![2],
      };

      http.Response response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json; charset=utf-8'},
          body: JsonEncoder().convert(body));
    } catch (error) {
      print(error);
    }
  }

  Future<void> _openline() async {
    String LineURL = 'https://page.line.me/962ekjzu';
    await canLaunch(LineURL)
        ? await launch(LineURL)
        : throw 'Could not launch $LineURL';
  }

  void cancellinenoti() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: SizedBox(
            height: 80.sp,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                new Text("ยกเลิกการแจ้งเตือนผ่านไลน์ ?"),
                Padding(padding: EdgeInsets.only(top: 20.0)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        child: Container(
                            width: 18.w,
                            height: 5.h,
                            color: Colors.green,
                            child: Center(
                                child: Text(
                              "Yes",
                              style: TextStyle(color: Colors.white),
                            ))),
                        onPressed: () {
                          deletelineuid();
                        }),
                    TextButton(
                        child: Container(
                            width: 18.w,
                            height: 5.h,
                            color: Colors.red,
                            child: Center(
                                child: Text(
                              "No",
                              style: TextStyle(color: Colors.white),
                            ))),
                        onPressed: () {
                          Navigator.canPop(context)
                              ? Navigator.pop(context)
                              : null;
                        })
                  ],
                ),
                // ignore: unnecessary_new
              ],
            ),
          ),
        ),
      );

  Future deletelineuid() async {
    try {
      String url =
          "http://185.78.165.189:3000/pythonapi/deletelineuid/${stringpreferences1![2]}";

      http.Response response = await http.delete(Uri.parse(url),
          headers: {'Content-Type': 'application/json; charset=utf-8'});
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return MyApp();
      }));
    } catch (e) {
      print(e);
    }
  }
}
