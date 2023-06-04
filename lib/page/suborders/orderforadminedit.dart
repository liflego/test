// ignore_for_file: no_logic_in_create_state, unnecessary_string_interpolations, prefer_const_constructors, unnecessary_new

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sigma_space/classapi/class.dart';
import 'package:sigma_space/main.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'dart:io' as io;

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

  final numformat = new NumberFormat("#,##0.00", "en_US");
  bool toggle1 = false;
  bool toggle2 = false;
  bool togglecal = false;
  bool togglevat = false;
  bool togglechooseall = false;
  int toggleaddstep = 0;
  List<bool>? togglechoose = [];
  List<double>? listgetprice = [];
  List<double>? listgetpricevat = [];
  TextEditingController step1 = TextEditingController();
  TextEditingController step2 = TextEditingController();
  TextEditingController step3 = TextEditingController();
  io.File? selectedImage;
  String? getnameimg;
  @override
  void initState() {
    listgetdatastore().then((value) {
      setState(() {
        allorder.addAll(value);
        allorderfordisplay = allorder;
        notes.text = allorderfordisplay[0].notes;

        for (int i = 0; i < allorderfordisplay.length; i++) {
          togglechoose!.add(false);
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
                actions: [
                  IconButton(
                      onPressed: () {
                        if (togglecal == false) {
                          setState(() {
                            togglecal = true;
                          });
                        } else {
                          setState(() {
                            togglecal = false;
                            listgetprice!.clear();
                            listgetpricevat!.clear();
                          });
                        }
                      },
                      icon: Icon(
                        Icons.calculate_rounded,
                        size: 20.sp,
                        color: Colors.white,
                      )),
                ],
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
                  togglecal == true ? chooseall() : SizedBox(),
                  SizedBox(height: 5.sp),
                  Container(
                    color: Colors.grey[200],
                    height: MediaQuery.of(context).size.height / 2.4,
                    child: listitems(),
                  ),
                  textpriceall(),
                  note(),
                  selectimage(),
                  done()
                ],
              )));
    });
  }

  Widget chooseall() {
    return Padding(
      padding: EdgeInsets.all(2),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      if (toggleaddstep == 0) {
                        setState(() {
                          toggleaddstep = 0;
                        });
                      } else {
                        setState(() {
                          toggleaddstep = toggleaddstep - 1;
                        });
                      }
                      print(toggleaddstep);
                    });
                  },
                  icon: Icon(
                    Icons.remove_circle_outline_outlined,
                    color: Colors.black,
                  )),
              SizedBox(
                  width: 50.sp,
                  height: 25.sp,
                  child: TextFormField(
                    onChanged: (String value) {
                      setState(() {
                        step1.text = value;
                      });
                    },
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: HexColor('#39474F'), width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.yellow.shade800, width: 2),
                      ),
                    ),
                  )),
              Text(
                "%",
                style: TextConstants.textstyleforheader,
              ),
              IconButton(
                  onPressed: () {
                    if (toggleaddstep >= 3) {
                      setState(() {
                        toggleaddstep = 3;
                      });
                    } else {
                      setState(() {
                        toggleaddstep = toggleaddstep + 1;
                      });
                    }
                    print(toggleaddstep);
                  },
                  icon: Icon(
                    Icons.add_box_outlined,
                    color: Colors.black,
                  )),
            ],
          ),
          toggleaddstep >= 1
              ? Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: 50.sp,
                            height: 25.sp,
                            child: TextFormField(
                              onChanged: (String value) {
                                setState(() {
                                  step2.text = value;
                                });
                              },
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: HexColor('#39474F'), width: 2),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.yellow.shade800, width: 2),
                                ),
                              ),
                            )),
                        Text(
                          "%",
                          style: TextConstants.textstyleforheader,
                        ),
                      ],
                    ),
                  ],
                )
              : SizedBox(),
          toggleaddstep >= 2
              ? Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              width: 50.sp,
                              height: 25.sp,
                              child: TextFormField(
                                onChanged: (String value) {
                                  setState(() {
                                    step3.text = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: HexColor('#39474F'), width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.yellow.shade800,
                                        width: 2),
                                  ),
                                ),
                              )),
                          Text(
                            "%",
                            style: TextConstants.textstyleforheader,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : SizedBox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "VAT",
                style: TextConstants.textstyle,
              ),
              IconButton(
                  onPressed: () {
                    setState(() {
                      if (togglevat == false) {
                        togglevat = true;
                        if (listgetprice!.isEmpty) {
                          return;
                        } else {
                          for (int i = 0; i < listgetprice!.length; i++) {
                            setState(() {
                              listgetpricevat!.add(listgetprice![i] +
                                  (listgetprice![i] * 7 / 100));
                            });
                          }
                        }
                      } else {
                        togglevat = false;
                        setState(() {
                          listgetpricevat!.clear();
                        });
                      }
                    });
                  },
                  icon: togglevat == true
                      ? Icon(
                          Icons.check_box_outlined,
                          color: Colors.black,
                        )
                      : Icon(
                          Icons.check_box_outline_blank,
                          color: Colors.black,
                        ))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "เลือกทั้งหมด",
                style: TextConstants.textstyle,
              ),
              IconButton(
                  onPressed: () {
                    setState(() {
                      if (togglechooseall == false) {
                        togglechooseall = true;
                        for (int i = 0; i < allorderfordisplay.length; i++) {
                          setState(() {
                            togglechoose![i] = true;
                          });
                        }

                        listgetprice!.clear();
                        listgetpricevat!.clear();
                        //แอดราคาทั้งหมดใน listgetprice
                        if (toggleaddstep == 1) {
                          for (int i = 0; i < allorderfordisplay.length; i++) {
                            var value = ((double.parse(allorderfordisplay[i]
                                    .getprice
                                    .toStringAsFixed(2)) -
                                (double.parse((allorderfordisplay[i].getprice)
                                            .toStringAsFixed(2)) *
                                        int.parse(step1.text)) /
                                    100));

                            var value2 =
                                ((double.parse(value.toStringAsFixed(2)) -
                                    (double.parse((value).toStringAsFixed(2)) *
                                            int.parse(step2.text)) /
                                        100));

                            setState(() {
                              listgetprice!
                                  .add(value2 * allorderfordisplay[i].amount);
                            });
                          }
                        } else if (toggleaddstep == 2) {
                          for (int i = 0; i < allorderfordisplay.length; i++) {
                            var value = ((double.parse(allorderfordisplay[i]
                                    .getprice
                                    .toStringAsFixed(2)) -
                                (double.parse((allorderfordisplay[i].getprice)
                                            .toStringAsFixed(2)) *
                                        int.parse(step1.text)) /
                                    100));

                            var value2 =
                                ((double.parse(value.toStringAsFixed(2)) -
                                    (double.parse((value).toStringAsFixed(2)) *
                                            int.parse(step2.text)) /
                                        100));
                            var value3 =
                                ((double.parse(value2.toStringAsFixed(2)) -
                                    (double.parse((value2).toStringAsFixed(2)) *
                                            int.parse(step3.text)) /
                                        100));

                            setState(() {
                              listgetprice!
                                  .add(value3 * allorderfordisplay[i].amount);
                            });
                          }
                        } else {
                          //togglestep != 1
                          for (int i = 0; i < allorderfordisplay.length; i++) {
                            var value = ((double.parse(allorderfordisplay[i]
                                    .getprice
                                    .toStringAsFixed(2)) -
                                (double.parse((allorderfordisplay[i].getprice)
                                            .toStringAsFixed(2)) *
                                        int.parse(step1.text)) /
                                    100));
                            listgetprice!
                                .add(value * allorderfordisplay[i].amount);
                          }
                        }
                        if (togglevat == true) {
                          for (int i = 0; i < listgetprice!.length; i++) {
                            setState(() {
                              listgetpricevat!.add(listgetprice![i] +
                                  (listgetprice![i] * 7 / 100));
                            });
                          }
                        } else {
                          return;
                        }
                      } else {
                        togglechooseall = false;
                        listgetprice!.clear();
                        listgetpricevat!.clear();
                        for (int i = 0; i < allorderfordisplay.length; i++) {
                          setState(() {
                            togglechoose![i] = false;
                          });
                        }
                        listgetprice!.clear();
                        listgetpricevat!.clear();
                        for (int i = 0; i < allorderfordisplay.length; i++) {
                          listgetprice!.add(0);
                          listgetpricevat!.add(0);
                        }
                      }
                    });
                  },
                  icon: togglechooseall == true
                      ? Icon(
                          Icons.check_box_outlined,
                          color: Colors.black,
                        )
                      : Icon(
                          Icons.check_box_outline_blank,
                          color: Colors.black,
                        ))
            ],
          ),
        ],
      ),
    );
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
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
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      "ราคา ${allorderfordisplay[index].getprice}",
                                      style: TextConstants.textstyle),
                                  togglecal == true &&
                                          listgetprice!.isNotEmpty &&
                                          togglevat == false &&
                                          togglechooseall == true
                                      ? Text(
                                          "รวม " +
                                              listgetprice![index]
                                                  .toStringAsFixed(2),
                                          style: TextStyle(
                                            fontFamily: 'newbodyfont',
                                            fontSize: 18.sp,
                                          ))
                                      : togglevat == true &&
                                              togglecal == true &&
                                              listgetpricevat!.isNotEmpty &&
                                              togglechooseall == true
                                          ? Text(
                                              "รวม " +
                                                  listgetpricevat![index]
                                                      .toStringAsFixed(2),
                                              style: TextStyle(
                                                fontFamily: 'newbodyfont',
                                                fontSize: 18.sp,
                                              ))
                                          : togglecal == true &&
                                                  listgetprice!.isNotEmpty &&
                                                  togglevat == false &&
                                                  togglechooseall == false &&
                                                  togglechoose![index] == true
                                              //แสดงค่าหน้าแอพ ส่วนของการเลือกทีละอัน
                                              ? Text(
                                                  "รวม " +
                                                      listgetprice![index]
                                                          .toStringAsFixed(2),
                                                  style: TextStyle(
                                                    fontFamily: 'newbodyfont',
                                                    fontSize: 18.sp,
                                                  ))
                                              : togglecal == true &&
                                                      listgetprice!
                                                          .isNotEmpty &&
                                                      togglevat == true &&
                                                      togglechooseall ==
                                                          false &&
                                                      togglechoose![index] ==
                                                          true
                                                  ? Text(
                                                      "รวม " +
                                                          listgetpricevat![
                                                                  index]
                                                              .toStringAsFixed(
                                                                  2),
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'newbodyfont',
                                                        fontSize: 18.sp,
                                                      ))
                                                  : SizedBox(),
                                ],
                              ),
                            ),
                          ],
                        ),
                        togglecal == true
                            ? IconButton(
                                onPressed: () {
                                  //ส่วนของการเลือกทีละอัน
                                  if (togglechoose![index] == false) {
                                    setState(() {
                                      //when select bool will be true
                                      if (listgetprice!.isEmpty) {
                                        for (int i = 0;
                                            i < allorderfordisplay.length;
                                            i++) {
                                          listgetprice!.add(0);
                                          listgetpricevat!.add(0);
                                        }
                                      }

                                      var value = (double.parse(
                                              allorderfordisplay[index]
                                                  .getprice
                                                  .toStringAsFixed(2)) -
                                          (double.parse(
                                                      (allorderfordisplay[index]
                                                              .getprice)
                                                          .toStringAsFixed(2)) *
                                                  int.parse(step1.text)) /
                                              100);
                                      togglechoose![index] = true;
                                      listgetprice![index] = value *
                                          double.parse(allorderfordisplay[index]
                                              .amount
                                              .toStringAsFixed(2));

                                      if (toggleaddstep == 1) {
                                        var value2 = ((double.parse(
                                                value.toStringAsFixed(2)) -
                                            (double.parse((value)
                                                        .toStringAsFixed(2)) *
                                                    int.parse(step2.text)) /
                                                100));

                                        setState(() {
                                          listgetprice![index] = value2 *
                                              allorderfordisplay[index].amount;
                                        });
                                      } else {
                                        setState(() {
                                          listgetprice![index] = 0;
                                          listgetprice![index] = value *
                                              allorderfordisplay[index].amount;
                                        });
                                      }
                                      if (listgetpricevat!.isNotEmpty) {
                                        listgetpricevat![index] =
                                            (listgetprice![index] +
                                                (listgetprice![index] *
                                                    7 /
                                                    100));
                                      }
                                    });
                                  } else {
                                    setState(() {
                                      togglechoose![index] = false;
                                      listgetprice![index] = 0;
                                      if (listgetpricevat!.isNotEmpty) {
                                        listgetpricevat![index] = 0;
                                      }
                                    });
                                  }
                                },
                                icon: togglechoose![index] == true
                                    ? Icon(
                                        Icons.check_box_outlined,
                                        color: Colors.black,
                                      )
                                    : Icon(
                                        Icons.check_box_outline_blank,
                                        color: Colors.black,
                                      ))
                            : SizedBox()
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

  Widget textpriceall() {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Center(
          child: togglecal == false
              ? SizedBox()
              : togglevat == true
                  ? listgetpricevat!.isNotEmpty
                      ? Text(
                          "ราคารวม " +
                              listgetpricevat!
                                  .reduce((value, element) => (value) + element)
                                  .toStringAsFixed(2),
                          style: TextConstants.textstyle,
                        )
                      : Text("ราคารวม", style: TextConstants.textstyle)
                  : listgetprice!.isNotEmpty
                      ? Text(
                          "ราคารวม " +
                              listgetprice!
                                  .reduce((value, element) => (value) + element)
                                  .toStringAsFixed(2),
                          style: TextConstants.textstyle,
                        )
                      : Text("ราคารวม", style: TextConstants.textstyle)),
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

  Widget selectimage() {
    return Padding(
        padding: EdgeInsets.all(5),
        child: Center(
            child: Column(children: [
          selectedImage == null
              ? Text(
                  "UPLOAD IMAGE",
                  style: TextConstants.textStylenotes,
                )
              : Image.file(
                  selectedImage!,
                  width: 90.sp,
                  height: 90.sp,
                ),
          TextButton.icon(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(ColorConstants.buttoncolor)),
              onPressed: getImage,
              icon: Icon(Icons.upload),
              label: Text(
                "UPLOAD",
                style: TextConstants.textstyle,
              ))
        ])));
  }

  Future getImage() async {
    // ignore: deprecated_member_use
    final pickimage = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickimage == null) {
      return;
    } else {
      selectedImage = io.File(pickimage!.path);
      setState(() {
        getnameimg = selectedImage!.path.split('/').last.toString();
      });
    }
  }

  Widget done() {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: TextButton(
          onPressed: () {
            updateadminconfirm();
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
      String url = "http://185.78.165.189:3000/pythonapi/updatenotes";
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
        "http://185.78.165.189:3000/pythonapi/getordersBycodestoreandcuscodeandordernumber";
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
              u["getprice"],
              u["pay"],
              u["notes"],
              u["date"],
              u["price"]);
      _allorder.add(data);
    }

    return _allorder;
  }

  Future updateadminconfirm() async {
    try {
      String url = "http://185.78.165.189:3000/pythonapi/updatenoti";

      var body = {
        "message": "adminconfirm",
        "ordernumber": allorderfordisplay[0].ordernumber,
        "date": DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
      };

      http.Response response = await http.patch(Uri.parse(url),
          headers: {'Content-Type': 'application/json; charset=utf-8'},
          body: JsonEncoder().convert(body));
      updateprice();
      if (selectedImage != null) {
        onUploadImage();
      }
    } catch (error) {
      print(error);
    }
  }

  onUploadImage() async {
    SharedPreferences preferences1 = await SharedPreferences.getInstance();
    stringpreferences1 = preferences1.getStringList("codestore");
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("http://185.78.165.189:3000/pythonapi/uploadimgdelivery"),
    );
    Map<String, String> headers = {"Content-type": "multipart/form-data"};
    request.files.add(
      http.MultipartFile(
        'image',
        selectedImage!.readAsBytes().asStream(),
        selectedImage!.lengthSync(),
        filename: selectedImage!.path.split('/').last,
      ),
    );
    request.headers.addAll(headers);
    var res = await request.send();
    http.Response response = await http.Response.fromStream(res);
    setState(() {
      var resJson = jsonDecode(response.body);
      selectedImage = null;
    });
  }

  Future updateprice() async {
    try {
      String url = "http://185.78.165.189:3000/pythonapi/updateprice";

      List<double> price = [];
      if (togglevat == true) {
        price = listgetpricevat!;
      } else {
        price = listgetprice!;
      }
      for (var i = 0; i < allorderfordisplay.length; i++) {
        var body = {
          "price": price[i],
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
