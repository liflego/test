import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sigma_space/classapi/class.dart';
import 'package:sigma_space/main.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class storehis extends StatefulWidget {
  List<String> cusdata;
  storehis({Key? key, required this.cusdata}) : super(key: key);

  @override
  _storehisState createState() => _storehisState();
}

class _storehisState extends State<storehis> {
  List<String>? stringpreferences1;
  List<GetorderBycodestoreandcuscodeandordernumber> allorder = [];
  List<GetorderBycodestoreandcuscodeandordernumber> allorderfordisplay = [];
  TextEditingController notes = TextEditingController();
  TextEditingController score = TextEditingController();

  var refreshkey = GlobalKey<RefreshIndicatorState>();

  var grouptype = [];

  @override
  void initState() {
    makegrouporder().then((value) {
      setState(() {
        allorder.addAll(value);
        allorderfordisplay = allorder;
      });
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return SafeArea(
          top: false,
          child: Scaffold(
            appBar: AppBar(
              leading: new BackButton(
                onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => MyApp())),
              ),
              backgroundColor: ColorConstants.appbarcolor,
              toolbarHeight: 7.h,
              title: Text(
                "STORE",
                style: TextStyle(fontFamily: 'newtitlefont', fontSize: 25.sp),
              ),
            ),
            backgroundColor: ColorConstants.backgroundbody,
            //แก้ตรงนี้
            body: ListView(children: [
              showdata(),
              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "History :",
                    style: TextStyle(
                        fontSize: 22.sp,
                        fontFamily: 'newbodyfont',
                        color: Colors.black),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return listItem(index);
                  },
                  itemCount: grouptype.length,
                ),
              ),
            ]),
          ));
    });
  }

  Widget showdata() {
    return widget.cusdata[2] != null
        ? Card(
            elevation: 5,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 4.25,
              child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.cusdata[1],
                        style: TextConstants.textstyleforheader,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.cusdata[2],
                              style: TextConstants.textstyle),
                          SizedBox(
                            width: 5.w,
                            height: 3.h,
                            child: TextFormField(
                              controller: score,
                              onFieldSubmitted: (value) => {
                                setState(() {
                                  score.text = value;
                                  updatescore();
                                })
                              },
                              maxLines: 1,
                              decoration: InputDecoration(
                                  labelText:
                                      "Score : " + widget.cusdata[5].toString(),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none)),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            widget.cusdata[3],
                            style: TextConstants.textstyle,
                          ),
                          Transform.scale(
                            scaleX: -1,
                            child: IconButton(
                                onPressed: () {
                                  _launchPhoneURL();
                                },
                                icon: Icon(
                                  Icons.call,
                                  color: Colors.blue,
                                  size: 15.sp,
                                )),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 7.h,
                        child: Center(
                          child: TextFormField(
                            controller: notes,
                            onFieldSubmitted: (value) => {
                              setState(() {
                                notes.text = value;
                              })
                            },
                            maxLines: 1,
                            maxLength: 30,
                            decoration: InputDecoration(
                                hintStyle: TextConstants.textstyle,
                                hintText: widget.cusdata[4],
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1))),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          )
        : Card(
            elevation: 5,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 4.25,
              child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.cusdata[1],
                        style: TextConstants.textstyleforheader,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text(widget.cusdata[2],
                      //         style: TextConstants.textstyle),
                      //     SizedBox(
                      //       width: 5.w,
                      //       height: 3.h,
                      //       child: TextFormField(
                      //         controller: score,
                      //         onFieldSubmitted: (value) => {
                      //           setState(() {
                      //             score.text = value;
                      //             updatescore();
                      //           })
                      //         },
                      //         maxLines: 1,
                      //         decoration: InputDecoration(
                      //             labelText:
                      //                 "Score : " + widget.cusdata[5].toString(),
                      //             enabledBorder: OutlineInputBorder(
                      //                 borderSide: BorderSide.none)),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            widget.cusdata[3],
                            style: TextConstants.textstyle,
                          ),
                          Transform.scale(
                            scaleX: -1,
                            child: IconButton(
                                onPressed: () {
                                  _launchPhoneURL();
                                },
                                icon: Icon(
                                  Icons.call,
                                  color: Colors.blue,
                                  size: 15.sp,
                                )),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 7.h,
                        child: Center(
                          child: TextFormField(
                            controller: notes,
                            onFieldSubmitted: (value) => {
                              setState(() {
                                notes.text = value;
                              })
                            },
                            maxLines: 1,
                            maxLength: 30,
                            decoration: InputDecoration(
                                hintStyle: TextConstants.textstyle,
                                hintText: widget.cusdata[4],
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1))),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          );
  }

  Widget listItem(index) {
    List<String> paymethod = [];
    List<String> codeproduct = [];
    List<String> nameproduct = [];
    List<String> amount = [];
    List<String> datelist = [];

    Iterable<GetorderBycodestoreandcuscodeandordernumber> visi =
        allorderfordisplay.where((pay) =>
            pay.ordernumber.toString().contains(grouptype[index].toString()));
    visi.forEach((pay) => paymethod.add(pay.pay));

    Iterable<GetorderBycodestoreandcuscodeandordernumber> visicode =
        allorderfordisplay.where((code) =>
            code.ordernumber.toString().contains(grouptype[index].toString()));
    visicode.forEach((code) => codeproduct.add(code.codeproduct));

    Iterable<GetorderBycodestoreandcuscodeandordernumber> visiname =
        allorderfordisplay.where((name) =>
            name.ordernumber.toString().contains(grouptype[index].toString()));
    visiname.forEach((name) => nameproduct.add(name.nameproduct));

    Iterable<GetorderBycodestoreandcuscodeandordernumber> visinumber =
        allorderfordisplay.where((number) => number.ordernumber
            .toString()
            .contains(grouptype[index].toString()));
    visinumber.forEach((number) => amount.add(number.amount.toString()));

    Iterable<GetorderBycodestoreandcuscodeandordernumber> visidate =
        allorderfordisplay.where((date) =>
            date.ordernumber.toString().contains(grouptype[index].toString()));
    visidate.forEach((date) => datelist.add(date.date));

    return Padding(
      padding: EdgeInsets.all(5),
      child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Card(
            elevation: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.grey[100],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "คำสั่งซื้อที่ ${grouptype[index]}",
                              style: TextConstants.textstyle,
                            ),
                            Text(
                              datelist[0].substring(5, 25),
                              style: TextConstants.textstyle,
                            ),
                          ],
                        ),
                        Text(
                          "(${paymethod.length} รายการ)",
                          style: TextConstants.textstyle,
                        ),
                        Text(
                          "วิธีการชำระ ${paymethod[0]}",
                          style: TextConstants.textstyle,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                SizedBox(
                  height: 15.h,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ListView.builder(
                      itemCount: codeproduct.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.circle,
                                  size: 8.sp,
                                ),
                                Text(
                                  " " + nameproduct[index],
                                  style: TextConstants.textstyleforhistory,
                                ),
                              ],
                            ),
                            Text(
                              "(${codeproduct[index]})",
                              style: TextConstants.textstyleforhistory,
                            ),
                            Text(
                              "จำนวน ${amount[index]}",
                              style: TextConstants.textstyleforhistory,
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Future<List<GetorderBycodestoreandcuscodeandordernumber>>
      makegrouporder() async {
    SharedPreferences preferences1 = await SharedPreferences.getInstance();
    stringpreferences1 = preferences1.getStringList("codestore");

    String url =
        "http://185.78.165.189:3000/pythonapi/getordersbycodestoreandcuscode";
    var body = {
      "codestore": stringpreferences1![0],
      "cuscode": widget.cusdata[0],
    };

    http.Response response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: JsonEncoder().convert(body));

    dynamic jsonres = json.decode(response.body);

    List getgrouptype = [];

    List<GetorderBycodestoreandcuscodeandordernumber> aaa = [];
    for (var u in jsonres) {
      GetorderBycodestoreandcuscodeandordernumber data =
          GetorderBycodestoreandcuscodeandordernumber(
        u["ordernumber"],
        u["codeproduct"],
        u["nameproduct"],
        u["amount"],
        u["getprice"],
        u["pay"],
        u["notes"],
        u["date"],
        u["price"],
      );
      aaa.add(data);
      getgrouptype.add(u["ordernumber"]);
    }

    grouptype = LinkedHashSet<int>.from(getgrouptype).toList();

    return aaa;
  }

  _launchPhoneURL() async {
    String url = ('tel:' + widget.cusdata[3]);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future updatescore() async {
    try {
      SharedPreferences preferences1 = await SharedPreferences.getInstance();
      stringpreferences1 = preferences1.getStringList("codestore");

      String url = "http://185.78.165.189:3000/pythonapi/updatecustomerscore";
      var body = {
        "score": score.text.trim(),
        "cuscode": widget.cusdata[0],
        "codestore": stringpreferences1![0]
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
