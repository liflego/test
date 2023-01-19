import 'dart:convert';
import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sigma_space/login.dart';
import 'package:sigma_space/page/chectsotck.dart';
import 'package:sigma_space/page/substore/customerhis.dart';
import 'package:sizer/sizer.dart';
import 'package:textfield_search/textfield_search.dart';
import 'package:url_launcher/url_launcher.dart';
import '../classapi/class.dart';
import 'package:http/http.dart' as http;
import 'package:popup_card/popup_card.dart';

class dealerpage extends StatefulWidget {
  dealerpage({Key? key}) : super(key: key);

  @override
  _dealerpageState createState() => _dealerpageState();
}

class _dealerpageState extends State<dealerpage> {
  GoogleSignIn _googleSignIn = GoogleSignIn();
  List<Getalldealer> alldealer = [];
  List<Getalldealer> alldealerfordisplay = [];
  TextEditingController message = TextEditingController();
  List<String>? stringpreferences1;
  var _scanBarcode;
  late List<String> cusdata;
  TextEditingController mysearh = TextEditingController();
  List<Getcustomerstore> alldata = [];
  bool toggle = false;
  bool toggleall = false;
  List<bool> toggleselect = [];
  final _formkey = GlobalKey<FormState>();
  List<String> list = [];

  @override
  void initState() {
    fectalldealerdata().then((value) {
      setState(() {
        alldealer.addAll(value);
        alldealerfordisplay = alldealer;
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
            backgroundColor: ColorConstants.appbarcolor,
            toolbarHeight: 7.h,
            title: Text(
              "DEALER",
              style: TextStyle(fontFamily: 'newtitlefont', fontSize: 25.sp),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    scanbarcode();
                  },
                  icon: Icon(Icons.qr_code_scanner))
            ],
          ),
          backgroundColor: ColorConstants.backgroundbody,
          body: Form(
            key: _formkey,
            child: ListView(children: [
              serchBar(),
              countstore(),
              SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                child: ListView.builder(
                  itemCount: alldealerfordisplay.length,
                  itemBuilder: (BuildContext context, int index) {
                    return listItem(index);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.3,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.length < 1) {
                            return "Please enter message";
                          }
                        },
                        controller: message,
                        onFieldSubmitted: (value) => {
                          setState(() {
                            message.text = value;
                          })
                        },
                        maxLines: 3,
                        decoration: InputDecoration(
                            hintText: "Message box..",
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 1))),
                      ),
                    ),
                    toggle == true
                        ? Container(
                            color: Colors.red,
                            width: MediaQuery.of(context).size.width / 7.5,
                            height: MediaQuery.of(context).size.height / 10,
                            child: IconButton(
                                onPressed: () {
                                  if (stringpreferences1![1] == "DEALER") {
                                    insertintonoticefordealer();
                                  } else {
                                    insertintonotice();
                                  }
                                },
                                icon: Icon(
                                  Icons.send,
                                  size: 30.sp,
                                  color: Colors.white,
                                )),
                          )
                        : Container(
                            color: Colors.amber,
                            width: MediaQuery.of(context).size.width / 7.5,
                            height: MediaQuery.of(context).size.height / 10,
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    toggle = !toggle;
                                  });
                                },
                                icon: Icon(
                                  Icons.check_box_outline_blank,
                                  size: 30.sp,
                                  color: Colors.white,
                                )),
                          ),
                  ],
                ),
              ),
            ]),
          ),
          drawer: Drawer(
            backgroundColor: Colors.green[700],
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Column(
                    children: [
                      Text(
                        'ชื่อร้าน',
                        style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'newtitlefont'),
                      ),
                      Text(
                        'ID:',
                        style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'newtitlefont'),
                      ),
                      Text(
                        'วันที่ใช้บริการ :',
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
                Container(
                  color: Colors.grey[50],
                  child: Row(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 7,
                        width: MediaQuery.of(context).size.width / 4,
                        color: Colors.red,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: SizedBox(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "ID : ...",
                                style: TextStyle(
                                    fontFamily: "newbodyfont", fontSize: 15.sp),
                              ),
                              Text(
                                "Name : ...",
                                style: TextStyle(
                                    fontFamily: "newbodyfont", fontSize: 15.sp),
                              ),
                              Text(
                                "Age : ...",
                                style: TextStyle(
                                    fontFamily: "newbodyfont", fontSize: 15.sp),
                              ),
                              Text(
                                "ADDRESS : ...",
                                style: TextStyle(
                                    fontFamily: "newbodyfont", fontSize: 15.sp),
                                maxLines: 2,
                              ),
                              Text(
                                "MAP : ...",
                                style: TextStyle(
                                    fontFamily: "newbodyfont", fontSize: 15.sp),
                                maxLines: 2,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border:
                            Border.all(width: 0, color: Colors.grey.shade800),
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
                            _googleSignIn.signOut().then((value) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => (login()),
                                ),
                              );
                            });
                          },
                        ),
                      )),
                )
              ],
            ),
          ),
        ),
      );
    });
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
          child: SizedBox(
            width: 40.w,
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
                    alldealerfordisplay = alldealer.where((_allproduct) {
                      var cusname = _allproduct.dealername.toLowerCase();
                      return cusname.contains(text);
                    }).toList();
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget countstore() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "(${alldealerfordisplay.length} Unit)",
            style: TextConstants.textstyle,
          ),
          toggle == true
              ? Row(
                  children: [
                    Text(
                      "Cancle",
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontFamily: 'newbodyfont',
                          color: Colors.red),
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            toggle = !toggle;
                          });
                        },
                        icon: Icon(
                          Icons.cancel_outlined,
                          size: 20.sp,
                          color: Colors.red,
                        )),
                    Text(
                      "เลือกทั้งหมด",
                      style: TextConstants.textstyle,
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            if (toggleall == false) {
                              toggleall = true;
                              for (int i = 0;
                                  i < alldealerfordisplay.length;
                                  i++) {
                                toggleselect[i] = true;
                              }
                            } else {
                              toggleall = false;
                              for (int i = 0;
                                  i < alldealerfordisplay.length;
                                  i++) {
                                toggleselect[i] = false;
                              }
                            }
                          });
                        },
                        icon: toggleall == false
                            ? Icon(Icons.check_box_outline_blank, size: 20.sp)
                            : Icon(Icons.check_box_outlined, size: 20.sp)),
                  ],
                )
              : SizedBox(height: 5),
        ],
      ),
    );
  }

  Widget listItem(index) {
    return Card(
      color: ColorConstants.colorcardorder,
      child: OutlinedButton(
        onPressed: () async {
          SharedPreferences stringpreferences2 =
              await SharedPreferences.getInstance();
          stringpreferences2.setString(
              "dealercode", alldealerfordisplay[index].dealercode);

          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => checkstock(
              codeorder: [],
              nameorder: [],
              numorder: [],
              numpercrate: [],
              productset: [],
            ),
          ));
        },
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    alldealerfordisplay[index].dealername,
                    style: TextConstants.textstyle,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {
                            _launchPhoneURL(index);
                          },
                          icon: Icon(
                            Icons.call,
                            color: Colors.black,
                          )),
                      Text(
                        alldealerfordisplay[index].phone,
                        style: TextConstants.textstyle,
                      ),
                    ],
                  ),
                  alldealerfordisplay[index].notes == "Put your note.."
                      ? SizedBox()
                      : Text(
                          "#" + alldealerfordisplay[index].notes,
                          style: TextConstants.textStylenotes,
                        ),
                ],
              ),
              toggle == false
                  ? SizedBox(
                      height: 10,
                    )
                  : Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: IconButton(
                          onPressed: () {
                            setState(() {
                              toggleselect[index] = !toggleselect[index];
                              toggleall = false;
                            });
                          },
                          icon: toggleselect[index] == false
                              ? Icon(
                                  Icons.check_box_outline_blank,
                                  size: 20.sp,
                                )
                              : Icon(
                                  Icons.check_box_outlined,
                                  size: 20.sp,
                                )),
                    )
            ],
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
          '#ff6666', 'Cancel', true, ScanMode.QR);
      setState(() {
        _scanBarcode = barcodeScanRes;
        list = _scanBarcode.split(" ");
      });
      insertintodealer();
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

  Future<List<Getalldealer>> fectalldealerdata() async {
    SharedPreferences preferences1 = await SharedPreferences.getInstance();
    stringpreferences1 = preferences1.getStringList("codestore");
    String url = "http://185.78.165.189:3000/nodejsapi/dealer";
    var body = {
      "codestore": stringpreferences1![0],
    };

    print(body.runtimeType);
    http.Response response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: JsonEncoder().convert(body));

    dynamic jsonres = json.decode(response.body);
    List<Getalldealer>? _alldealer = [];

    for (var u in jsonres) {
      Getalldealer data = Getalldealer(u["dealercode"], u["dealername"],
          u["phone"], u["codestore"], u["notes"]);
      _alldealer.add(data);
    }

    for (var i in jsonres) {
      toggleselect.add(false);
    }

    return _alldealer;
  }

  _launchPhoneURL(index) async {
    String url = ('tel:' + alldealerfordisplay[index].phone);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Future gotosubstore(index) async {
  //   cusdata = [
  //     alldealerfordisplay[index].cuscode,
  //     alldealerfordisplay[index].cusname,
  //     alldealerfordisplay[index].address,
  //     alldealerfordisplay[index].phone,
  //     alldealerfordisplay[index].notes,
  //     alldealerfordisplay[index].score.toString()
  //   ];

  //   SharedPreferences prefercustomer = await SharedPreferences.getInstance();
  //   prefercustomer.setStringList("cusdata", cusdata);
  //   Navigator.of(context).pushReplacement(MaterialPageRoute(
  //       builder: (context) => storehis(
  //             cusdata: cusdata,
  //           )));
  // }

  Future insertintonotice() async {
    if (_formkey.currentState!.validate()) {
      try {
        SharedPreferences preferences1 = await SharedPreferences.getInstance();
        stringpreferences1 = preferences1.getStringList("codestore");
        String url = "http://185.78.165.189:3000/nodejsapi/insertintonotice";

        for (int i = 0; i < alldealerfordisplay.length; i++) {
          if (toggleselect[i] == true) {
            var body = {
              //if sent message order number set = 0
              "ordernumber": 0.toString(),
              "fromwho": stringpreferences1![0],
              "fromposition": stringpreferences1![1],
              "towho": alldealerfordisplay[i].dealercode,
              "toposition": "DEALER",
              "message": message.text.trim()
            };

            http.Response response = await http.post(Uri.parse(url),
                headers: {'Content-Type': 'application/json; charset=utf-8'},
                body: JsonEncoder().convert(body));
          }
        }
        return showDialog(
            context: context,
            builder: (_) => new AlertDialog(
                  content: new Text("Message send successfully"),
                  actions: <Widget>[
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ));
      } catch (error) {
        print(error);
      }
    }
  }

  Future insertintonoticefordealer() async {
    if (_formkey.currentState!.validate()) {
      try {
        SharedPreferences preferences1 = await SharedPreferences.getInstance();
        stringpreferences1 = preferences1.getStringList("codestore");
        String url = "http://185.78.165.189:3000/nodejsapi/insertintonotice";

        for (int i = 0; i < alldealerfordisplay.length; i++) {
          if (toggleselect[i] == true) {
            var body = {
              "ordernumber": 0.toString(),
              "fromwho": stringpreferences1![0],
              "fromposition": stringpreferences1![1],
              "towho": alldealerfordisplay[i].dealercode,
              "toposition": "SALE",
              "message": message.text.trim()
            };

            http.Response response = await http.post(Uri.parse(url),
                headers: {'Content-Type': 'application/json; charset=utf-8'},
                body: JsonEncoder().convert(body));
          }
        }

        setState(() {
          toggle = false;
          toggleall = false;
          message.clear();
          for (int i = 0; i < alldealerfordisplay.length; i++) {
            toggleselect[i] = false;
          }
        });
        return showDialog(
            context: context,
            builder: (_) => new AlertDialog(
                  content: new Text("Message send successfully"),
                  actions: <Widget>[
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ));
      } catch (error) {
        print(error);
      }
    }
  }

  Future insertintodealer() async {
    try {
      SharedPreferences preferences1 = await SharedPreferences.getInstance();
      stringpreferences1 = preferences1.getStringList("codestore");
      String url = "http://185.78.165.189:3000/nodejsapi/inserttodealer";

      var body = {
        "dealercode": list[0].trim(),
        "dealername": list[1].trim(),
        "phone": list[2].trim(),
        "codestore": list[3].trim(),
        "notes": list[4].trim()
      };

      print(body);

      http.Response response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json; charset=utf-8'},
          body: JsonEncoder().convert(body));

      return showDialog(
          context: context,
          builder: (_) => new AlertDialog(
                content: new Text("Message send successfully"),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ));
    } catch (error) {
      print(error);
    }
  }
}
