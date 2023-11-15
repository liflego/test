// import 'package:firebase_core/firebase_core.dart';
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
  // await Firebase.initializeApp();

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
    pagepref();
    updatestatus().then((value) => position = stringpreferences1);
    super.initState();
  }

  int _selectpage = 0;
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
    checkstock(
      codeorder: [],
      nameorder: [],
      numorder: [],
      numpercrate: [],
      productset: [],
      price: [],
    ),
    orderfromstore(),
    customer()
  ];

  final _pageOption3 = [dealerpage(), notipage()];

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, device) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: position?[3] == "ADMIN"
            ? _pageOption[_selectpage]
            : position?[3] == "DEALER"
                ? _pageOption3[_selectpage]
                : _pageOption2[0],
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
            items: position?[3] == "ADMIN"
                ? [
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.list,
                        size: 30.sp,
                      ),
                      label: "ORDER",
                    ),
                    // ignore: unnecessary_new
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.check_box_outlined,
                        size: 30.sp,
                      ),
                      label: "UPDATE",
                    ),
                  ]
                : position?[3] == "DEALER"
                    ? [
                        BottomNavigationBarItem(
                          icon: Icon(
                            Icons.people_alt_sharp,
                            size: 30.sp,
                          ),
                          label: "DEALER",
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(
                            Icons.notifications_outlined,
                            size: 30.sp,
                          ),
                          label: "NOTICE",
                        ),
                      ]
                    : [
                        BottomNavigationBarItem(
                          icon: Icon(
                            Icons.check_box_outlined,
                            size: 30.sp,
                          ),
                          label: "STOCK",
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(
                            Icons.list,
                            size: 30.sp,
                          ),
                          label: "ORDER",
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(
                            Icons.person,
                            size: 30.sp,
                          ),
                          label: "CUSTOMER",
                        ),
                      ]),
      );
    });
  }

  Future updatestatus() async {
    SharedPreferences preferences1 = await SharedPreferences.getInstance();

    setState(() {
      stringpreferences1 = preferences1.getStringList("userid");
    });
  }

  Future pagepref() async {
    SharedPreferences pagepref = await SharedPreferences.getInstance();
    if (pagepref.getInt("pagepre") == null) {
      _selectpage = 0;
    } else {
      setState(() {
        _selectpage = pagepref.getInt("pagepre")!;
      });
    }
  }
}
