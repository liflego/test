// ignore_for_file: no_logic_in_create_state, unnecessary_string_interpolations, prefer_const_constructors, unnecessary_new

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:flutter_launcher_icons/constants.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sigma_space/classapi/class.dart';
import 'package:sigma_space/main.dart';
import 'package:sigma_space/page/chectsotck.dart';
import 'package:sizer/sizer.dart';
import 'package:textfield_search/textfield_search.dart';
import 'package:sigma_space/classapi/class.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class orderforadminedit extends StatefulWidget {
  int ordernumber;
  String cuscode;
  String cusname;
  String pay;
  String amountlist;
  String date;
  orderforadminedit(
      {Key? key,
      required this.ordernumber,
      required this.cuscode,
      required this.cusname,
      required this.pay,
      required this.amountlist,
      required this.date})
      : super(key: key);

  @override
  _orderforadminedit createState() => _orderforadminedit();
}

class _orderforadminedit extends State<orderforadminedit> {
  @override
  TextEditingController notes = TextEditingController();

  final _formkey = GlobalKey<FormState>();
  late String pay;
  List<String>? stringpreferences1;
  List<GetorderBycodestoreandcuscodeandordernumber> allorder = [];
  List<GetorderBycodestoreandcuscodeandordernumber> allorderfordisplay = [];

  List<num> myprice = [];
  List<num> mysumprice = [];
  final numformat = new NumberFormat("#,##0.00", "en_US");

