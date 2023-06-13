import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sigma_space/classapi/class.dart';
import 'package:sigma_space/login.dart';
import 'package:sigma_space/main.dart';
import 'package:sigma_space/page/subupdate/addnewproduct.dart';
import 'package:sizer/sizer.dart';
import 'dart:io' as io;

class uploadtrack extends StatefulWidget {
  int ordernumber;

  uploadtrack({Key? key, required this.ordernumber}) : super(key: key);

  @override
  _uploadtrack createState() => _uploadtrack();
}

class _uploadtrack extends State<uploadtrack> {
  @override
  List<String>? stringpreferences1;
  io.File? selectedImage;
  String? getnameimg;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return SafeArea(
            top: false,
            child: Scaffold(
              appBar: AppBar(
                toolbarHeight: 7.h,
                title: Text(
                  "UPLOADIMAGE",
                  style: TextStyle(fontFamily: 'newtitlefont', fontSize: 25.sp),
                ),
                backgroundColor: ColorConstants.appbarcolor,
                leading: IconButton(
                    onPressed: () async {
                      SharedPreferences pagepref =
                          await SharedPreferences.getInstance();
                      pagepref.setInt("pagepre", 0);
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
              body: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [selectimage(), buttondone()]),
            ),
          );
        },
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
      padding: EdgeInsets.all(20.sp),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.circular(
            10.0,
          ),
        ),
        child: TextButton(
          onPressed: () {
            insertdelivery();
            onUploadImage();
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (context) {
              return MyApp();
            }));
          },
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

  Future getImage() async {
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
    print("request: " + request.toString());
    var res = await request.send();
    http.Response response = await http.Response.fromStream(res);

    var resJson = jsonDecode(response.body);
    selectedImage = null;
  }

  Future insertdelivery() async {
    try {
      String url = "http://185.78.165.189:3000/pythonapi/insertdelivery";
      if (selectedImage == null) {
        return showDialog(
            context: context,
            builder: (_) => new AlertDialog(
                  content: new Text("PLEASE ENTER YOUR INFO."),
                  actions: <Widget>[
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ));
      }
      var body = {
        "ordernumber": widget.ordernumber,
        "pathimg": "Dpic",
        "nameimg": getnameimg,
        "datedelivery":
            DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
      };

      http.Response response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json; charset=utf-8'},
          body: JsonEncoder().convert(body));
    } catch (error) {
      print(error);
    }
  }
}
