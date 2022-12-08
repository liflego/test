import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sigma_space/classapi/class.dart';
import 'package:sigma_space/login.dart';
import 'package:sigma_space/main.dart';
import 'package:sigma_space/page/subupdate/addnewproduct.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class updatepage extends StatefulWidget {
  String codeproduct;
  updatepage({Key? key, required this.codeproduct}) : super(key: key);

  @override
  _updatepage createState() => _updatepage();
}

class _updatepage extends State<updatepage> {
  @override
  List<dynamic>? allproductfordisplay = [];
  TextEditingController score = TextEditingController();
  TextEditingController amount = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  List<String>? stringpreferences1;

  void initState() {
    fectdatafromapi();

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
                  "UPDATE",
                  style: TextStyle(fontFamily: 'newtitlefont', fontSize: 25.sp),
                ),
                backgroundColor: ColorConstants.appbarcolor,
                leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => MyApp()));
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 20.sp,
                    )),
              ),
              backgroundColor: ColorConstants.backgroundbody,
              body: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: listitem()),
                    update(),
                    buttondone()
                  ],
                ),
              ),
            ));
      },
    );
  }

  Widget update() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "EDIT :",
            style: TextStyle(
                fontSize: 20.sp,
                fontFamily: 'newbodyfont',
                color: Colors.black),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Score :",
                  style: TextConstants.textstyle,
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {
                          score.text = value;
                        });
                      },
                      style: TextStyle(
                          fontSize: 20.sp,
                          fontFamily: 'newbodyfont',
                          color: Colors.black),
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        hintText: "${allproductfordisplay?[6]}",
                        hintStyle: TextStyle(fontSize: 20.0.sp),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide:
                              BorderSide(color: HexColor('#39474F'), width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                              color: Colors.yellow.shade800, width: 2),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "จำนวน :",
                  style: TextConstants.textstyle,
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {
                          amount.text = value;
                        });
                      },
                      style: TextStyle(
                          fontSize: 20.sp,
                          fontFamily: 'newbodyfont',
                          color: Colors.black),
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        hintText: "${allproductfordisplay?[2]}",
                        hintStyle: TextStyle(fontSize: 20.0.sp),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide:
                              BorderSide(color: HexColor('#39474F'), width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(
                              color: Colors.yellow.shade800, width: 2),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buttondone() {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.circular(
            10.0,
          ),
        ),
        child: TextButton(
          onPressed: updateamountproduct,
          child: Text(
            "DONE",
            style: TextStyle(
                fontSize: 20.sp,
                fontFamily: 'newbodyfont',
                color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget listitem() {
    return Card(
        elevation: 2,
        color: allproductfordisplay![6] == 4
            ? ColorConstants.sc4
            : allproductfordisplay![6] == 3
                ? ColorConstants.sc3
                : allproductfordisplay![6] == 2
                    ? ColorConstants.sc2
                    : Colors.grey[50],
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
                            Text(
                              allproductfordisplay?[1] +
                                  "(" +
                                  allproductfordisplay?[4] +
                                  "ละ" +
                                  "${allproductfordisplay?[3]}" +
                                  ")",
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'newbodyfont',
                                  color: Colors.black),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              allproductfordisplay?[0],
                              style: TextConstants.textstyle,
                            ),
                            Text(
                              "ประเภท: ${allproductfordisplay?[5]}",
                              style: TextConstants.textstyle,
                            ),
                            allproductfordisplay?[2] == 0
                                ? Text(
                                    "จำนวน : ${allproductfordisplay?[2]}",
                                    style: TextStyle(
                                        fontSize: 18.sp,
                                        fontFamily: 'newbodyfont',
                                        color: Colors.red),
                                  )
                                : Text(
                                    "จำนวน : ${allproductfordisplay?[2]}" +
                                        "(${((allproductfordisplay?[2]) / allproductfordisplay?[3]).toInt()}" +
                                        allproductfordisplay?[4] +
                                        ")",
                                    style: TextConstants.textstyle,
                                  ),
                            Text(
                              "ราคา: ${allproductfordisplay?[7]}",
                              style: TextConstants.textstyle,
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
        ));
  }

  Future fectdatafromapi() async {
    SharedPreferences preferences1 = await SharedPreferences.getInstance();
    stringpreferences1 = preferences1.getStringList("codestore");
    String url = "http://185.78.165.189:3000/nodejsapi/codeproduct/codestore";
    var body = {
      "codeproduct": widget.codeproduct,
      "codestore": stringpreferences1?[0],
    };

    http.Response response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: JsonEncoder().convert(body));

    dynamic jsonres = json.decode(response.body);
    List<Getallproduct>? _allproduct = [];

    allproductfordisplay!.add(jsonres["codeproduct"]);
    allproductfordisplay!.add(jsonres["nameproduct"]);
    allproductfordisplay!.add(jsonres["amount"]);
    allproductfordisplay!.add(jsonres["amountpercrate"]);
    allproductfordisplay!.add(jsonres["productset"]);
    allproductfordisplay!.add(jsonres["type"]);
    allproductfordisplay!.add(jsonres["score"]);
    allproductfordisplay!.add(jsonres["price"]);

    setState(() {
      score.text = allproductfordisplay![6].toString();
      amount.text = allproductfordisplay![2].toString();
    });
  }

  Future updateamountproduct() async {
    if (_formkey.currentState!.validate()) {
      try {
        String url = "http://185.78.165.189:3000/nodejsapi/updateamountproduct";
        var body = {
          "nameproduct": allproductfordisplay?[0].nameproduct,
          "score": int.parse(score.text.trim()),
          "amount": int.parse(amount.text.trim()),
          "codestore": stringpreferences1![0],
          "codeproduct": allproductfordisplay?[0].codeproduct.trim()
        };
        http.Response response = await http.patch(Uri.parse(url),
            headers: {'Content-Type': 'application/json; charset=utf-8'},
            body: JsonEncoder().convert(body));

        if (response.statusCode == 200) {
          return showDialog(
              context: context,
              // ignore: unnecessary_new
              builder: (_) => new AlertDialog(
                    content: new Text("Update success"),
                    actions: <Widget>[
                      TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => MyApp()));
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
    } else {
      print("server error");
    }
  }
}
