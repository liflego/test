import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sigma_space/classapi/class.dart';
import 'package:sigma_space/login.dart';
import 'package:sigma_space/main.dart';
import 'package:sigma_space/page/substock/orderfromsellandcus.dart';
import 'package:sigma_space/page/subupdate/addnewproduct.dart';
import 'package:sigma_space/update.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable, camel_case_types
class checkstock extends StatefulWidget {
  List<String> codeorder = [];
  List<String> nameorder = [];
  List<int> numorder = [];
  List<String> numpercrate = [];
  List<String> productset = [];
  List<int> price = [];

  checkstock(
      {Key? key,
      required this.codeorder,
      required this.nameorder,
      required this.numorder,
      required this.numpercrate,
      required this.productset,
      required this.price})
      : super(key: key);

  @override
  _checkstock createState() => _checkstock();
}

class _checkstock extends State<checkstock> {
  List<Getallproduct> allproduct = [];
  List<Getallproduct> allproductfordisplay = [];
  TextEditingController numbers = TextEditingController();
  List<String> codeorder = [];
  List<String> nameorder = [];
  List<int> numorder = [];
  List<String> numpercrate = [];
  List<String> productset = [];
  List<int> price = [];
  List<String>? stringpreferences1;
  List<String>? stringpreferences2;
  String? _scanBarcode = 'Unknown';
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late int noti = 0;
  late int nums = 1;
  late int newnums = 0;
  late var grouptype = [];
  late var getfavorite = [];
  late List<int> groupamountsort = [];
  late List<int> groupamountreversed = [];
  late List<int> showlistamount = [];
  bool click = false;
  int toggle = 0;
  bool clickfav = false;
  String namestore = "";
  String auth = "";
  bool clickorder = false;
  void getclickorder() async {
    SharedPreferences clickorderprefer = await SharedPreferences.getInstance();
    if (clickorderprefer.getBool("setbool") == true) {
      clickorder = true;
    }
  }

