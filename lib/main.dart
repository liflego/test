import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sigma_space/classapi/class.dart';
import 'package:sigma_space/page/chectsotck.dart';
import 'package:sigma_space/page/customer.dart';
import 'package:sigma_space/page/dealer.dart';
import 'package:sigma_space/page/noti.dart';
import 'package:sigma_space/page/orderfromstore.dart';
import 'package:sigma_space/showlogo.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final preferences1 = await SharedPreferences.getInstance();
  runApp(
      new MaterialApp(debugShowCheckedModeBanner: false, home: new showlogo()));
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  List<String>? position;
  List<String>? stringpreferences1;
  @override
  void initState() {
    updatestatus().then((value) => position = stringpreferences1);
    super.initState();
  }

  int _selectpage = 0;
  bool item1 = false;
  bool item2 = false;
  bool item3 = false;
  final _pageOption = [
    orderfromstore(),
    checkstock(
      codeorder: [],
      nameorder: [],
      numorder: [],
      numpercrate: [],
      productset: [],
      price: [],
    )
  ];
  final _pageOption2 = [
    orderfromstore(),
    checkstock(
      codeorder: [],
      nameorder: [],
      numorder: [],
      numpercrate: [],
      productset: [],
      price: [],
    ),
    customer()
  ];

  final _pageOption3 = [dealerpage(), notipage()];

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: position?[1] == "ADMIN"
            ? _pageOption[_selectpage]
            : position?[1] == "DEALER"
                ? _pageOption3[_selectpage]
                : _pageOption2[_selectpage],
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: ColorConstants.appbarcolor,
            selectedItemColor: Colors.amber,
            unselectedItemColor: Colors.white,
            currentIndex: _selectpage,
            onTap: (index) {
              setState(() {
                _selectpage = index;
              });
            },
            items: position?[1] == "ADMIN"
                ? [
                    // ignore: unnecessary_new

                    // ignore: unnecessary_new
                    new BottomNavigationBarItem(
                      icon: Icon(
                        Icons.list,
                        size: 30.sp,
                      ),
                      label: "ORDER",
                    ),
                    // ignore: unnecessary_new
                    new BottomNavigationBarItem(
                      icon: Icon(
                        Icons.check_box_outlined,
                        size: 30.sp,
                      ),
                      label: "UPDATE",
                    ),
                  ]
                : position?[1] == "DEALER"
                    ? [
                        new BottomNavigationBarItem(
                          icon: Icon(
                            Icons.people_alt_sharp,
                            size: 30.sp,
                          ),
                          label: "DEALER",
                        ),
                        new BottomNavigationBarItem(
                          icon: Icon(
                            Icons.notifications_outlined,
                            size: 30.sp,
                          ),
                          label: "NOTICE",
                        ),
                      ]
                    : [
                        new BottomNavigationBarItem(
                          icon: Icon(
                            Icons.check_box_outlined,
                            size: 30.sp,
                          ),
                          label: "ORDER",
                        ),
                        new BottomNavigationBarItem(
                          icon: Icon(
                            Icons.list,
                            size: 30.sp,
                          ),
                          label: "STOCK",
                        ),
                        new BottomNavigationBarItem(
                          icon: Icon(
                            Icons.store_sharp,
                            size: 30.sp,
                          ),
                          label: "STORE",
                        ),
                      ]),
      );
    });
  }

  Future updatestatus() async {
    SharedPreferences preferences1 = await SharedPreferences.getInstance();
    // preferences1.setInt("status", 0);

    setState(() {
      stringpreferences1 = preferences1.getStringList("codestore");
      print(stringpreferences1);
    });
  }
}