  @override
  void initState() {
    listgetdatastore().then((value) {
      setState(() {
        allorder.addAll(value);
        allorderfordisplay = allorder;
        notes.text = allorderfordisplay[0].notes;

        for (int i = 0; i < allorderfordisplay.length; i++) {
          if (allorderfordisplay[i].price == null) {
            myprice.add(0);
            mysumprice.add(0);
          } else {
            myprice.add(allorderfordisplay[i].price);
            mysumprice.add(
                allorderfordisplay[i].price * allorderfordisplay[i].amount);
          }
        }
      });
    });

    super.initState();
  }

  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return SafeArea(
          top: false,
          child: Scaffold(
              appBar: AppBar(
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
                toolbarHeight: 7.h,
                title: Text(
                  "ORDER",
                  style: TextConstants.appbartextsyle,
                ),
                backgroundColor: ColorConstants.appbarcolor,
              ),
              body: ListView(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "คำสั่งซื้อที่ ${widget.ordernumber}",
                                style: TextConstants.textstyle,
                              ),
                              IconButton(
                                  onPressed: () {
                                    Clipboard.setData(new ClipboardData(
                                        text: "${widget.ordernumber}"));
                                  },
                                  icon: Icon(
                                    Icons.copy,
                                    size: 15.sp,
                                    color: Colors.blue,
                                  ))
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.cusname,
                                style: TextConstants.textstyle,
                              ),
                              Text(
                                widget.date,
                                style: TextConstants.textstyle,
                              ),
                            ],
                          ),
                          Text(
                            "วิธีการชำระ : ${widget.pay}",
                            style: TextConstants.textstyle,
                          ),
                          Text(
                            "จำนวน ${widget.amountlist} รายการ",
                            style: TextConstants.textstyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 5.sp),
                  Container(
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height / 2.4,
                    child: listitems(),
                  ),
                  sumprice(),
                  note(),
                  done()
                ],
              )));
    });
  }

  Widget listitems() {
    return Padding(
      padding: EdgeInsets.all(2.0),
      child: ListView.builder(
        itemCount: allorderfordisplay.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.circle_rounded,
                              size: 10.sp,
                            ),
                            Text(
                              "รายการที่ " + "${index + 1}",
                              style: TextConstants.textstyle,
                            ),
                          ],
                        ),
                        Text("${allorderfordisplay[index].nameproduct}",
                            style: TextConstants.textstyle),
                        Text("(${allorderfordisplay[index].codeproduct})",
                            style: TextConstants.textstyle),
                        Text("จำนวน ${allorderfordisplay[index].amount}",
                            style: TextConstants.textstyle),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("ราคา", style: TextConstants.textstyle),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 32,
                                  width: MediaQuery.of(context).size.width / 5,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        hintText: allorderfordisplay[index]
                                                    .price ==
                                                null
                                            ? ""
                                            : "${allorderfordisplay[index].price}",
                                        hintStyle: TextConstants.textstyle),
                                    onFieldSubmitted: (value) {
                                      setState(() {
                                        myprice[index] = double.parse(value);
                                        mysumprice[index] = myprice[index] *
                                            allorderfordisplay[index].amount;
                                      });
                                    },
                                    style: TextConstants.textstyle,
                                  )),
                            ),
                            Text("หน่วย/บาท", style: TextConstants.textstyle),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Text(
                                "(" +
                                    numformat.format(((myprice[index]) *
                                        allorderfordisplay[index].amount)) +
                                    " บาท)",
                                style: TextConstants.textstyle,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget sumprice() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "รวมทั้งหมด",
            style: TextConstants.textstyle,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 2),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              width: MediaQuery.of(context).size.width / 3,
              height: MediaQuery.of(context).size.height / 20,
              child: Center(
                child: mysumprice.isEmpty
                    ? Text(
                        "0",
                        style: TextConstants.textstyle,
                      )
                    : Text(
                        numformat.format(mysumprice
                            .reduce((value, element) => (value) + element)),
                        style: TextConstants.textstyle,
                      ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Text(
              "บาท",
              style: TextConstants.textstyle,
            ),
          ),
        ],
      ),
    );
  }

  Widget note() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox(
        child: stringpreferences1?[1] == "ADMIN"
            ? Text(
                notes.text,
                style: TextConstants.textstyle,
                maxLines: 5,
              )
            : TextFormField(
                controller: notes,
                onFieldSubmitted: (value) => {
                  setState(() {
                    notes.text = value;
                  })
                },
                maxLines: 5,
                decoration: InputDecoration(
                    hintText: notes.text,
                    enabledBorder:
                        OutlineInputBorder(borderSide: BorderSide(width: 2))),
              ),
      ),
    );
  }

  Widget done() {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: TextButton(
          onPressed: () {
            int i = 0;
            if (allorderfordisplay.length == 1) {
              if (myprice[0] == 0) {
                i = 1000;
                showDialog(
                    context: context,
                    builder: (_) => new AlertDialog(
                          content: new Text("Please enter price"),
                          actions: <Widget>[
                            TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                })
                          ],
                        ));
              } else {
                if (stringpreferences1?[1] == "ADMIN") {
                  insertintonotice();
                } else {
                  btdone();
                }
              }
            } else {
              for (i = 0; i < allorderfordisplay.length; i++) {
                if (myprice[i] == 0) {
                  i = 1000;
                  showDialog(
                      context: context,
                      builder: (_) => new AlertDialog(
                            content: new Text("Please enter price"),
                            actions: <Widget>[
                              TextButton(
                                  child: Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  })
                            ],
                          ));
                } else if (myprice[i + 1] == 0) {
                  i = 1000;
                  showDialog(
                      context: context,
                      builder: (_) => new AlertDialog(
                            content: new Text("Please enter price"),
                            actions: <Widget>[
                              TextButton(
                                  child: Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  })
                            ],
                          ));
                } else {
                  i = 1000;
                  if (stringpreferences1?[1] == "ADMIN") {
                    insertintonotice();
                  } else {
                    btdone();
                  }
                }
              }
            }

