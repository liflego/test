import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sigma_space/classapi/class.dart';
import 'package:sigma_space/login.dart';
import 'package:sigma_space/main.dart';
import 'package:sigma_space/page/subupdate/addnewproduct.dart';
import 'package:sizer/sizer.dart';
import 'dart:io' as io;

class updatepage extends StatefulWidget {
  String codeproduct;
  String nameproduct;
  String type;
  String pdpd;
  int score;
  int amount;
  int amountper;
  int price;
  String pathimg;
  String nameimg;

  updatepage(
      {Key? key,
      required this.codeproduct,
      required this.nameproduct,
      required this.type,
      required this.pdpd,
      required this.score,
      required this.amount,
      required this.amountper,
      required this.price,
      required this.pathimg,
      required this.nameimg})
      : super(key: key);

  @override
  _updatepage createState() => _updatepage();
}

class _updatepage extends State<updatepage> {
  @override
  List<dynamic>? allproductfordisplay = [];
  TextEditingController score = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController price = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  List<String>? stringpreferences1;
  io.File? selectedImage;
  String? getnameimg;
  var resJson;
  int toggle = 0;
  int toggle1 = 0;
  int toggle2 = 0;

  void initState() {
    score.text = widget.score.toString();
    amount.text = "0";
    price.text = widget.price.toString();
    getnameimg = widget.nameimg;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return SafeArea(
          top: false,
          child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 7.h,
              title: Text(
                "UPDATE",
                style: TextStyle(fontFamily: 'newtitlefont', fontSize: 25.sp),
              ),
              backgroundColor: ColorConstants.appbarcolor,
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
            ),
            backgroundColor: ColorConstants.backgroundbody,
            body: Form(
              key: _formkey,
              child: ListView(children: [
                SizedBox(child: listitem()),
                update(),
                selectimage(),
                buttondone()
              ]),
            ),
          ),
        );
      },
    );
  }

  Widget update() {
    return Padding(
        padding: EdgeInsets.all(8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "EDIT :",
            style: TextStyle(
                fontSize: 20.sp,
                fontFamily: 'newbodyfont',
                color: Colors.black),
          ),
          //toggle check
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  child: Text("แก้ไขคะแนน :", style: TextConstants.textstyle)),
              IconButton(
                  onPressed: () {
                    setState(() {
                      if (toggle == 0) {
                        toggle = 1;
                      } else {
                        toggle = 0;
                      }
                      print(toggle);
                    });
                  },
                  icon: Icon(Icons.arrow_drop_down)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                toggle == 0
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                      )
                    : SizedBox(
                        child: Row(
                          children: [
                            Text(
                              "Score :",
                              style: TextConstants.textstyle,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 3,
                                child: TextFormField(
                                  onChanged: (value) {
                                    setState(() {
                                      score.text = value;
                                    });
                                  },
                                  style: TextStyle(
                                      fontSize: 20.sp,
                                      fontFamily: 'newbodyfont',
                                      color: Colors.black),
                                  textAlign: TextAlign.start,
                                  decoration: InputDecoration(
                                    hintText: "${widget.score}",
                                    hintStyle: TextStyle(fontSize: 20.0.sp),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide: BorderSide(
                                          color: HexColor('#39474F'), width: 1),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(
                                          color: Colors.yellow.shade800,
                                          width: 2),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  child: Text("เพิ่มจำนวนสินค้า :",
                      style: TextConstants.textstyle)),
              IconButton(
                  onPressed: () {
                    setState(() {
                      if (toggle1 == 0) {
                        toggle1 = 1;
                      } else {
                        toggle1 = 0;
                      }
                      print(toggle1);
                    });
                  },
                  icon: Icon(Icons.arrow_drop_down)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                toggle1 == 0
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                      )
                    : SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "จำนวน :",
                              style: TextConstants.textstyle,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 3,
                                child: TextFormField(
                                  onChanged: (value) {
                                    setState(() {
                                      amount.text = value;
                                    });
                                  },
                                  style: TextStyle(
                                      fontSize: 20.sp,
                                      fontFamily: 'newbodyfont',
                                      color: Colors.black),
                                  textAlign: TextAlign.start,
                                  decoration: InputDecoration(
                                    helperText: "จำนวนที่ต้องการเพิ่ม",
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide: BorderSide(
                                          color: HexColor('#39474F'), width: 1),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide: BorderSide(
                                          color: Colors.yellow.shade800,
                                          width: 2),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  child: Text("แก้ไขราคา :", style: TextConstants.textstyle)),
              IconButton(
                  onPressed: () {
                    setState(() {
                      if (toggle2 == 0) {
                        toggle2 = 1;
                      } else {
                        toggle2 = 0;
                      }
                      print(toggle2);
                    });
                  },
                  icon: Icon(Icons.arrow_drop_down)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                toggle2 == 0
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                      )
                    : SizedBox(
                        child: Row(
                          children: [
                            Text(
                              "Price :",
                              style: TextConstants.textstyle,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 3,
                                child: TextFormField(
                                  onChanged: (value) {
                                    setState(() {
                                      price.text = value;
                                    });
                                  },
                                  style: TextStyle(
                                      fontSize: 20.sp,
                                      fontFamily: 'newbodyfont',
                                      color: Colors.black),
                                  textAlign: TextAlign.start,
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide: BorderSide(
                                          color: HexColor('#39474F'), width: 1),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(
                                          color: Colors.yellow.shade800,
                                          width: 2),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ]));
  }

  Widget selectimage() {
    return Padding(
        padding: EdgeInsets.all(5),
        child: Center(
            child: Column(children: [
          selectedImage == null
              ? Text(
                  "Select Image for Uploade",
                  style: TextConstants.textStylenotes,
                )
              : Image.file(selectedImage!),
          TextButton.icon(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(ColorConstants.buttoncolor)),
              onPressed: getImage,
              icon: Icon(Icons.upload),
              label: Text(
                "Upload",
                style: TextConstants.textstyle,
              ))
        ])));
  }

  Widget buttondone() {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.circular(
            10.0,
          ),
        ),
        child: TextButton(
          onPressed: updateamountproduct,
          child: Text(
            "DONE",
            style: TextStyle(
                fontSize: 20.sp,
                fontFamily: 'newbodyfont',
                color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget listitem() {
    return Card(
        elevation: 2,
        color: widget.score == 4
            ? ColorConstants.sc4
            : widget.score == 3
                ? ColorConstants.sc3
                : widget.score == 2
                    ? ColorConstants.sc2
                    : Colors.grey[50],
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 1.h, vertical: 0.w),
          child: SingleChildScrollView(
            child: SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            Text(
                              widget.nameproduct +
                                  "(" +
                                  widget.type +
                                  "ละ" +
                                  "${widget.amountper}" +
                                  ")",
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'newbodyfont',
                                  color: Colors.black),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.codeproduct,
                                  style: TextConstants.textstyle,
                                ),
                                Text(
                                  "ประเภท: ${widget.type}",
                                  style: TextConstants.textstyle,
                                ),
                                widget.amount == 0
                                    ? Text(
                                        "จำนวน : ${widget.amount}",
                                        style: TextStyle(
                                            fontSize: 18.sp,
                                            fontFamily: 'newbodyfont',
                                            color: Colors.red),
                                      )
                                    : Text(
                                        "จำนวน : ${widget.amount}" +
                                            "(${((widget.amount) / widget.amountper).toInt()}" +
                                            widget.pdpd +
                                            ")",
                                        style: TextConstants.textstyle,
                                      ),
                                Text(
                                  "ราคา: ${widget.price}",
                                  style: TextConstants.textstyle,
                                ),
                              ],
                            ),
                            widget.nameimg == null || widget.nameimg == "null"
                                ? SizedBox()
                                : Container(
                                    color: Colors.white,
                                    height: 100,
                                    width: 100,
                                    child: Image.network(
                                        "http://185.78.165.189:8000/img/${widget.pathimg}/${widget.nameimg}"),
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Future updateamountproduct() async {
    if (_formkey.currentState!.validate()) {
      try {
        SharedPreferences preferences1 = await SharedPreferences.getInstance();
        stringpreferences1 = preferences1.getStringList("codestore");
        String url = "http://185.78.165.189:3000/pythonapi/updateamountproduct";
        if (getnameimg == null || getnameimg == "null") {
          var body = {
            "nameproduct": widget.nameproduct,
            "score": score.text.trim(),
            "amount": amount.text.trim(),
            "price": price.text.trim(),
            "pathimg": stringpreferences1![0],
            "nameimg": "null",
            // "nameimg": selectedImage!.path.split('/').last,
            "codestore": stringpreferences1![0],
            "codeproduct": widget.codeproduct
          };
          print(body);
          http.Response response = await http.patch(Uri.parse(url),
              headers: {'Content-Type': 'application/json; charset=utf-8'},
              body: JsonEncoder().convert(body));

          if (response.statusCode == 200) {
            return showDialog(
                context: context,
                // ignore: unnecessary_new
                builder: (_) => new AlertDialog(
                      content: new Text("Update success"),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            //onUploadImage();
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => MyApp()));
                          },
                        )
                      ],
                    ));
          } else {
            print("server error");
          }
        } else {
          var body = {
            "nameproduct": widget.nameproduct,
            "score": score.text.trim(),
            "amount": amount.text.trim(),
            "price": price.text.trim(),
            "pathimg": stringpreferences1![0],
            "nameimg": getnameimg,
            "codestore": stringpreferences1![0],
            "codeproduct": widget.codeproduct
          };
          print(body);
          http.Response response = await http.patch(Uri.parse(url),
              headers: {'Content-Type': 'application/json; charset=utf-8'},
              body: JsonEncoder().convert(body));

          if (response.statusCode == 200) {
            return showDialog(
                context: context,
                // ignore: unnecessary_new
                builder: (_) => new AlertDialog(
                      content: new Text("Update success"),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            if (selectedImage != null) {
                              onUploadImage();
                            } else {}
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => MyApp()));
                          },
                        )
                      ],
                    ));
          } else {
            print("server error");
          }
        }
      } catch (e) {
        print(e);
      }
    } else {
      print("server error");
    }
  }

  Future getImage() async {
    final pickimage = await ImagePicker().getImage(source: ImageSource.gallery);
    selectedImage = io.File(pickimage!.path);

    setState(() {
      getnameimg = selectedImage!.path.split('/').last.toString();
    });
  }

  onUploadImage() async {
    SharedPreferences preferences1 = await SharedPreferences.getInstance();
    stringpreferences1 = preferences1.getStringList("codestore");
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
          "http://185.78.165.189:3000/pythonapi/upload/${stringpreferences1![0]}"),
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
    print("request: " + request.toString());
    var res = await request.send();
    http.Response response = await http.Response.fromStream(res);
    setState(() {
      resJson = jsonDecode(response.body);
      selectedImage = null;
    });
  }
}
