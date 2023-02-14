import 'dart:async';
import 'dart:convert';
import 'dart:math';
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
import 'package:sigma_space/update.dart';
import 'package:sizer/sizer.dart';
import 'dart:io' as io;

class addnewproductpage extends StatefulWidget {
  addnewproductpage({Key? key}) : super(key: key);

  @override
  _addnewproductpage createState() => _addnewproductpage();
}

class _addnewproductpage extends State<addnewproductpage> {
  @override
  String? _scanBarcode = '';
  TextEditingController code = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController type = TextEditingController();
  TextEditingController score = TextEditingController();
  TextEditingController numbers = TextEditingController();
  TextEditingController numberspercrate = TextEditingController();
  TextEditingController price = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  List<String>? stringpreferences1;
  bool toggle = false;
  int selectedValue = 1;
  int numm = 0;
  int numper = 1;
  io.File? selectedImage;

  var resJson;
  String message = "";
  void initState() {
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
                  "ADD",
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
                    ))),
            backgroundColor: ColorConstants.backgroundbody,
            body: Form(
              key: _formkey,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: ListView(
                  children: [
                    textcode(),
                    textname(),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [texttype(), textscore(), textprice()]),
                    SizedBox(
                      child: textnumber(),
                      width: MediaQuery.of(context).size.width / 1.5,
                    ),
                    SizedBox(
                      child: textnumberspercrate(),
                      width: MediaQuery.of(context).size.width / 1.7,
                    ),
                    SizedBox(
                      child: textnumber2(),
                      width: MediaQuery.of(context).size.width / 1.5,
                    ),
                    selectimage(),
                    buttondone(),
                    showimg()
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget textcode() {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[50],
            border: Border.all(color: HexColor('#39474F'), width: 2),
            borderRadius: BorderRadius.circular(10.0)),
        child: Center(
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            SizedBox(
              width: 50.w,
              height: 7.h,
              child: Center(
                child: TextFormField(
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 15.0.sp),
                  decoration: InputDecoration(
                      hintText: toggle == true ? code.text : "รหัสสินค้า",
                      hintStyle:
                          TextStyle(fontFamily: "newbodyfont", fontSize: 15.sp),
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white))),
                  onChanged: (value) {
                    value = code.text;
                  },
                  controller: code,
                ),
              ),
            ),
            TextButton(
                onPressed: scanbarcode,
                child: toggle == true
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            toggle = false;
                          });
                        },
                        icon: Icon(
                          Icons.close,
                          color: Colors.black,
                        ))
                    : Text(
                        "[=]",
                        style: TextStyle(color: Colors.amber, fontSize: 12.sp),
                      ))
          ]),
        ),
      ),
    );
  }

  Widget textname() {
    return Padding(
      padding: EdgeInsets.all(5),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: TextFormField(
          onChanged: (text) => setState(() {
            text = name.text.trim();
          }),
          controller: name,
          style: TextStyle(fontSize: 20.sp, fontFamily: 'newbodyfont'),
          decoration: InputDecoration(
            labelText: "ชื่อสินค้า",
            labelStyle: TextStyle(fontFamily: "newbodyfont", fontSize: 15.sp),
            filled: false,
            hintStyle: TextStyle(fontFamily: "newbodyfont", fontSize: 15.sp),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: HexColor('#39474F'), width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.yellow.shade800, width: 2),
            ),
          ),
          validator: (input) {
            if (input!.length < 1) {
              return "Please input nameproduct";
            }
          },
        ),
      ),
    );
  }

  Widget texttype() {
    return Padding(
      padding: EdgeInsets.all(5),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 3,
        child: TextFormField(
          onChanged: (text) => setState(() {
            text = type.text.trim();
          }),
          controller: type,
          style: TextStyle(fontSize: 20.sp, fontFamily: 'newbodyfont'),
          decoration: InputDecoration(
            labelText: "ประเภทสินค้า",
            labelStyle: TextStyle(fontFamily: "newbodyfont", fontSize: 15.sp),
            filled: false,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: HexColor('#39474F'), width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.yellow.shade800, width: 2),
            ),
          ),
          validator: (input) {
            if (input!.length < 1) {
              return "Please input typeproduct";
            }
          },
        ),
      ),
    );
  }

  Widget textscore() {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 4,
            child: TextFormField(
              onChanged: (text) => setState(() {
                text = score.text.trim();
              }),
              controller: score,
              style: TextStyle(fontSize: 20.sp, fontFamily: 'newbodyfont'),
              decoration: InputDecoration(
                labelText: "คะแนนสินค้า",
                labelStyle:
                    TextStyle(fontFamily: "newbodyfont", fontSize: 15.sp),
                filled: false,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: HexColor('#39474F'), width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.yellow.shade800, width: 2),
                ),
              ),
              validator: (input) {
                if (input!.length < 1) {
                  return "Please input";
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget textprice() {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 3.1,
            child: TextFormField(
              onChanged: (text) => setState(() {
                text = price.text.trim();
              }),
              controller: price,
              style: TextStyle(fontSize: 20.sp, fontFamily: 'newbodyfont'),
              decoration: InputDecoration(
                labelText: "ราคาตั้ง",
                labelStyle:
                    TextStyle(fontFamily: "newbodyfont", fontSize: 15.sp),
                filled: false,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: HexColor('#39474F'), width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.yellow.shade800, width: 2),
                ),
              ),
              validator: (input) {
                if (input!.length < 1) {
                  return "Please input";
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget textnumberspercrate() {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Row(
        children: [
          Text(
            "บรรจุ",
            style: TextConstants.textstyle,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: DropdownButton(
                value: selectedValue,
                items: [
                  DropdownMenuItem(
                    child: Text("ลัง"),
                    value: 1,
                  ),
                  DropdownMenuItem(
                    child: Text("มัด"),
                    value: 2,
                  ),
                  DropdownMenuItem(
                    child: Text("คู่"),
                    value: 3,
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedValue = value as int;
                  });
                }),
          ),
          Text(
            "ละ",
            style: TextConstants.textstyle,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 6,
            child: TextFormField(
              onFieldSubmitted: (text) => setState(() {
                text = numberspercrate.text.trim();
                numper = int.parse(numberspercrate.text.trim());
              }),
              controller: numberspercrate,
              style: TextStyle(
                  fontSize: 20.sp,
                  fontFamily: 'newbodyfont',
                  color: Colors.red),
              decoration: InputDecoration(
                hintText: ".......",
                labelStyle:
                    TextStyle(fontFamily: "newbodyfont", fontSize: 15.sp),
                filled: false,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (input) {
                if (input!.length < 1) {
                  return "Please input";
                }
              },
            ),
          ),
          Text(
            "หน่วย",
            style: TextConstants.textstyle,
          ),
        ],
      ),
    );
  }

  Widget textnumber() {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Row(
        children: [
          Text(
            "จำนวนทั้งหมด",
            style: TextConstants.textstyle,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 6,
            child: TextFormField(
              onFieldSubmitted: (text) => setState(() {
                text = numbers.text.trim();
                numm = int.parse(numbers.text.trim());
              }),
              controller: numbers,
              style: TextStyle(
                  fontSize: 20.sp,
                  fontFamily: 'newbodyfont',
                  color: Colors.red),
              decoration: InputDecoration(
                hintText: "......",
                labelStyle:
                    TextStyle(fontFamily: "newbodyfont", fontSize: 15.sp),
                filled: false,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (input) {
                if (input!.length < 1) {
                  return "Please input";
                }
              },
            ),
          ),
          Text(
            "หน่วย",
            style: TextConstants.textstyle,
          ),
        ],
      ),
    );
  }

  Widget textnumber2() {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Row(
        children: [
          Text(
            "จำนวนทั้งหมด",
            style: TextConstants.textstyle,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: SizedBox(
                width: MediaQuery.of(context).size.width / 6,
                child: Text(
                  (numm / numper).toInt().toString(),
                  style: TextConstants.textstyle,
                )),
          ),
          selectedValue == 1
              ? Text("ลัง", style: TextConstants.textstyle)
              : selectedValue == 2
                  ? Text("มัด", style: TextConstants.textstyle)
                  : selectedValue == 3
                      ? Text("คู่", style: TextConstants.textstyle)
                      : Text(
                          "หน่วย",
                          style: TextConstants.textstyle,
                        ),
        ],
      ),
    );
  }

  Widget selectimage() {
    return Padding(
        padding: EdgeInsets.all(5),
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
        ]));
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
          onPressed: onUploadImage,
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

  Widget showimg() {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Container(
        width: 100,
        height: 100,
        child: Image.network(
            "http://185.78.165.189:8000/img/image_picker_57BF24AC-F520-4FC9-89F1-1FBD9718AF84-1730-00000824A670020A.png"),
      ),
    );
  }

  Future<void> scanbarcode() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      toggle == true;
      code.text = barcodeScanRes;
    });
  }

  Future insertnewproduct() async {
    ///แก้
    SharedPreferences preferences1 = await SharedPreferences.getInstance();
    stringpreferences1 = preferences1.getStringList("codestore");
    String pdset = "";
    if (selectedValue == 1) {
      pdset = "ลัง";
    } else if (selectedValue == 2) {
      pdset = "มัด";
    } else if (selectedValue == 3) {
      pdset = "คู่";
    }
    if (_formkey.currentState!.validate()) {
      try {
        String url = "http://185.78.165.189:3000/nodejsapi/insertproduct";
        var body = {
          "codeproduct": code.text.trim(),
          "nameproduct": name.text.trim(),
          "codestore": stringpreferences1![0],
          "amount": int.parse(numbers.text.trim()),
          "amountpercrate": int.parse(numberspercrate.text.trim()),
          "productset": pdset.trim(),
          "type": type.text.trim(),
          "score": int.parse(score.text.trim()),
          "price": int.parse(price.text.trim())
        };
        http.Response response = await http.post(Uri.parse(url),
            headers: {'Content-Type': 'application/json; charset=utf-8'},
            body: JsonEncoder().convert(body));

        if (response.statusCode == 200) {
          name.clear();
          score.clear();
          numbers.clear();
          numberspercrate.clear();
          type.clear();
          code.clear();
          price.clear();
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
    } else {
      print("server error");
    }
  }

  Future getImage() async {
    final pickimage = await ImagePicker().getImage(source: ImageSource.gallery);
    selectedImage = io.File(pickimage!.path);
    int random = Random().nextInt(10);

    setState(() {});
  }

  onUploadImage() async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("http://185.78.165.189:3000/pythonapi/upload"),
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
    });
  }
}
