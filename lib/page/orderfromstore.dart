import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sigma_space/main.dart';
import 'package:sigma_space/page/suborders/orderforadminedit.dart';
import 'package:sigma_space/page/suborders/orderforedit.dart';
import 'package:sizer/sizer.dart';
import '../classapi/class.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class orderfromstore extends StatefulWidget {
  orderfromstore({Key? key}) : super(key: key);

  @override
  _orderfromstoreState createState() => _orderfromstoreState();
}

class _orderfromstoreState extends State<orderfromstore> {
  List<String>? stringpreferences1;
  List<Getallorders> allorders = [];
  List<Getallorders> allordersfordisplay = [];

  @override
  void initState() {
    fectalldata().then((value) {
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
            backgroundColor: ColorConstants.appbarcolor,
            toolbarHeight: 7.h,
            title: Text(
              "ORDER",
              style: TextConstants.appbartextsyle,
            ),
          ),
          backgroundColor: ColorConstants.backgroundbody,
          body: ListView.builder(
            itemCount: allordersfordisplay.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Slidable(
                    endActionPane: stringpreferences1?[1] == "ADMIN"
                        // ignore: prefer_const_constructors
                        ? ActionPane(
                            motion: ScrollMotion(),

                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              Container(
                                color: Colors.green,
                                width: MediaQuery.of(context).size.width / 2,
                                height: MediaQuery.of(context).size.height,
                                child: OutlinedButton(
                                  onPressed: null,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.delivery_dining_outlined,
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
                                width: MediaQuery.of(context).size.width / 2,
                                height: MediaQuery.of(context).size.height,
                                child: OutlinedButton(
                                  onPressed: null,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                  ? Colors.lime[500]
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
                              date: DateFormat("dd/MM/yyyy HH:mm:ss")
                                      .format(DateTime.parse(
                                          allordersfordisplay[index].date))
                                      .substring(0, 6) +
                                  DateFormat("dd/MM/yyyy HH:mm:ss")
                                      .format(DateTime.parse(
                                          allordersfordisplay[index].date))
                                      .substring(8, 16),
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
                              date: DateFormat("dd/MM/yyyy HH:mm:ss")
                                      .format(DateTime.parse(
                                          allordersfordisplay[index].date))
                                      .substring(0, 6) +
                                  DateFormat("dd/MM/yyyy HH:mm:ss")
                                      .format(DateTime.parse(
                                          allordersfordisplay[index].date))
                                      .substring(8, 16),
                            );
                          }));
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${allordersfordisplay[index].cusname}",
                                maxLines: 2,
                                style: TextStyle(
                                    fontSize: 20.0.sp,
                                    fontFamily: 'newbodyfont',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              Text(
                                DateFormat("dd/MM/yyyy HH:mm:ss")
                                        .format(DateTime.parse(
                                            allordersfordisplay[index].date))
                                        .substring(0, 6) +
                                    DateFormat("dd/MM/yyyy HH:mm:ss")
                                        .format(DateTime.parse(
                                            allordersfordisplay[index].date))
                                        .substring(8, 16),
                                style: TextConstants.textstyle,
                              ),
                            ],
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
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }

  Future addamount() async {
    try {
      String url = "http://185.78.165.189:3000/nodejsapi/addamount";
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
    String url = "http://185.78.165.189:3000/nodejsapi/getallorders";
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
          u["MAX(a.ordernumber)"],
          u["MAX(a.cuscode)"],
          u["MAX(b.cusname)"],
          u["MAX(a.pay)"],
          u["count(a.ordernumber)"],
          u["MAX(a.date)"],
          u["MAX(a.saleconfirm)"],
          u["MAX(a.price)"]);
      _allorders.add(data);
      getgrouptype.add(u["type"]);
    }

    return _allorders;
  }

  Future popupforupdatedelivery() async {
    print("Aaa");
  }
}
