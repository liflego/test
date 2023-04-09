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

class notiorderlist extends StatefulWidget {
  int ordernumber;
  String namestore;
  String date;
  int countorder;
  String pay;
  String codestore;

  notiorderlist(
      {Key? key,
      required this.ordernumber,
      required this.namestore,
      required this.date,
      required this.countorder,
      required this.pay,
      required this.codestore})
      : super(key: key);

  @override
  _notiorderlist createState() => _notiorderlist();
}

class _notiorderlist extends State<notiorderlist> {
  final _formkey = GlobalKey<FormState>();
  List<String>? stringpreferences1;
  List<GetorderBycodestoreandcuscodeandordernumber> allorder = [];
  List<GetorderBycodestoreandcuscodeandordernumber> allorderfordisplay = [];

  @override
  void initState() {
    listgetdatastore().then((value) {
      setState(() {
        allorder.addAll(value);
        allorderfordisplay = allorder;
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
                    onPressed: () async {
                      SharedPreferences pagepref =
                          await SharedPreferences.getInstance();
                      pagepref.setInt("pagepre", 1);
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
                  "LIST ORDER",
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
                                "ออเดอร์ที่ ${widget.ordernumber}",
                                style: TextConstants.textstyle,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "คำสั่งซื้อของ ${widget.namestore}",
                                style: TextConstants.textstyle,
                              ),
                              Text(
                                widget.date.substring(5, 25),
                                style: TextConstants.textstyle,
                              ),
                            ],
                          ),
                          Text(
                            "วิธีการชำระ : ${widget.pay}",
                            style: TextConstants.textstyle,
                          ),
                          Text(
                            "จำนวน ${widget.countorder} รายการ",
                            style: TextConstants.textstyle,
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      itemCount: allorderfordisplay.length,
                      itemBuilder: (BuildContext context, int index) {
                        return cardlist(index);
                      },
                    ),
                  ),
                ],
              )));
    });
  }

  Widget cardlist(index) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Card(
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
                    " รายการที่ " + "${index + 1}",
                    style: TextConstants.textstyle,
                  ),
                ],
              ),
              Text(allorderfordisplay[index].nameproduct,
                  style: TextConstants.textstyle),
              Text("(${allorderfordisplay[index].codeproduct})",
                  style: TextConstants.textstyle),
              Text("จำนวน ${allorderfordisplay[index].amount.toString()}",
                  style: TextConstants.textstyle),
              Text(
                  "ราคาต่อชิ้น ${allorderfordisplay[index].getprice.toString()} บาท",
                  style: TextConstants.textstyle),
              allorderfordisplay[index].price != null
                  ? Text(
                      "ราคารวม ${allorderfordisplay[index].price.toString()} บาท",
                      style: TextConstants.textstyle)
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  Future<List<GetorderBycodestoreandcuscodeandordernumber>>
      listgetdatastore() async {
    SharedPreferences preferences1 = await SharedPreferences.getInstance();
    stringpreferences1 = preferences1.getStringList("codestore");

    String url =
        "http://185.78.165.189:3000/pythonapi/getordersBycodestoreandcuscodeandordernumber";
    var body = {
      "codestore": widget.codestore,
      "cuscode": stringpreferences1![0],
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
              u["getprice"],
              u["pay"],
              u["notes"],
              u["date"],
              u["price"]);
      _allorder.add(data);
    }
    return _allorder;
  }
}
