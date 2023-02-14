import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sigma_space/page/substore/customerhis.dart';
import 'package:sizer/sizer.dart';
import 'package:textfield_search/textfield_search.dart';
import 'package:url_launcher/url_launcher.dart';
import '../classapi/class.dart';
import 'package:http/http.dart' as http;
import 'package:popup_card/popup_card.dart';

class customer extends StatefulWidget {
  customer({Key? key}) : super(key: key);

  @override
  _customerState createState() => _customerState();
}

class _customerState extends State<customer> {
  List<Getallcustomer> allcustomer = [];
  List<Getallcustomer> allcustomerfordisplay = [];
  TextEditingController message = TextEditingController();
  List<String>? stringpreferences1;
  late List<String> cusdata;
  TextEditingController mysearh = TextEditingController();
  List<Getcustomerstore> alldata = [];
  bool toggle = false;
  bool toggleall = false;
  List<bool> toggleselect = [];
  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    fectallcustomerdata().then((value) {
      setState(() {
        allcustomer.addAll(value);
        allcustomerfordisplay = allcustomer;
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
              "CUSTOMER",
              style: TextStyle(fontFamily: 'newtitlefont', fontSize: 25.sp),
            ),
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
                  itemCount: allcustomerfordisplay.length,
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
                                  insertintonotice();
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
                    allcustomerfordisplay = allcustomer.where((_allproduct) {
                      var cusname = _allproduct.cusname.toLowerCase();
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
            "(${allcustomerfordisplay.length} Unit)",
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
                                  i < allcustomerfordisplay.length;
                                  i++) {
                                toggleselect[i] = true;
                              }
                            } else {
                              toggleall = false;
                              for (int i = 0;
                                  i < allcustomerfordisplay.length;
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
        onPressed: () => gotosubstore(index),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    allcustomerfordisplay[index].cusname,
                    style: TextConstants.textstyle,
                  ),
                  Text(
                    allcustomerfordisplay[index].address,
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
                        allcustomerfordisplay[index].phone,
                        style: TextConstants.textstyle,
                      ),
                    ],
                  ),
                  allcustomerfordisplay[index].notes == "Put your note.."
                      ? SizedBox()
                      : Text(
                          "#" + allcustomerfordisplay[index].notes,
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

  Future<List<Getallcustomer>> fectallcustomerdata() async {
    SharedPreferences preferences1 = await SharedPreferences.getInstance();
    stringpreferences1 = preferences1.getStringList("codestore");
    String url = "http://185.78.165.189:3000/nodejsapi/customer";
    var body = {
      "codestore": stringpreferences1![0],
    };

    http.Response response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: JsonEncoder().convert(body));

    dynamic jsonres = json.decode(response.body);
    List<Getallcustomer>? _allcustomer = [];

    for (var u in jsonres) {
      Getallcustomer data = Getallcustomer(u["cuscode"], u["cusname"],
          u["phone"], u["address"], u["codestore"], u["notes"], u["score"]);
      _allcustomer.add(data);
    }

    for (var i in jsonres) {
      toggleselect.add(false);
    }

    return _allcustomer;
  }

  _launchPhoneURL(index) async {
    String url = ('tel:' + allcustomerfordisplay[index].phone);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future gotosubstore(index) async {
    cusdata = [
      allcustomerfordisplay[index].cuscode,
      allcustomerfordisplay[index].cusname,
      allcustomerfordisplay[index].address,
      allcustomerfordisplay[index].phone,
      allcustomerfordisplay[index].notes,
      allcustomerfordisplay[index].score.toString()
    ];

    SharedPreferences prefercustomer = await SharedPreferences.getInstance();
    prefercustomer.setStringList("cusdata", cusdata);
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => storehis(
              cusdata: cusdata,
            )));
  }

  Future insertintonotice() async {
    if (_formkey.currentState!.validate()) {
      try {
        SharedPreferences preferences1 = await SharedPreferences.getInstance();
        stringpreferences1 = preferences1.getStringList("codestore");
        String url = "http://185.78.165.189:3000/nodejsapi/insertintonotice";

        for (int i = 0; i < allcustomerfordisplay.length; i++) {
          if (toggleselect[i] == true) {
            var body = {
              "ordernumber": 0.toString(),
              "fromwho": stringpreferences1![0],
              "fromposition": stringpreferences1![1],
              "towho": allcustomerfordisplay[i].cuscode,
              "toposition": "DEALER",
              "message": message.text.trim(),
              "date": DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())
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
}
