// ignore_for_file: no_logic_in_create_state, unnecessary_string_interpolations, prefer_const_constructors, unnecessary_new

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
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

class orderfromsellandcus extends StatefulWidget {
  List<String> codeorder = [];
  List<String> nameorder = [];
  List<String> numorder = [];
  List<String> numpercrate = [];
  List<String> productset = [];
  String position;

  orderfromsellandcus(
      {Key? key,
      required this.codeorder,
      required this.nameorder,
      required this.numorder,
      required this.numpercrate,
      required this.productset,
      required this.position})
      : super(key: key);

  @override
  _orderfromsellandcus createState() => _orderfromsellandcus();
}

class _orderfromsellandcus extends State<orderfromsellandcus> {
  @override
  TextEditingController mysearh = TextEditingController();
  TextEditingController notes = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  late String pay;

  @override
  void initState() {
    mysearh.addListener(_printLatestValue);
    super.initState();
  }

  _printLatestValue() {
    print("text field: ${mysearh.text}");
  }

  bool toggle1 = false;
  bool toggle2 = false;
  List<String>? stringpreferences1;

  List<Getcustomerstore> alldata = [];
  late int lastorder;
  @override
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
                actions: [
                  IconButton(
                      onPressed: backtostock,
                      icon: Icon(
                        Icons.add_circle,
                        size: 20.sp,
                        color: Colors.white,
                      ))
                ],
                toolbarHeight: 7.h,
                title: widget.position == "DEALER"
                    ? Text(
                        "ORDERS",
                        style: TextConstants.appbartextsyle,
                      )
                    : Container(
                        color: Color.fromARGB(255, 5, 61, 110),
                        child: Row(
                          children: [
                            Icon(Icons.search),
                            Padding(padding: EdgeInsets.only(left: 3.0.sp)),
                            tabsearch(),
                          ],
                        )),
                backgroundColor: ColorConstants.appbarcolor,
              ),
              body: ListView(
                children: [
                  Container(
                    color: Colors.amber,
                    height: MediaQuery.of(context).size.height / 2,
                    child: listitems(),
                  ),
                  data()
                ],
              )));
    });
  }

  Widget tabsearch() {
    return Expanded(
      child: TextFieldSearch(
          label: '',
          textStyle: TextStyle(
              color: Colors.white, fontFamily: "newtitlefont", fontSize: 20.sp),
          controller: mysearh,
          decoration: InputDecoration(
            hintText: "เลือกร้านค้า",
            hintStyle: TextStyle(color: Colors.white),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: HexColor('#1034A6')),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          future: () {
            return fetchSimpleData();
          }),
    );
  }

  Widget listitems() {
    return Padding(
      padding: EdgeInsets.all(2.0),
      child: ListView.builder(
        itemCount: widget.codeorder.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.nameorder[index],
                            maxLines: 3,
                            style: TextStyle(
                                fontFamily: 'newbodyfont', fontSize: 18.sp)),
                        Text(widget.codeorder[index],
                            style: TextStyle(
                              fontFamily: 'newbodyfont',
                              fontSize: 18.sp,
                            )),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: TextFormField(
                            style: TextStyle(
                                fontFamily: 'newbodyfont',
                                fontSize: 18.sp,
                                color: Colors.black),
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                                hintText: widget.numorder[index] +
                                    "(" +
                                    // ignore: division_optimization
                                    (int.parse("${widget.numorder[index]}") /
                                            int.parse(
                                                "${widget.numpercrate[index]}"))
                                        .toInt()
                                        .toString() +
                                    widget.productset[index] +
                                    ")",
                                hintStyle: TextStyle(
                                    fontFamily: 'newbodyfont',
                                    fontSize: 18.sp,
                                    color: Colors.black)),
                            onChanged: (text) => setState(() {
                              widget.numorder[index] = text;
                            }),
                          ),
                        ),
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

  Widget data() {
    return Column(
      children: [
        SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: TextFormField(
              controller: notes,
              onFieldSubmitted: (value) => {},
              maxLines: 5,
              decoration: InputDecoration(hintText: " หมายเหตุ"),
            ),
          ),
        ),
        SizedBox(
          child: Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "วิธีชำระ",
                  style: TextStyle(
                      fontFamily: 'newbodyfont',
                      fontSize: 18.sp,
                      color: Colors.black),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        toggle1 = !toggle1;
                        toggle2 = false;
                      });
                    },
                    icon: toggle1 == false
                        ? Icon(Icons.circle_outlined)
                        : Icon(Icons.check_circle_outline)),
                Text(
                  "เงินสด",
                  style: TextStyle(
                      fontFamily: 'newbodyfont',
                      fontSize: 18.sp,
                      color: Colors.black),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        toggle2 = !toggle2;
                        toggle1 = false;
                      });
                    },
                    icon: toggle2 == false
                        ? Icon(Icons.circle_outlined)
                        : Icon(Icons.check_circle_outline)),
                Text(
                  "เครดิต",
                  style: TextStyle(
                      fontFamily: 'newbodyfont',
                      fontSize: 18.sp,
                      color: Colors.black),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: TextButton(
              onPressed: done,
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height / 16,
                color: ColorConstants.buttoncolor,
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
        )
      ],
    );
  }

  Future<List> fetchSimpleData() async {
    await Future.delayed(Duration(milliseconds: 500));
    List _list = <dynamic>[];

    // create a list from the text input of three items
    // to mock a list of items from an http call
    List<String> stringpreferences1;
    SharedPreferences preferences1 = await SharedPreferences.getInstance();
    stringpreferences1 = preferences1.getStringList("codestore")!;
    String url = "http://185.78.165.189:3000/nodejsapi/customer";
    var body = {
      "codestore": stringpreferences1[0],
    };

    http.Response response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: JsonEncoder().convert(body));

    dynamic jsonres = json.decode(response.body);

    for (var u in jsonres) {
      Getcustomerstore data = Getcustomerstore(
          u["cusname"] + "[" + u["cuscode"] + "]", u["cuscode"]);
      alldata.add(data);
      _list.add(u["cusname"] + "[" + u["cuscode"] + "]");
    }
    print(alldata[0].code);

    return _list;
  }

  Future done() async {
    //getlastorder
    String url = "http://185.78.165.189:3000/nodejsapi/getlastorders";

    http.Response response = await http.get(Uri.parse(url));
    dynamic jsonres = json.decode(response.body);
    try {
      setState(() {
        lastorder = jsonres[0]["ordernumber"] + 1;
      });
    } catch (e) {
      setState(() {
        lastorder = 1;
      });
    }

    //insert to orders
    SharedPreferences preferences1 = await SharedPreferences.getInstance();
    stringpreferences1 = preferences1.getStringList("codestore");

    try {
      String url = "http://185.78.165.189:3000/nodejsapi/insertorders";

      if ((toggle1 == true) & (toggle2 == false)) {
        setState(() {
          pay = "Cash";
        });
      } else if ((toggle1 == false) & (toggle2 == true)) {
        setState(() {
          pay = "Check";
        });
      } else {
        return showDialog(
            context: context,
            builder: (_) => new AlertDialog(
                  content: new Text("Choose payment method"),
                  actions: <Widget>[
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        deleteamount();
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ));
      }
      if (notes.text == "") {
        setState(() {
          notes.text = "-";
        });
      }
      String cuscode = "";
      Iterable<Getcustomerstore> visi = alldata.where(
          (customercode) => customercode.name.contains(mysearh.text.trim()));
      visi.forEach((customercode) => cuscode = customercode.code);
      for (var i = 0; i < widget.codeorder.length; i++) {
        var body = {
          "ordernumber": lastorder,
          "codeproduct": widget.codeorder[i].trim(),
          "nameproduct": widget.nameorder[i].trim(),
          "amount": int.parse(widget.numorder[i].trim()),
          "amountpercrate": int.parse(widget.numpercrate[i].trim()),
          "saleconfirm": 1,
          "codestore": stringpreferences1![0],
          "cuscode": cuscode.trim(),
          "date": DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
          "pay": pay.trim(),
          "notes": notes.text.trim()
        };
        http.Response response = await http.post(Uri.parse(url),
            headers: {'Content-Type': 'application/json; charset=utf-8'},
            body: JsonEncoder().convert(body));
      }
      insertintonotice();
      return showDialog(
          context: context,
          builder: (_) => new AlertDialog(
                content: new Text("Update success"),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      deleteamount();
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                        return MyApp();
                      }));
                    },
                  )
                ],
              ));
    } catch (error) {
      print(error);
    }
  }

  Future backtostock() async {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => checkstock(
              codeorder: widget.codeorder,
              nameorder: widget.nameorder,
              numorder: widget.numorder,
              numpercrate: widget.numpercrate,
              productset: widget.productset,
            )));
  }

  Future deleteamount() async {
    try {
      String url = "http://185.78.165.189:3000/nodejsapi/deleteamount";
      SharedPreferences preferences1 = await SharedPreferences.getInstance();
      stringpreferences1 = preferences1.getStringList("codestore");
      for (var i = 0; i < widget.codeorder.length; i++) {
        var body = {
          "amount": int.parse(widget.numorder[i]),
          "codeproduct": widget.codeorder[i].trim(),
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

  Future insertintonotice() async {
    try {
      String url = "http://185.78.165.189:3000/nodejsapi/insertintonotice";

      String cuscode = "";
      Iterable<Getcustomerstore> visi = alldata.where(
          (customercode) => customercode.name.contains(mysearh.text.trim()));
      visi.forEach((customercode) => cuscode = customercode.code);

      if (widget.position == "DEALER") {
        var body = {
          "ordernumber": lastorder,
          "fromwho": stringpreferences1![0],
          "fromposition": stringpreferences1![1],
          "towho": stringpreferences1![0],
          "toposition": "DEALER",
          "message": "order",
          "date": DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
        };
        http.Response response = await http.post(Uri.parse(url),
            headers: {'Content-Type': 'application/json; charset=utf-8'},
            body: JsonEncoder().convert(body));
      } else {
        var body = {
          "ordernumber": lastorder,
          "fromwho": stringpreferences1![0],
          "fromposition": stringpreferences1![1],
          "towho": cuscode,
          "toposition": "DEALER",
          "message": "order",
          "date": DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
        };
        http.Response response = await http.post(Uri.parse(url),
            headers: {'Content-Type': 'application/json; charset=utf-8'},
            body: JsonEncoder().convert(body));
      }
    } catch (error) {
      print(error);
    }
  }
}