////for case > 1 row
            // for (i = 0; i < allorderfordisplay.length; i++) {
            //   if (myprice[i] == 0) {
            //     i = 1000;
            //     showDialog(
            //         context: context,
            //         builder: (_) => new AlertDialog(
            //               content: new Text("Please enter price"),
            //               actions: <Widget>[
            //                 TextButton(
            //                     child: Text('OK'),
            //                     onPressed: () {
            //                       Navigator.of(context).pop();
            //                     })
            //               ],
            //             ));
            //   } else if (myprice[i + 1] == 0) {
            //     i = 1000;
            //     showDialog(
            //         context: context,
            //         builder: (_) => new AlertDialog(
            //               content: new Text("Please enter price"),
            //               actions: <Widget>[
            //                 TextButton(
            //                     child: Text('OK'),
            //                     onPressed: () {
            //                       Navigator.of(context).pop();
            //                     })
            //               ],
            //             ));
            //   } else {
            //     i = 1000;
            //     if (stringpreferences1?[1] == "ADMIN") {
            //       insertintonotice();
            //     } else {
            //       btdone();
            //     }
            //   }
            // }
          },
          child: Container(
            width: MediaQuery.of(context).size.width / 2,
            height: MediaQuery.of(context).size.height / 16,
            color: Colors.amber,
            child: Center(
              child: Text(
                "DONE",
                style: TextStyle(
                    fontFamily: 'newbodyfont',
                    fontSize: 18.sp,
                    color: Colors.black),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future btdone() async {
    try {
      String url = "http://185.78.165.189:3000/nodejsapi/updatenotes";
      var body = {
        "notes": notes.text.trim(),
        "ordernumber": widget.ordernumber,
      };
      http.Response response = await http.patch(Uri.parse(url),
          headers: {'Content-Type': 'application/json; charset=utf-8'},
          body: JsonEncoder().convert(body));

      if (response.statusCode == 200) {
        return showDialog(
            context: context,
            builder: (_) => new AlertDialog(
                  content: new Text("Update success"),
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
      } else {
        print("server error");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List<GetorderBycodestoreandcuscodeandordernumber>>
      listgetdatastore() async {
    SharedPreferences preferences1 = await SharedPreferences.getInstance();
    stringpreferences1 = preferences1.getStringList("codestore");

    String url =
        "http://185.78.165.189:3000/nodejsapi/getordersBycodestoreandcuscodeandordernumber";
    var body = {
      "codestore": stringpreferences1![0],
      "cuscode": widget.cuscode,
      "ordernumber": widget.ordernumber
    };

    http.Response response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: JsonEncoder().convert(body));

    dynamic jsonres = json.decode(response.body);
    List<GetorderBycodestoreandcuscodeandordernumber>? _allorder = [];

    for (var u in jsonres) {
      GetorderBycodestoreandcuscodeandordernumber data =
          GetorderBycodestoreandcuscodeandordernumber(
              u["ordernumber"],
              u["codeproduct"],
              u["nameproduct"],
              u["amount"],
              u["pay"],
              u["notes"],
              u["date"],
              u["price"]);
      _allorder.add(data);
    }

    return _allorder;
  }

  Future insertintonotice() async {
    try {
      String url = "http://185.78.165.189:3000/nodejsapi/insertintonotice";

      var body = {
        "ordernumber": allorderfordisplay[0].ordernumber,
        "fromwho": stringpreferences1![0],
        "fromposition": stringpreferences1![1],
        "towho": widget.cuscode,
        "toposition": "DEALER",
        "message": "adminconfirm"
      };

      http.Response response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json; charset=utf-8'},
          body: JsonEncoder().convert(body));
      updateprice();
    } catch (error) {
      print(error);
    }
  }

  Future updateprice() async {
    try {
      String url = "http://185.78.165.189:3000/nodejsapi/updateprice";

      for (var i = 0; i < allorderfordisplay.length; i++) {
        var body = {
          "price": myprice[i],
          "codeproduct": allorderfordisplay[i].codeproduct,
          "ordernumber": widget.ordernumber,
        };

        http.Response response = await http.patch(Uri.parse(url),
            headers: {'Content-Type': 'application/json; charset=utf-8'},
            body: JsonEncoder().convert(body));
      }
      return showDialog(
          context: context,
          builder: (_) => new AlertDialog(
                content: new Text("Update success"),
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
}
