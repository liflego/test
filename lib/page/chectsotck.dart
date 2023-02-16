import 'dart:async';
import 'dart:collection';
import 'dart:convert';
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

class checkstock extends StatefulWidget {
  List<String> codeorder = [];
  List<String> nameorder = [];
  List<String> numorder = [];
  List<String> numpercrate = [];
  List<String> productset = [];

  checkstock({
    Key? key,
    required this.codeorder,
    required this.nameorder,
    required this.numorder,
    required this.numpercrate,
    required this.productset,
  }) : super(key: key);

  @override
  _checkstock createState() => _checkstock();
}

class _checkstock extends State<checkstock> {
  List<Getallproduct> allproduct = [];
  List<Getallproduct> allproductfordisplay = [];
  TextEditingController numbers = TextEditingController();
  List<String> codeorder = [];
  List<String> nameorder = [];
  List<String> numorder = [];
  List<String> numpercrate = [];
  List<String> productset = [];
  List<String>? stringpreferences1;
  String? stringpreferences2;
  String? _scanBarcode = 'Unknown';
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late int noti = 0;
  late int nums = 1;
  late int newnums = 0;
  late var grouptype = [];
  late var getfavorite = [];
  late var groupamountsort = [];
  late var groupamountreversed = [];
  late var showlistamount = [];
  bool click = false;
  int toggle = 0;
  bool clickfav = false;
  String namestore = "";
  @override
  void initState() {
    click = false;
    if (widget.codeorder == null) {
    } else {
      noti = (widget.codeorder).length;
    }
    getdatafromorderpage();

    fectalldata().then((value) {
      setState(() {
        allproduct.addAll(value);
        allproductfordisplay = allproduct;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return SafeArea(
          top: false,
          child: Scaffold(
            appBar: AppBar(
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
                    : PopupMenuButton(
                        icon: Icon(Icons.notifications_none_outlined),
                        color: Colors.grey[50],
                        itemBuilder: (context) => [
                          PopupMenuItem<int>(
                            value: 0,
                            child: Text(
                              "Setting",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          PopupMenuItem<int>(
                              value: 1,
                              child: Text(
                                "Privacy Policy page",
                                style: TextStyle(color: Colors.white),
                              )),
                        ],
                        onSelected: (item) => {print(item)},
                      )
              ],
              leading: stringpreferences1?[1] == "DEALER"
                  ? IconButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: ((context) => MyApp())));
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ))
                  : null,
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
            floatingActionButton: stringpreferences1?[1] == "ADMIN"
                ? null
                : FloatingActionButton(
                    onPressed: gotoorder,
                    backgroundColor: ColorConstants.appbarcolor,
                    child: noti != 0
                        ? Badge(
                            backgroundColor: Colors.white,
                            label: Text(
                              '$noti',
                              style: TextStyle(
                                  fontSize: 12.0.sp,
                                  fontFamily: 'newtitlefont',
                                  color: Colors.red),
                            ),
                            child: Icon(Icons.list),
                          )
                        : Icon(Icons.list),
                  ),
            drawer: stringpreferences1?[1] != "ADMIN"
                ? Drawer(
                    backgroundColor: Colors.green[700],
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
                          child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    width: 0, color: Colors.grey.shade800),
                                color: Colors.grey[50],
                              ),
                              child: Center(
                                child: TextButton(
                                  child: Text(
                                    "LOG OUT",
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.black,
                                        fontFamily: 'newtitlefont'),
                                  ),
                                  onPressed: () async {
                                    stringpreferences1![0] = "";
                                    SharedPreferences preferences1 =
                                        await SharedPreferences.getInstance();
                                    preferences1.setStringList(
                                        "codestore", stringpreferences1!);
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) => login()));
                                  },
                                ),
                              )),
                        )
                      ],
                    ),
                  )
                : null,
          ),
        );
      },
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
                                        child: Center(
                                          child: Text(
                                            "${grouptype[index]}",
                                            maxLines: 1,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12.0.sp),
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
                                showlistamount = groupamountsort;
                              } else if (toggle == 2) {
                                showlistamount = groupamountreversed;
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
    List<int> amountsort = [];
    List<int> getamountpercrate = [];
    List<String> getcodeproduct = [];
    List<String> getnameproduct = [];
    List<String> gettype = [];
    List<String> getproductset = [];
    List<String> getprice = [];
    List<int> getscore = [];

    Iterable<Getallproduct> visiamount = allproductfordisplay.where((am) =>
        am.amount.toString().contains(showlistamount[index].toString()));
    visiamount.forEach((am) => amountsort.add(am.amount));

    Iterable<Getallproduct> visipercrate = allproductfordisplay.where((ampc) =>
        ampc.amount.toString().contains(showlistamount[index].toString()));
    visiamount.forEach((ampc) => getamountpercrate.add(ampc.amountpercrate));

    Iterable<Getallproduct> visicode = allproductfordisplay.where((code) =>
        code.amount.toString().contains(showlistamount[index].toString()));
    visicode.forEach((code) => getcodeproduct.add(code.codeproduct));

    Iterable<Getallproduct> visiname = allproductfordisplay.where((name) =>
        name.amount.toString().contains(showlistamount[index].toString()));
    visiname.forEach((name) => getnameproduct.add(name.nameproduct));

    Iterable<Getallproduct> visitype = allproductfordisplay.where((type) =>
        type.amount.toString().contains(showlistamount[index].toString()));
    visiname.forEach((type) => gettype.add(type.nameproduct));

    Iterable<Getallproduct> visipdset = allproductfordisplay.where((pdset) =>
        pdset.amount.toString().contains(showlistamount[index].toString()));
    visiname.forEach((pdset) => getproductset.add(pdset.productset));

    Iterable<Getallproduct> visiprice = allproductfordisplay.where((price) =>
        price.amount.toString().contains(showlistamount[index].toString()));
    visiname.forEach((price) => getprice.add(price.price.toString()));

    Iterable<Getallproduct> visiscore = allproductfordisplay.where((score) =>
        score.amount.toString().contains(showlistamount[index].toString()));
    visiscore.forEach((score) => getscore.add(score.score));

    return Card(
      elevation: 2,
      color: toggle == 0
          ? allproductfordisplay[index].score == 4
              ? ColorConstants.sc4
              : allproductfordisplay[index].score == 3
                  ? ColorConstants.sc3
                  : allproductfordisplay[index].score == 2
                      ? ColorConstants.sc2
                      : Colors.grey[50]
          : getscore[0] == 4
              ? ColorConstants.sc4
              : getscore[0] == 3
                  ? ColorConstants.sc3
                  : getscore[0] == 2
                      ? ColorConstants.sc2
                      : Colors.grey[50],
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
          onPressed: () {
            if (stringpreferences1?[1] == "ADMIN") {
              if (toggle == 0) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => updatepage(
                          codeproduct: allproductfordisplay[index].codeproduct,
                          nameproduct: allproductfordisplay[index].nameproduct,
                          type: allproductfordisplay[index].alltype,
                          pdpd: allproductfordisplay[index].productset,
                          score: allproductfordisplay[index].score,
                          amount: allproductfordisplay[index].amount,
                          amountper: allproductfordisplay[index].amountpercrate,
                          price: allproductfordisplay[index].price,
                          pathimg: allproductfordisplay[index].pathimg,
                          nameimg: allproductfordisplay[index].nameimg,
                        )));
              } else {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => updatepage(
                          codeproduct: getcodeproduct[0],
                          nameproduct: getnameproduct[0],
                          type: gettype[0],
                          pdpd: getproductset[0],
                          score: getscore[0],
                          amount: amountsort[0],
                          amountper: getamountpercrate[0],
                          price: allproductfordisplay[0].price,
                          pathimg: allproductfordisplay[index].pathimg,
                          nameimg: allproductfordisplay[0].nameimg,
                        )));
              }
            } else {
              inputnumber(index);
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 1.h, vertical: 0.w),
            child: SingleChildScrollView(
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
                              toggle != 0
                                  ? Text(
                                      getnameproduct[0] +
                                          "(" +
                                          getproductset[0] +
                                          "ละ" +
                                          "${getamountpercrate[0]}" +
                                          ")",
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'newbodyfont',
                                          color: Colors.black),
                                    )
                                  : Text(
                                      allproductfordisplay[index].nameproduct +
                                          "(" +
                                          allproductfordisplay[index]
                                              .productset +
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
                            ],
                          ),
                          toggle != 0
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      getcodeproduct[0],
                                      style: TextConstants.textstyle,
                                    ),
                                    Text(
                                      "ประเภท: ${gettype[0]}",
                                      style: TextConstants.textstyle,
                                    ),
                                    amountsort[0] == 0
                                        ? Text(
                                            "จำนวน : ${amountsort[0]}",
                                            style: TextStyle(
                                                fontSize: 18.sp,
                                                fontFamily: 'newbodyfont',
                                                color: Colors.red),
                                          )
                                        : Text(
                                            "จำนวน : ${amountsort[0]}" +
                                                "(${(amountsort[0] / getamountpercrate[0]).toInt()}" +
                                                getproductset[0] +
                                                ")",
                                            style: TextConstants.textstyle,
                                          ),
                                    Text(
                                      "ราคา: ${getprice[0]}",
                                      style: TextConstants.textstyle,
                                    ),
                                  ],
                                )
                              : Row(
                                  //row for image and column
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          allproductfordisplay[index]
                                              .codeproduct,
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
                                    allproductfordisplay[index].nameimg ==
                                                null ||
                                            allproductfordisplay[index]
                                                    .nameimg ==
                                                "null"
                                        ? SizedBox()
                                        : Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              // add border
                                              border: Border.all(
                                                  width: 2,
                                                  color: Colors.white),
                                            ),
                                            height: 90.sp,
                                            width: 90.sp,
                                            child: Image.network(
                                                "http://185.78.165.189:8000/img/${allproductfordisplay[index].pathimg}/${allproductfordisplay[index].nameimg}"),
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
      ),
    );
  }

  Future<List<Getallproduct>> fectalldata() async {
    SharedPreferences preferences1 = await SharedPreferences.getInstance();
    stringpreferences1 = preferences1.getStringList("codestore");
    SharedPreferences preferences2 = await SharedPreferences.getInstance();
    stringpreferences2 = preferences2.getString("dealercode");
    setState(() {
      namestore = stringpreferences1![3];
    });

    String url = "http://185.78.165.189:3000/pythonapi/codestore";
    String url1 = "http://185.78.165.189:3000/pythonapi/getproductfordealer";

    List getgrouptype = [];
    List<Getallproduct>? _allproduct = [];
    List getamount = [];

    if (stringpreferences1![1] == "DEALER") {
      var body = {
        "dealercode": stringpreferences1![0],
        "codestore": stringpreferences2!
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
            u["fav"],
            u["pathimg"],
            u["nameimg"]);
        _allproduct.add(data);
        getgrouptype.add(u["type"]);
        getamount.add(u["amount"]);
      }
    } else {
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
            u["fav"],
            u["pathimg"],
            u["nameimg"]);
        _allproduct.add(data);
        getgrouptype.add(u["type"]);
        getamount.add(u["amount"]);
      }
    }

    grouptype = LinkedHashSet<String>.from(getgrouptype).toList();

    for (int i = 0; i < _allproduct.length; i++) {
      groupamountsort.add(0);
      groupamountreversed.add(0);
      showlistamount.add(0);
    }
    for (int i = 0; i < _allproduct.length; i++) {
      groupamountsort[i] = getamount[i];
    }
    groupamountsort.sort();
    groupamountsort.toList();

    groupamountreversed = groupamountsort.reversed.toList();

    return _allproduct;
  }

  Future<void> scanbarcode() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
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
                        numorder.add(numbers.text);
                        numpercrate.add(allproductfordisplay[index]
                            .amountpercrate
                            .toString());
                        productset.add(allproductfordisplay[index].productset);

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
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => orderfromsellandcus(
              codeorder: codeorder,
              nameorder: nameorder,
              numorder: numorder,
              numpercrate: numpercrate,
              productset: productset,
              position: stringpreferences1![1],
            )));
  }

  Future getdatafromorderpage() async {
    if (widget.codeorder != null) {
      codeorder = widget.codeorder;
      nameorder = widget.nameorder;
      numorder = widget.numorder;
      numpercrate = widget.numpercrate;
      productset = widget.productset;
    } else {}
  }

  Future insertfavorite(index) async {
    SharedPreferences preferences2 = await SharedPreferences.getInstance();
    stringpreferences2 = preferences2.getString("dealercode");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    stringpreferences1 = preferences.getStringList("codestore");
    try {
      String url = "http://185.78.165.189:3000/pythonapi/insertfavorite";
      var body = {
        "codeproduct": allproductfordisplay[index].codeproduct.toString(),
        "codestore": stringpreferences2!.toString(),
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
                      child: Text('OK'),
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
}
