import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sigma_space/main.dart';
import 'package:sigma_space/page/substore/customerhis.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../classapi/class.dart';
import 'package:http/http.dart' as http;

class customer extends StatefulWidget {
  customer({Key? key}) : super(key: key);

  @override
  _customerState createState() => _customerState();
}

class _customerState extends State<customer> {
  List<Getallcustomer> allcustomer = [];
  List<Getallcustomer> allcustomerfordisplay = [];
  TextEditingController message = TextEditingController();
  TextEditingController messageurl = TextEditingController();
  List<String>? stringpreferences1;
  late List<String> cusdata;
  TextEditingController mysearh = TextEditingController();
  bool toggle = false;
  bool toggleall = false;
  List<bool> toggleselect = [];
  final _formkey = GlobalKey<FormState>();
  int getadmincf = 0;
  int getadmincfforsale = 0;
  List<int> getsaleid = [];
  bool toggle1 = false;
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
            actions: [
              IconButton(
                  onPressed: () {
                    if (toggle1 == false) {
                      toggle1 = true;
                      allcustomerfordisplay.clear();
                      allcustomer.clear();
                      fectallcustomerdataforsale().then((value) {
                        setState(() {
                          allcustomer.addAll(value);
                          allcustomerfordisplay = allcustomer;
                        });
                      });
                    } else {
                      toggle1 = false;
                      getadmincf = 0;
                      allcustomerfordisplay.clear();
                      allcustomer.clear();
                      fectallcustomerdata().then((value) {
                        setState(() {
                          allcustomer.addAll(value);
                          allcustomerfordisplay = allcustomer;
                        });
                      });
                    }
                  },
                  icon: Icon(Icons.work))
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
                    allcustomerfordisplay = allcustomer.where((_allcusname) {
                      var cusname = _allcusname.cusname.toLowerCase();
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
          toggle1 == true
              ? Text(
                  "(${getadmincfforsale} Unit)",
                  style: TextConstants.textstyle,
                )
              : Text(
                  "(${getadmincf} Unit)",
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
    return allcustomerfordisplay[index].sconfrim == 1
        ? Card(
            color: allcustomerfordisplay[index].saleid.toString() ==
                    stringpreferences1![2]
                ? ColorConstants.cardcolor
                : ColorConstants.colorcardorder,
            child: OutlinedButton(
                onPressed: null,
                child: Slidable(
                  endActionPane: ActionPane(
                    motion: ScrollMotion(),
                    children: [
                      Container(
                        color: Colors.blue[900],
                        width: MediaQuery.of(context).size.width / 2.25,
                        height: MediaQuery.of(context).size.height,
                        child: OutlinedButton(
                          onPressed: () => gotosubstore(index),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.history_rounded,
                                color: Colors.white,
                                size: 22.sp,
                              ),
                              Text(
                                "HISTORY",
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
                            TextButton(
                                onPressed: () {
                                  _launchPhoneURL(index);
                                },
                                child: Text(
                                  allcustomerfordisplay[index].phone,
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      fontFamily: 'newbodyfont'),
                                )),
                            allcustomer[index].address == null
                                ? TextButton(
                                    child: Text('Add Location',
                                        style: TextStyle(
                                            fontSize: 16.sp,
                                            fontFamily: 'newbodyfont')),
                                    onPressed: () {
                                      inputlocation(index);
                                    },
                                  )
                                : TextButton(
                                    child: Text("Google map",
                                        style: TextStyle(
                                            fontSize: 16.sp,
                                            fontFamily: 'newbodyfont')),
                                    onPressed: () {
                                      _openmap(index);
                                    },
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
                                        toggleselect[index] =
                                            !toggleselect[index];
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
                )),
          )
        : allcustomer[index].sconfrim == null
            ? Card(
                color: Colors.grey[50],
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
                          allcustomerfordisplay[index].address == null
                              ? Row(
                                  children: [
                                    Icon(Icons.location_on_outlined),
                                    TextButton(
                                      child: Text('Add Location'),
                                      onPressed: () {
                                        inputlocation(index);
                                      },
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          _openmap(index);
                                        },
                                        icon: Icon(
                                          Icons.location_on_outlined,
                                          size: 25.sp,
                                        )),
                                    TextButton(
                                      child: Text(
                                        "Google map",
                                        style: TextConstants.textstyle,
                                      ),
                                      onPressed: () {
                                        _openmap(index);
                                      },
                                    ),
                                  ],
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
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 10, left: 50)),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () {
                                updatesconfirm(index);
                              },
                              icon: Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 50,
                              )),
                          IconButton(
                              onPressed: () {
                                updatecancelsconfirm(index);
                              },
                              icon: Icon(
                                Icons.cancel,
                                color: Colors.red,
                                size: 50,
                              )),
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
                                      toggleselect[index] =
                                          !toggleselect[index];
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
              )
            : SizedBox();
  }

  Future<List<Getallcustomer>> fectallcustomerdata() async {
    SharedPreferences preferences1 = await SharedPreferences.getInstance();
    stringpreferences1 = preferences1.getStringList("codestore");
    String url = "http://185.78.165.189:3000/pythonapi/fullcustomer";
    var body = {
      "codestore": stringpreferences1![0],
    };

    http.Response response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: JsonEncoder().convert(body));

    dynamic jsonres = json.decode(response.body);
    List<Getallcustomer>? _allcustomer = [];

    for (var u in jsonres) {
      Getallcustomer data = Getallcustomer(
          u["MAX(c.cuscode)"],
          u["MAX(c.cusname)"],
          u["MAX(c.phone)"],
          u["MAX(c.address)"],
          u["MAX(c.codestore)"],
          u["MAX(c.sconfirm)"],
          u["auth"],
          u["MAX(c.saleid)"]);
      _allcustomer.add(data);
    }
    print(_allcustomer[2].saleid);
    for (var i in jsonres) {
      toggleselect.add(false);
    }

    for (int i = 0; i < _allcustomer.length; i++) {
      if (_allcustomer[i].sconfrim == 1) {
        getadmincf = getadmincf + 1;
      }
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
      allcustomerfordisplay[index].phone,
      allcustomerfordisplay[index].sconfrim.toString()
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
        String url = "http://185.78.165.189:3000/pythonapi/insertintonotice";

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

  Future updatesconfirm(index) async {
    try {
      String url = "http://185.78.165.189:3000/pythonapi/updatesconfirm";

      var body = {
        "cuscode": allcustomerfordisplay[index].cuscode,
        "codestore": allcustomerfordisplay[index].codestore,
      };
      print(body);

      http.Response response = await http.patch(Uri.parse(url),
          headers: {'Content-Type': 'application/json; charset=utf-8'},
          body: JsonEncoder().convert(body));

      return showDialog(
          context: context,
          builder: (_) => new AlertDialog(
                content: new Text("ยืนยันเรียบร้อย"),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                        return MyApp();
                      }));
                    },
                  )
                ],
              ));
    } catch (e) {
      print(e);
    }
  }

  Future updatecancelsconfirm(index) async {
    try {
      String url = "http://185.78.165.189:3000/pythonapi/updatecancelsconfirm";

      var body = {
        "cuscode": allcustomerfordisplay[index].cuscode,
        "codestore": allcustomerfordisplay[index].codestore,
      };
      print(body);

      http.Response response = await http.patch(Uri.parse(url),
          headers: {'Content-Type': 'application/json; charset=utf-8'},
          body: JsonEncoder().convert(body));

      return showDialog(
          context: context,
          builder: (_) => new AlertDialog(
                content: new Text("ยกเลิกแล้ว"),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                        return MyApp();
                      }));
                    },
                  )
                ],
              ));
    } catch (e) {
      print(e);
    }
  }

  Future inputlocation(index) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: SizedBox(
              // width: 20.w,
              // height: 20.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  new Text("วิธีใส่ที่อยู่"
                      "\n"
                      "1.ให้เข้าแอพ google map และ copy URL "),
                  SizedBox(
                      //height: 5.h,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          onFieldSubmitted: (String value) {
                            setState(() {
                              messageurl.text == value;
                            });
                          },
                          autofocus: true,
                          decoration: InputDecoration(hintText: "ใส่ Url"),
                          controller: messageurl,
                        ),
                      )),
                ],
              ),
            ),
            actions: [
              Padding(padding: EdgeInsets.all(10.0)),
              TextButton(
                  onPressed: () {
                    //_openmap();
                  },
                  child: Container(
                      width: 18.w,
                      height: 5.h,
                      color: ColorConstants.buttoncolor,
                      child: Center(
                          child: Text(
                        "google map",
                        style: TextStyle(color: Colors.white),
                      )))),
              TextButton(
                  onPressed: () {
                    if (messageurl.text.toString() == "") {
                      Navigator.pop(context);
                    } else {
                      updateurl(index);
                      Navigator.pop(context);
                    }
                    print(messageurl.text.toString());
                  },
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

  Future<void> _openmap(Index) async {
    String googleURL = allcustomerfordisplay[Index].address;
    await canLaunch(googleURL)
        ? await launch(googleURL)
        : throw 'Could not launch $googleURL';
  }

  Future updateurl(index) async {
    try {
      String url = "http://185.78.165.189:3000/pythonapi/updateurl";

      var body = {
        "address": messageurl.text.toString(),
        "cuscode": allcustomerfordisplay[index].cuscode,
        "codestore": allcustomerfordisplay[index].codestore,
      };
      print(body);

      http.Response response = await http.patch(Uri.parse(url),
          headers: {'Content-Type': 'application/json; charset=utf-8'},
          body: JsonEncoder().convert(body));

      return showDialog(
          context: context,
          builder: (_) => new AlertDialog(
                content: new Text("เพิ่มแล้ว"),
                actions: <Widget>[
                  TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      })
                ],
              ));
    } catch (e) {
      print(e);
    }
  }

  Future<List<Getallcustomer>> fectallcustomerdataforsale() async {
    SharedPreferences preferences1 = await SharedPreferences.getInstance();
    stringpreferences1 = preferences1.getStringList("codestore");
    String url = "http://185.78.165.189:3000/pythonapi/fullcustomerforsale";
    var body = {
      "codestore": stringpreferences1![0],
      "saleid": stringpreferences1![2]
    };

    http.Response response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: JsonEncoder().convert(body));

    dynamic jsonres = json.decode(response.body);
    List<Getallcustomer>? _allcustomerforsale = [];

    for (var u in jsonres) {
      Getallcustomer data = Getallcustomer(
          u["MAX(c.cuscode)"],
          u["MAX(c.cusname)"],
          u["MAX(c.phone)"],
          u["MAX(c.address)"],
          u["MAX(c.codestore)"],
          u["MAX(c.sconfirm)"],
          u["auth"],
          u["MAX(c.saleid)"]);
      _allcustomerforsale.add(data);
    }

    for (var i in jsonres) {
      toggleselect.add(false);
    }

    getadmincfforsale = _allcustomerforsale.length;

    return _allcustomerforsale;
  }
}