  @override
  void initState() {
    getclickorder();
    click = false;
    // ignore: unnecessary_null_comparison
    if (widget.codeorder == null) {
    } else {
      noti = (widget.codeorder).length;
    }
    getdatafromorderpage();

    fectalldata().then((value) {
      if (mounted) {
        setState(() {
          allproduct.addAll(value);
          allproductfordisplay = allproduct;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return SafeArea(
            top: false,
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading:
                    stringpreferences1?[1] == "SALE" ? true : false,
                toolbarHeight: 7.h,
                title: Text(
                  "STOCK",
                  style: TextStyle(fontFamily: 'newtitlefont', fontSize: 25.sp),
                ),
                actions: [
                  stringpreferences1?[1] == "ADMIN"
                      ? IconButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => addnewproductpage()));
                          },
                          icon: Icon(Icons.add_circle))
                      : SizedBox()
                ],
                leading: clickorder == false
                    ? (stringpreferences1?[1] == "DEALER"
                        ? IconButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: ((context) => MyApp())));
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ))
                        : null)
                    : IconButton(
                        onPressed: () async {
                          setState(() {
                            clickorder = false;
                          });

                          SharedPreferences clickorderprefer =
                              await SharedPreferences.getInstance();

                          clickorderprefer.setBool("setbool", clickorder);
                          SharedPreferences pagepref =
                              await SharedPreferences.getInstance();
                          pagepref.setInt("pagepre", 2);
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => MyApp()));
                        },
                        icon: Icon(Icons.arrow_back)),
                backgroundColor: ColorConstants.appbarcolor,
              ),
              backgroundColor: ColorConstants.backgroundbody,
              body: SingleChildScrollView(
                child: Column(children: [
                  choosetype(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 1.6,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return listItem(index);
                      },
                      itemCount: allproductfordisplay.length,
                    ),
                  ),
                ]),
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
                                        // _openline();
                                        showlineqrcode();
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

                            ////update login status
                            String url2 =
                                "http://185.78.165.189:3000/pythonapi/updateloginstatus";

                            var body2 = {
                              "loginstatus": "0",
                              "username": stringpreferences1![5].toString(),
                            };

                            // ignore: unused_local_variable
                            http.Response response2 = await http.patch(
                                Uri.parse(url2),
                                headers: {
                                  'Content-Type':
                                      'application/json; charset=utf-8'
                                },
                                body: JsonEncoder().convert(body2));
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
              ),
              floatingActionButton: stringpreferences1?[1] == "ADMIN"
                  ? null
                  : FloatingActionButton(
                      onPressed: gotoorder,
                      backgroundColor: ColorConstants.appbarcolor,
                      child: noti != 0
                          ? badges.Badge(
                              badgeColor: Colors.blue,
                              badgeContent: Text(
                                '$noti',
                                style: TextStyle(
                                    fontSize: 12.0.sp,
                                    fontFamily: 'newtitlefont',
                                    color: Colors.red),
                              ),
                              child: Icon(Icons.shopping_cart_outlined),
                            )
                          : Icon(Icons.shopping_cart_outlined),
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget choosetype() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.w, horizontal: 0.h),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1), //color of shadow
              spreadRadius: 5, //spread radius
              blurRadius: 5, // blur radius
              offset: Offset(0, 2), // changes position of shadow
              //first paramerter of offset is left-right
              //second parameter is top to down
            ),
            //you can set more BoxShadow() here
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            serchBar(),
            //choostype
            stringpreferences1?[1] == "ADMIN"
                ? Row(
                    children: [
                      SizedBox(
                        height: 7.0.h,
                        width: MediaQuery.of(context).size.width / 1.15,
                        child: toggle != 0
                            ? SizedBox(
                                width: MediaQuery.of(context).size.width / 4,
                                height: MediaQuery.of(context).size.height,
                                child: Center(
                                    child: toggle == 1
                                        ? Text(
                                            "เรียงลำดับจำนวนจากน้อยไปมาก",
                                            style: TextStyle(
                                                fontSize: 18.sp,
                                                fontFamily: 'newbodyfont',
                                                color: Colors.red),
                                          )
                                        : Text(
                                            "เรียงลำดับจำนวนจากมากไปน้อย",
                                            style: TextStyle(
                                                fontSize: 18.sp,
                                                fontFamily: 'newbodyfont',
                                                color: Colors.red),
                                          )),
                              )
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: grouptype.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return TextButton(
                                      onPressed: () {
                                        setState(() {
                                          allproductfordisplay =
                                              allproduct.where((_allproduct) {
                                            var nameproduct = _allproduct
                                                .alltype
                                                .toLowerCase();
                                            return nameproduct
                                                .contains(grouptype[index]);
                                          }).toList();
                                        });
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                4,
                                        height:
                                            MediaQuery.of(context).size.height,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: HexColor('#39474F'),
                                              width: 1),
                                          color: Colors.grey[50],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Center(
                                            child: Text(
                                              "${grouptype[index]}",
                                              maxLines: 1,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12.0.sp),
                                            ),
                                          ),
                                        ),
                                      ));
                                },
                              ),
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              toggle = toggle + 1;

                              if (toggle == 1) {
                                allproduct.clear();
                                allproductfordisplay.clear();
                                fectalldataasc().then((value) {
                                  setState(() {
                                    allproduct.addAll(value);
                                    allproductfordisplay = allproduct;
                                  });
                                });
                              } else if (toggle == 2) {
                                allproduct.clear();
                                allproductfordisplay.clear();
                                fectalldatadesc().then((value) {
                                  setState(() {
                                    allproduct.addAll(value);
                                    allproductfordisplay = allproduct;
                                  });
                                });
                              } else {
                                toggle = 0;
                              }
                            });
                          },
                          icon: Icon(
                            Icons.sort_outlined,
                            color: Colors.red,
                            size: 25.sp,
                          ))
                    ],
                  )
                ////here for customer
                : SizedBox(
                    height: 7.0.h,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: grouptype.length,
                      itemBuilder: (BuildContext context, int index) {
                        return TextButton(
                            onPressed: () {
                              if (grouptype[index] == "FAVORITE") {
                                setState(() {
                                  grouptype[0] = "หน้าหลัก";
                                  allproductfordisplay =
                                      allproduct.where((_allproduct) {
                                    var nameproduct = _allproduct.fav
                                        .toString()
                                        .toLowerCase();
                                    return nameproduct.contains("1");
                                  }).toList();
                                });
                              } else if (grouptype[index] == "หน้าหลัก") {
                                setState(() {
                                  grouptype[0] = "FAVORITE";
                                  allproductfordisplay = allproduct;
                                });
                              } else {
                                setState(() {
                                  grouptype[0] = "FAVORITE";
                                  allproductfordisplay =
                                      allproduct.where((_allproduct) {
                                    var nameproduct =
                                        _allproduct.alltype.toLowerCase();
                                    return nameproduct
                                        .contains(grouptype[index]);
                                  }).toList();
                                });
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width / 4,
                              height: MediaQuery.of(context).size.height,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: HexColor('#39474F'), width: 1),
                                color: Colors.grey[50],
                              ),
                              child: Center(
                                child: Text(
                                  "${grouptype[index]}",
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 12.0.sp),
                                ),
                              ),
                            ));
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget serchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.w, horizontal: 3.h),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[50],
            border: Border.all(color: HexColor('#39474F'), width: 2),
            borderRadius: BorderRadius.circular(10.0)),
        child: Center(
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Icon(
              Icons.search,
            ),
            SizedBox(
              width: 50.w,
              height: 7.h,
              child: Center(
                child: TextField(
                  showCursor: true,
                  style: TextStyle(fontSize: 15.0.sp),
                  decoration: InputDecoration(
                      hintText: "SEARCH...",
                      hintStyle: TextStyle(
                        color: HexColor('#39474F'),
                      ),
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white))),
                  onChanged: (text) {
                    text = text.toLowerCase();

                    setState(() {
                      allproductfordisplay = allproduct.where((_allproduct) {
                        var nameproduct = _allproduct.nameproduct.toLowerCase();
                        return nameproduct.contains(text);
                      }).toList();
                    });
                  },
                ),
              ),
            ),
            TextButton(
                onPressed: scanbarcode,
                child: Text(
                  "[=]",
                  style: TextStyle(color: Colors.amber, fontSize: 12.sp),
                ))
          ]),
        ),
      ),
    );
  }

  Widget listItem(index) {
    return Card(
      elevation: 2,
      color: ColorConstants.cardcolor,
      child: Slidable(
        endActionPane: stringpreferences1?[1] == "DEALER"
            ? ActionPane(
                motion: ScrollMotion(),

                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  grouptype[0] == "FAVORITE"
                      ? Container(
                          color: Colors.green,
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width / 2.25,
                          child: Center(
                            child: OutlinedButton(
                                onPressed: () {
                                  insertfavorite(index);
                                },
                                child: SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  width:
                                      MediaQuery.of(context).size.width / 2.25,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.favorite,
                                        color: Colors.white,
                                        size: 22.sp,
                                      ),
                                      Text(
                                        "FAVORITE",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'newbodyfont',
                                            fontSize: 15.sp),
                                      )
                                    ],
                                  ),
                                )),
                          ),
                        )
                      : Container(
                          color: Colors.red,
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width / 2.25,
                          child: Center(
                            child: OutlinedButton(
                                onPressed: () {
                                  insertfavorite(index);
                                },
                                child: SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  width:
                                      MediaQuery.of(context).size.width / 2.25,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.cancel,
                                        color: Colors.white,
                                        size: 22.sp,
                                      ),
                                      Text(
                                        "UNFAVORITE",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'newbodyfont',
                                            fontSize: 15.sp),
                                      )
                                    ],
                                  ),
                                )),
                          ),
                        ),
                ],
              )
            : null,
        child: OutlinedButton(
          onPressed: () async {
            if (stringpreferences1?[1] == "ADMIN") {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => updatepage(
                      codeproduct: allproductfordisplay[index].codeproduct,
                      nameproduct: allproductfordisplay[index].nameproduct,
                      type: allproductfordisplay[index].alltype,
                      pdpd: allproductfordisplay[index].productset,
                      score: allproductfordisplay[index].score,
                      amount: allproductfordisplay[index].amount,
                      amountper: allproductfordisplay[index].amountpercrate,
                      price: allproductfordisplay[index].price)));
            } else {
              if (allproductfordisplay[index].amount == 0) {
                return null;
              } else {
                SharedPreferences clickorderprefer =
                    await SharedPreferences.getInstance();
                clickorder = clickorderprefer.getBool("setbool")!;
                if (clickorder == true) {
                  inputnumber(index);
                } else {
                  return null;
                }
              }
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 1.h, vertical: 0.w),
            child: SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Text(
                                allproductfordisplay[index].nameproduct +
                                    "(" +
                                    allproductfordisplay[index].productset +
                                    "ละ" +
                                    "${allproductfordisplay[index].amountpercrate}" +
                                    ")",
                                maxLines: 2,
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'newbodyfont',
                                    color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          //row for image and column
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  allproductfordisplay[index].codeproduct,
                                  style: TextConstants.textstyle,
                                ),
                                Text(
                                  "ประเภท: ${allproductfordisplay[index].alltype}",
                                  style: TextConstants.textstyle,
                                ),
                                allproductfordisplay[index].amount == 0
                                    ? Text(
                                        "จำนวน : ${allproductfordisplay[index].amount}",
                                        style: TextStyle(
                                            fontSize: 18.sp,
                                            fontFamily: 'newbodyfont',
                                            color: Colors.red),
                                      )
                                    : Text(
                                        "จำนวน : ${allproductfordisplay[index].amount}" +
                                            "(${((allproductfordisplay[index].amount) / allproductfordisplay[index].amountpercrate).toInt()}" +
                                            allproductfordisplay[index]
                                                .productset +
                                            ")",
                                        style: TextConstants.textstyle,
                                      ),
                                Text(
                                  "ราคา: ${allproductfordisplay[index].price}",
                                  style: TextConstants.textstyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<List<Getallproduct>> fectalldata() async {
    SharedPreferences preferences1 = await SharedPreferences.getInstance();
    stringpreferences1 = preferences1.getStringList("userid");
    SharedPreferences preferences2 = await SharedPreferences.getInstance();
    stringpreferences2 = preferences2.getStringList("dealercode");

    namestore = stringpreferences1![3];
    auth = stringpreferences1![4];

    String url = "http://185.78.165.189:3000/pythonapi/userid";
    String url1 = "http://185.78.165.189:3000/pythonapi/getproductfordealer";

    List getgrouptype = [];
    List<Getallproduct>? _allproduct = [];
    List getamount = [];

    if (stringpreferences1![1] == "DEALER") {
      var body = {
        "dealercode": stringpreferences1![0],
        "codestore": stringpreferences2?[0]
      };

      getgrouptype.add("FAVORITE");
      http.Response response = await http.post(Uri.parse(url1),
          headers: {'Content-Type': 'application/json; charset=utf-8'},
          body: JsonEncoder().convert(body));

      dynamic jsonres = json.decode(response.body);
      for (var u in jsonres) {
        Getallproduct data = Getallproduct(
            u["codeproduct"],
            u["nameproduct"],
            u["amount"],
            u["amountpercrate"],
            u["productset"],
            u["type"],
            u["score"],
            u["price"],
            u["fav"]);
        _allproduct.add(data);
        getgrouptype.add(u["type"]);
        getamount.add(u["amount"]);
      }
    } else {
      var body = {"userid": stringpreferences1![0]};
      http.Response response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json; charset=utf-8'},
          body: JsonEncoder().convert(body));

      dynamic jsonres = json.decode(response.body);
      for (var u in jsonres) {
        Getallproduct data = Getallproduct(
            u["codeproduct"],
            u["nameproduct"],
            u["amount"],
            u["amountpercrate"],
            u["productset"],
            u["pdtype"],
            u["score"],
            u["price"],
            u["fav"]);
        _allproduct.add(data);
        getgrouptype.add(u["pdtype"]);
        getamount.add(u["amount"]);
      }
    }

    grouptype = LinkedHashSet<String>.from(getgrouptype).toList();

    return _allproduct;
  }

  Future<List<Getallproduct>> fectalldataasc() async {
    SharedPreferences preferences1 = await SharedPreferences.getInstance();
    stringpreferences1 = preferences1.getStringList("codestore");

    String url = "http://185.78.165.189:3000/pythonapi/codestore/sortamountasc";
    List<Getallproduct>? _allproduct = [];

    var body = {"codestore": stringpreferences1![0]};
    http.Response response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: JsonEncoder().convert(body));

    dynamic jsonres = json.decode(response.body);
    for (var u in jsonres) {
      Getallproduct data = Getallproduct(
          u["codeproduct"],
          u["nameproduct"],
          u["amount"],
          u["amountpercrate"],
          u["productset"],
          u["type"],
          u["score"],
          u["price"],
          u["fav"]);
      _allproduct.add(data);
    }

    return _allproduct;
  }

  Future<List<Getallproduct>> fectalldatadesc() async {
    SharedPreferences preferences1 = await SharedPreferences.getInstance();
    stringpreferences1 = preferences1.getStringList("codestore");

    String url =
        "http://185.78.165.189:3000/pythonapi/codestore/sortamountdesc";
    List<Getallproduct>? _allproduct = [];

    var body = {"codestore": stringpreferences1![0]};
    http.Response response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: JsonEncoder().convert(body));

    dynamic jsonres = json.decode(response.body);
    for (var u in jsonres) {
      Getallproduct data = Getallproduct(
          u["codeproduct"],
          u["nameproduct"],
          u["amount"],
          u["amountpercrate"],
          u["productset"],
          u["type"],
          u["score"],
          u["price"],
          u["fav"]);
      _allproduct.add(data);
    }

    return _allproduct;
  }

  Future<void> scanbarcode() async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      setState(() {
        _scanBarcode = barcodeScanRes;

        allproductfordisplay = allproduct.where((_allproduct) {
          var nameproduct = _allproduct.codeproduct.toLowerCase();
          return nameproduct.contains(_scanBarcode!);
        }).toList();
      });
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  Future inputnumber(index) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: SizedBox(
              width: 15.w,
              height: 15.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  new Text("ใส่จำนวน"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          height: 5.h,
                          width: 20.w,
                          child: Center(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              onFieldSubmitted: (String value) {
                                setState(() {
                                  numbers.text = value;
                                  print('First text field: $value');
                                });
                              },
                              autofocus: true,
                              decoration:
                                  InputDecoration(hintText: "จำนวนต่อตัว"),
                              controller: numbers,
                            ),
                          )),
                      // ignore: unnecessary_new
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              Padding(padding: EdgeInsets.all(10.0)),
              TextButton(
                  onPressed: () => setState(() {
                        numbers.clear();
                        Navigator.pop(context);
                      }),
                  child: Container(
                      width: 18.w,
                      height: 5.h,
                      color: ColorConstants.buttoncolor,
                      child: Center(
                          child: Text(
                        "CANCEL",
                        style: TextStyle(color: Colors.white),
                      )))),
              TextButton(
                  onPressed: () => setState(() {
                        noti = noti + 1;

                        codeorder.add(allproductfordisplay[index].codeproduct);
                        nameorder.add(allproductfordisplay[index].nameproduct);
                        numorder.add(int.parse(numbers.text.toString()));
                        numpercrate.add(allproductfordisplay[index]
                            .amountpercrate
                            .toString());
                        productset.add(allproductfordisplay[index].productset);
                        price.add(allproductfordisplay[index].price);

                        numbers.clear();
                        Navigator.pop(context);
                      }),
                  child: Container(
                      width: 15.w,
                      height: 5.h,
                      color: ColorConstants.buttoncolor,
                      child: Center(
                          child: Text(
                        "DONE",
                        style: TextStyle(color: Colors.white),
                      ))))
            ],
          ));

  Future gotoorder() async {
    SharedPreferences listdealerdata = await SharedPreferences.getInstance();

    List<String> dealerdata = listdealerdata.getStringList("dealerdata")!;

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => orderfromsellandcus(
            codeorder: codeorder,
            nameorder: nameorder,
            numorder: numorder,
            numpercrate: numpercrate,
            productset: productset,
            price: price,
            position: stringpreferences1![1],
            namestore: dealerdata[1].toString())));
  }

  Future getdatafromorderpage() async {
    if (widget.codeorder != null) {
      codeorder = widget.codeorder;
      nameorder = widget.nameorder;
      numorder = widget.numorder;
      numpercrate = widget.numpercrate;
      productset = widget.productset;
      price = widget.price;
    } else {}
  }

  Future insertfavorite(index) async {
    SharedPreferences preferences2 = await SharedPreferences.getInstance();
    stringpreferences2 = preferences2.getStringList("dealercode");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    stringpreferences1 = preferences.getStringList("codestore");
    try {
      String url = "http://185.78.165.189:3000/pythonapi/insertfavorite";
      var body = {
        "codeproduct": allproductfordisplay[index].codeproduct.toString(),
        "codestore": stringpreferences2![0].toString(),
        "dealercode": stringpreferences1![0]
      };

      http.Response response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json; charset=utf-8'},
          body: JsonEncoder().convert(body));

      if (response.statusCode == 200) {
        return showDialog(
            context: context,
            builder: (_) => new AlertDialog(
                  content: new Text("Success"),
                  actions: <Widget>[
                    TextButton(
                      child: Text('DONE'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ));
      } else {
        print("server error");
      }
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

  void showlineqrcode() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 2.5,
              child: Column(
                children: [
                  Image.asset("assets/images/lineqrcode.png"),
                  Center(
                    child: Text(
                      "ADD LINE",
                      style: TextConstants.textstyleforheader,
                    ),
                  )
                ],
              ),
            ),
          ));

  void cancellinenoti() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: SizedBox(
            height: 120.sp,
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
                          Navigator.canPop(context);
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
                          Navigator.canPop(context);
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

  Future getcusdata() async {
    SharedPreferences listdealerdata = await SharedPreferences.getInstance();
    setState(() {
      List<String> dealerdata = listdealerdata.getStringList("dealerdata")!;
    });
  }
}
