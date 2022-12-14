import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:intl/intl.dart';
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

class notipage extends StatefulWidget {
  notipage({Key? key}) : super(key: key);

  @override
  _notipage createState() => _notipage();
}

class _notipage extends State<notipage> {
  List<String>? stringpreferences1;
  List<Getnotifordealer> allnotice = [];
  List<Getnotifordealer> allnoticefordisplay = [];

  @override
  void initState() {
    fectalldata().then((value) {
      setState(() {
        allnotice.addAll(value);
        allnoticefordisplay = allnotice;
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
              backgroundColor: ColorConstants.appbarcolor,
              toolbarHeight: 7.h,
              title: Text(
                "NOTICE",
                style: TextStyle(fontFamily: 'newtitlefont', fontSize: 25.sp),
              ),
            ),
            backgroundColor: ColorConstants.backgroundbody,
            body: ListView(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                    itemCount: allnoticefordisplay.length,
                    itemBuilder: (BuildContext context, int index) {
                      return listitem(index);
                    },
                  ),
                )
              ],
            ),
          ));
    });
  }

  Widget listitem(index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
      child: Card(
        child: SizedBox(
          child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: allnoticefordisplay[index].message == "order"
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            color: Colors.lightGreen[900],
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Center(
                                child: Text(
                                  "????????????????????????????????????????????????",
                                  style: TextConstants.textstyleheadnotice,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "??????????????????????????????????????? " +
                                        "${allnoticefordisplay[index].namestore}",
                                    style: TextConstants.textstyle,
                                  ),
                                  Text(
                                    "???????????????(" +
                                        DateFormat("dd/MM/yyyy HH:mm:ss")
                                            .format(DateTime.parse(
                                                allnoticefordisplay[index]
                                                    .date))
                                            .substring(0, 6) +
                                        DateFormat("dd/MM/yyyy HH:mm:ss")
                                            .format(DateTime.parse(
                                                allnoticefordisplay[index]
                                                    .date))
                                            .substring(8, 16) +
                                        ")",
                                    style: TextConstants.textstyle,
                                  ),
                                ],
                              ),
                              Text(
                                "????????????????????? ${allnoticefordisplay[index].countordernumbers} ??????????????????",
                                style: TextConstants.textstyle,
                              ),
                              Text(
                                "????????????????????????????????? ${allnoticefordisplay[index].pay}",
                                style: TextConstants.textstyle,
                              ),
                              Text(
                                "???????????????????????????....?????????",
                                style: TextConstants.textstyle,
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            color: Colors.lightBlue[900],
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Center(
                                child: Text(
                                  "?????????????????????",
                                  style: TextConstants.textstyleheadnotice,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "?????????????????? " +
                                        "${allnoticefordisplay[index].namestore}",
                                    style: TextConstants.textstyle,
                                  ),
                                  Text(
                                    DateFormat("dd/MM/yyyy HH:mm:ss")
                                            .format(DateTime.parse(
                                                allnoticefordisplay[index]
                                                    .date))
                                            .substring(0, 6) +
                                        DateFormat("dd/MM/yyyy HH:mm:ss")
                                            .format(DateTime.parse(
                                                allnoticefordisplay[index]
                                                    .date))
                                            .substring(8, 16),
                                    style: TextConstants.textstyle,
                                  ),
                                ],
                              ),
                              Text(
                                "${allnoticefordisplay[index].message}",
                                style: TextConstants.textstyle,
                              ),
                            ],
                          ),
                        )
                      ],
                    )),
        ),
      ),
    );
  }

  Future<List<Getnotifordealer>> fectalldata() async {
    SharedPreferences preferences1 = await SharedPreferences.getInstance();
    stringpreferences1 = preferences1.getStringList("codestore");

    String url = "http://185.78.165.189:3000/nodejsapi/getnoticefordealer";
    var body = {"towho": stringpreferences1![0]};

    List<Getnotifordealer>? _allnotice = [];

    http.Response response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: JsonEncoder().convert(body));

    dynamic jsonres = json.decode(response.body);

    for (var u in jsonres) {
      Getnotifordealer data = Getnotifordealer(
          u["MAX(a.ordernumber)"],
          u["MAX(a.fromwho)"],
          u["MAX(a.towho)"],
          u["MAX(a.message)"],
          u["MAX(a.date)"],
          u["MAX(c.namestore)"],
          u["count(b.ordernumber)"],
          u["MAX(b.pay)"],
          u["sum(b.price*b.amount)"]);
      _allnotice.add(data);
    }

    return _allnotice;
  }
}
