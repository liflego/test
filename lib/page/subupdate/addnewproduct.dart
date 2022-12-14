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
import 'package:sigma_space/update.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class addnewproductpage extends StatefulWidget {
  addnewproductpage({Key? key}) : super(key: key);

  @override
  _addnewproductpage createState() => _addnewproductpage();
}

class _addnewproductpage extends State<addnewproductpage> {
  @override
  String? _scanBarcode = '';
  TextEditingController code = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController type = TextEditingController();
  TextEditingController score = TextEditingController();
  TextEditingController numbers = TextEditingController();
  TextEditingController numberspercrate = TextEditingController();
  TextEditingController price = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  List<String>? stringpreferences1;
  bool toggle = false;
  int selectedValue = 1;
  void initState() {
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
                    "ADD",
                    style:
                        TextStyle(fontFamily: 'newtitlefont', fontSize: 25.sp),
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
                      ))),
              backgroundColor: ColorConstants.backgroundbody,
              body: Form(
                key: _formkey,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Column(
                      children: [
                        textcode(),
                        textname(),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [texttype(), textscore(), textprice()]),
                        SizedBox(
                          child: textnumberspercrate(),
                          width: MediaQuery.of(context).size.width / 2,
                        ),
                        SizedBox(
                          child: textnumber(),
                          width: MediaQuery.of(context).size.width / 2,
                        ),
                        buttondone()
                      ],
                    ),
                  ),
                ),
              )),
        );
      },
    );
  }

  Widget textcode() {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[50],
            border: Border.all(color: HexColor('#39474F'), width: 2),
            borderRadius: BorderRadius.circular(10.0)),
        child: Center(
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            SizedBox(
              width: 50.w,
              height: 7.h,
              child: Center(
                child: TextFormField(
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 15.0.sp),
                  decoration: InputDecoration(
                      hintText: toggle == true ? code.text : "??????????????????????????????",
                      hintStyle:
                          TextStyle(fontFamily: "newbodyfont", fontSize: 15.sp),
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white))),
                  onChanged: (value) {
                    value = code.text;
                  },
                  controller: code,
                ),
              ),
            ),
            TextButton(
                onPressed: scanbarcode,
                child: toggle == true
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            toggle = false;
                          });
                        },
                        icon: Icon(
                          Icons.close,
                          color: Colors.black,
                        ))
                    : Text(
                        "[=]",
                        style: TextStyle(color: Colors.amber, fontSize: 12.sp),
                      ))
          ]),
        ),
      ),
    );
  }

  Widget textname() {
    return Padding(
      padding: EdgeInsets.all(5),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: TextFormField(
          onChanged: (text) => setState(() {
            text = name.text.trim();
          }),
          controller: name,
          style: TextStyle(fontSize: 20.sp, fontFamily: 'newbodyfont'),
          decoration: InputDecoration(
            labelText: "??????????????????????????????",
            labelStyle: TextStyle(fontFamily: "newbodyfont", fontSize: 15.sp),
            filled: false,
            hintStyle: TextStyle(fontFamily: "newbodyfont", fontSize: 15.sp),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: HexColor('#39474F'), width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.yellow.shade800, width: 2),
            ),
          ),
          validator: (input) {
            if (input!.length < 1) {
              return "Please input nameproduct";
            }
          },
        ),
      ),
    );
  }

  Widget texttype() {
    return Padding(
      padding: EdgeInsets.all(5),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 3,
        child: TextFormField(
          onChanged: (text) => setState(() {
            text = type.text.trim();
          }),
          controller: type,
          style: TextStyle(fontSize: 20.sp, fontFamily: 'newbodyfont'),
          decoration: InputDecoration(
            labelText: "????????????????????????????????????",
            labelStyle: TextStyle(fontFamily: "newbodyfont", fontSize: 15.sp),
            filled: false,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: HexColor('#39474F'), width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.yellow.shade800, width: 2),
            ),
          ),
          validator: (input) {
            if (input!.length < 1) {
              return "Please input typeproduct";
            }
          },
        ),
      ),
    );
  }

  Widget textscore() {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 4,
            child: TextFormField(
              onChanged: (text) => setState(() {
                text = score.text.trim();
              }),
              controller: score,
              style: TextStyle(fontSize: 20.sp, fontFamily: 'newbodyfont'),
              decoration: InputDecoration(
                labelText: "?????????????????????????????????",
                labelStyle:
                    TextStyle(fontFamily: "newbodyfont", fontSize: 15.sp),
                filled: false,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: HexColor('#39474F'), width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.yellow.shade800, width: 2),
                ),
              ),
              validator: (input) {
                if (input!.length < 1) {
                  return "Please input";
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget textprice() {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: TextFormField(
              onChanged: (text) => setState(() {
                text = price.text.trim();
              }),
              controller: price,
              style: TextStyle(fontSize: 20.sp, fontFamily: 'newbodyfont'),
              decoration: InputDecoration(
                labelText: "????????????????????????",
                labelStyle:
                    TextStyle(fontFamily: "newbodyfont", fontSize: 15.sp),
                filled: false,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: HexColor('#39474F'), width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.yellow.shade800, width: 2),
                ),
              ),
              validator: (input) {
                if (input!.length < 1) {
                  return "Please input";
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget textnumberspercrate() {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Row(
        children: [
          Text(
            "???????????????",
            style: TextConstants.textstyle,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 6,
            child: TextFormField(
              onChanged: (text) => setState(() {
                text = numberspercrate.text.trim();
              }),
              controller: numberspercrate,
              style: TextStyle(fontSize: 20.sp, fontFamily: 'newbodyfont'),
              decoration: InputDecoration(
                labelText: "?????????",
                labelStyle:
                    TextStyle(fontFamily: "newbodyfont", fontSize: 15.sp),
                filled: false,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (input) {
                if (input!.length < 1) {
                  return "Please input";
                }
              },
            ),
          ),
          DropdownButton(
              value: selectedValue,
              items: [
                DropdownMenuItem(
                  child: Text("?????????"),
                  value: 1,
                ),
                DropdownMenuItem(
                  child: Text("?????????"),
                  value: 2,
                ),
                DropdownMenuItem(
                  child: Text("?????????"),
                  value: 3,
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedValue = value as int;
                });
              })
        ],
      ),
    );
  }

  Widget textnumber() {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Row(
        children: [
          Text(
            "???????????????",
            style: TextConstants.textstyle,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 6,
            child: TextFormField(
              onChanged: (text) => setState(() {
                text = numbers.text.trim();
              }),
              controller: numbers,
              style: TextStyle(fontSize: 20.sp, fontFamily: 'newbodyfont'),
              decoration: InputDecoration(
                labelText: "?????????",
                labelStyle:
                    TextStyle(fontFamily: "newbodyfont", fontSize: 15.sp),
                filled: false,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (input) {
                if (input!.length < 1) {
                  return "Please input";
                }
              },
            ),
          ),
          Text(
            "?????????",
            style: TextConstants.textstyle,
          ),
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
          onPressed: insertnewproduct,
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

  Future<void> scanbarcode() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      toggle == true;
      code.text = barcodeScanRes;
    });
  }

  Future insertnewproduct() async {
    ///?????????
    SharedPreferences preferences1 = await SharedPreferences.getInstance();
    stringpreferences1 = preferences1.getStringList("codestore");
    String pdset = "";
    if (selectedValue == 1) {
      pdset = "?????????";
    } else if (selectedValue == 2) {
      pdset = "?????????";
    } else if (selectedValue == 3) {
      pdset = "?????????";
    }
    if (_formkey.currentState!.validate()) {
      try {
        String url = "http://185.78.165.189:3000/nodejsapi/insertproduct";
        var body = {
          "codeproduct": code.text.trim(),
          "nameproduct": name.text.trim(),
          "codestore": stringpreferences1![0],
          "amount": int.parse(numbers.text.trim()),
          "amountpercrate": int.parse(numberspercrate.text.trim()),
          "productset": pdset.trim(),
          "type": type.text.trim(),
          "score": int.parse(score.text.trim()),
          "price": int.parse(price.text.trim())
        };
        http.Response response = await http.post(Uri.parse(url),
            headers: {'Content-Type': 'application/json; charset=utf-8'},
            body: JsonEncoder().convert(body));

        if (response.statusCode == 200) {
          name.clear();
          score.clear();
          numbers.clear();
          numberspercrate.clear();
          type.clear();
          code.clear();
          return showDialog(
              context: context,
              builder: (_) => new AlertDialog(
                    content: new Text("Update success"),
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
    } else {
      print("server error");
    }
  }
}
