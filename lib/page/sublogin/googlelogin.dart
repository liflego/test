// import 'dart:convert';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// import 'package:flutter_hex_color/flutter_hex_color.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sizer/sizer.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../../classapi/class.dart';
// import 'package:http/http.dart' as http;
// import 'package:sigma_space/login.dart';

// class googlelogin extends StatefulWidget {
//   googlelogin({Key? key}) : super(key: key);

//   @override
//   _googlelogin createState() => _googlelogin();
// }

// class _googlelogin extends State<googlelogin> {
//   TextEditingController namestoreString = TextEditingController();
//   TextEditingController productypString = TextEditingController();
//   TextEditingController phonenumberSting = TextEditingController();
//   TextEditingController positionSting = TextEditingController();

//   GoogleSignIn _googleSignIn = GoogleSignIn();

//   final _formkey = GlobalKey<FormState>();
//   late int ttt;
//   late String s;
//   late String codestore;
//   late bool _serviceEnbled;
//   bool _isGetlocation = false;
//   // final position = ['ADMIN', 'SALE', 'DEALER'];
//   // String? value1;

//   @override
//   void initState() {
//     // TODO: implement initState
//     getnewuser();
//     super.initState();
//   }

//   Widget build(BuildContext context) {
//     return Sizer(builder: (context, orientation, deviceType) {
//       return Scaffold(
//         backgroundColor: ColorConstants.backgroundbody,
//         appBar: AppBar(
//           centerTitle: true,
//           toolbarHeight: 10.h,
//           title: Text(
//             "REGISTER",
//             style: TextStyle(fontSize: 30.0.sp, fontFamily: 'newtitlefont'),
//           ),
//           automaticallyImplyLeading: true,
//           backgroundColor: ColorConstants.appbarcolor,
//         ),
//         body: SingleChildScrollView(
//           child: Form(
//             key: _formkey,
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(top: 70.0),
//                 ),
//                 showname(),
//                 namestore(),
//                 productype(),
//                 phonenumber(),
//                 //positiontype(),
//                 //getuid(),
//                 //getlocation(),
//                 buttonregister(),
//                 goout1(),
//               ],
//             ),
//           ),
//         ),
//       );
//     });
//   }

//   Widget showname() {
//     return Padding(
//         padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 0.h),
//         child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text("Hello Welcom",
//                   style: TextStyle(
//                       fontFamily: "newbodyfont",
//                       fontSize: 45,
//                       color: Colors.blue[900])),
//               Text(FirebaseAuth.instance.currentUser!.email!,
//                   style: TextStyle(
//                       fontFamily: "newbodyfont",
//                       fontSize: 35,
//                       color: Colors.blue[900])),
//               Text(FirebaseAuth.instance.currentUser!.displayName!,
//                   style: TextStyle(
//                       fontFamily: "newbodyfont",
//                       fontSize: 30,
//                       color: Colors.blue[900])),
//             ]));
//   }

//   Widget namestore() {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 4.h),
//       child: TextFormField(
//         decoration: InputDecoration(
//           hintText: "Namestore",
//           hintStyle: TextStyle(fontFamily: "newbodyfont", fontSize: 15.sp),
//           enabledBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: HexColor('#39474F'), width: 2),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.yellow.shade800, width: 2),
//           ),
//         ),
//         controller: namestoreString,
//         // ignore: body_might_complete_normally_nullable
//         validator: (input) {
//           if (input!.length < 1) {
//             return "Please enter Namestore";
//           }
//         },
//       ),
//     );
//   }

//   Widget productype() {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 4.h),
//       child: TextFormField(
//         decoration: InputDecoration(
//           hintText: "Productype",
//           hintStyle: TextStyle(fontFamily: "newbodyfont", fontSize: 15.sp),
//           enabledBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: HexColor('#39474F'), width: 2),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.yellow.shade800, width: 2),
//           ),
//         ),
//         controller: productypString,
//         // ignore: body_might_complete_normally_nullable
//         validator: (input) {
//           if (input!.length < 1) {
//             return "Please enter Productype";
//           }
//         },
//       ),
//     );
//   }

//   Widget phonenumber() {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 4.h),
//       child: TextFormField(
//         decoration: InputDecoration(
//           hintText: "Phonenumber",
//           hintStyle: TextStyle(fontFamily: "newbodyfont", fontSize: 15.sp),
//           enabledBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: HexColor('#39474F'), width: 2),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.yellow.shade800, width: 2),
//           ),
//         ),
//         controller: phonenumberSting,
//         // ignore: body_might_complete_normally_nullable
//         validator: (input) {
//           if (input!.length < 1) {
//             return "Please enter Phonenumber";
//           }
//         },
//       ),
//     );
//   }

//   // Widget positiontype() {
//   //   return Padding(
//   //     padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 4.h),
//   //     child: Container(
//   //       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//   //       decoration: BoxDecoration(border: Border.all(width: 2)),
//   //       child: DropdownButtonHideUnderline(
//   //         child: DropdownButton<String>(
//   //           hint: Text(
//   //             "Position",
//   //             style: TextStyle(fontFamily: "newbodyfont", fontSize: 15.sp),
//   //           ),
//   //           value: value1,
//   //           isExpanded: true,
//   //           items: position.map(buildmenuItem).toList(),
//   //           onChanged: (value) {
//   //             setState(() {
//   //               value1 = value.toString();
//   //               print(value1);
//   //             });
//   //           },
//   //            onChanged: (value) {setState(() { this.value = value :
//   //            print(value));}},
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }

//   // DropdownMenuItem<String> buildmenuItem(String position) => DropdownMenuItem(
//   //       value: position,
//   //       child: Text(
//   //         position,
//   //       ),
//   //     );

//   // Widget getuid() {
//   //   return Padding(
//   //     padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 4.h),
//   //     child: TextFormField(
//   //       decoration: InputDecoration(
//   //         hintText: "Uid",
//   //         hintStyle: TextStyle(fontFamily: "newbodyfont", fontSize: 15.sp),
//   //         enabledBorder: OutlineInputBorder(
//   //           borderSide: BorderSide(color: HexColor('#39474F'), width: 2),
//   //         ),
//   //         focusedBorder: OutlineInputBorder(
//   //           borderSide: BorderSide(color: Colors.yellow.shade800, width: 2),
//   //         ),
//   //       ),
//   //       controller: uid,
//   //       // ignore: body_might_complete_normally_nullable
//   //       validator: (input) {
//   //         if (input!.length < 1) {
//   //           return "Please enter Uid";
//   //         }
//   //       },
//   //     ),
//   //   );
//   // }

//   Widget buttonregister() {
//     return Padding(
//         padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 10.h),
//         // ignore: deprecated_member_use
//         child: TextButton(
//           style: ButtonStyle(
//               backgroundColor:
//                   MaterialStateProperty.all(ColorConstants.buttoncolor)),
//           onPressed: () {
//             addline();
//           },
//           child: Center(
//             child: Text(
//               "Next",
//               style: TextStyle(
//                   fontSize: 25.0.sp,
//                   color: Colors.white,
//                   fontFamily: 'newbodyfont'),
//             ),
//           ),
//         ));
//   }

//   Widget goout1() {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 10.h),
//       // ignore: deprecated_member_use
//       child: TextButton(
//         style: ButtonStyle(
//             backgroundColor:
//                 MaterialStateProperty.all(ColorConstants.buttoncolor)),
//         onPressed: () {
//           signOut();
//         },
//         child: Center(
//           child: Text(
//             "Logout",
//             style: TextStyle(
//                 fontSize: 25.0.sp,
//                 color: Colors.white,
//                 fontFamily: 'newbodyfont'),
//           ),
//         ),
//       ),
//     );
//   }

//   // Widget getlocation() {
//   //   return Padding(
//   //     padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 7.h),
//   //     // ignore: deprecated_member_use
//   //     child: Row(
//   //       // crossAxisAlignment: CrossAxisAlignment.start,
//   //       // mainAxisAlignment: MainAxisAlignment.start,
//   //       children: [
//   //         _isGetlocation
//   //             ? Text(
//   //                 ' ${_locationData?.latitude} , ${_locationData?.longitude}',
//   //                 style: TextStyle(fontFamily: "newbodyfont", fontSize: 20.sp),
//   //               )
//   //             : Container(),
//   //         IconButton(
//   //             onPressed: () async {
//   //               _serviceEnbled = await location.serviceEnabled();
//   //               if (!_serviceEnbled) {
//   //                 _serviceEnbled = await location.requestService();
//   //                 if (_serviceEnbled) return;
//   //               }

//   //               _permissionGrranted = await location.hasPermission();
//   //               if (_permissionGrranted == PermissionStatus.denied) {
//   //                 _permissionGrranted = await location.requestPermission();
//   //                 if (_permissionGrranted != PermissionStatus.granted) return;
//   //               }
//   //               _locationData = await location.getLocation();
//   //               setState(() {
//   //                 _isGetlocation = true;
//   //               });
//   //             },
//   //             icon: Icon(
//   //               Icons.location_on,
//   //               size: 30.sp,
//   //               color: Colors.red,
//   //             )),
//   //       ],
//   //     ),
//   //   );
//   // }

//   Future getnewuser() async {
//     String url = "http://185.78.165.189:3000/pythonapi/getnewuser";

//     http.Response response = await http.get(Uri.parse(url),
//         headers: {'Content-Type': 'application/json; charset=utf-8'});
//     var jsonRes = await json.decode(response.body);

//     String text = jsonRes["codestore"];
//     String txt = text.substring(1);
//     ttt = int.parse(txt);

//     setState(() {
//       ttt = ttt + 1;

//       s = ttt.toString();
//       codestore = "A" + ttt.toRadixString(16);

//       print(s);
//       print(codestore);
//     });
//   }

//   signOut() {
//     _googleSignIn.signOut().then((value) {
//       setState(() {});
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => (login()),
//         ),
//       );
//     });
//   }

//   Future doLogin() async {
//     getnewuser();
//     if (_formkey.currentState!.validate()) {
//       try {
//         String url = "http://185.78.165.189:3000/pythonapi/createuserwithgg";
//         var body = {
//           "username": FirebaseAuth.instance.currentUser!.email,
//           "uid": FirebaseAuth.instance.currentUser!.uid,
//           "codestore": codestore,
//           "namestore": namestoreString.text.trim(),
//           "producttype": productypString.text.trim(),
//           "position": 'DEALER',
//           "phonenumbers": phonenumberSting.text.trim(),
//           "datecreate":
//               DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
//         };

//         http.Response response = await http.post(Uri.parse(url),
//             headers: {'Content-Type': 'application/json; charset=utf-8'},
//             body: JsonEncoder().convert(body));

//         return Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => (login()),
//           ),
//         );
//       } catch (error) {
//         print(error);
//       }
//     }
//   }

//   void addline() => showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           actions: [
//             TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Text('done'))
//           ],
//           content: SizedBox(
//             height: 80.sp,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 new Text("ADD LINE"),
//                 Padding(padding: EdgeInsets.only(top: 20.0)),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     IconButton(
//                         onPressed: () {
//                           doLogin();
//                           _openline();
//                         },
//                         icon: Icon(
//                           Icons.add_reaction,
//                           size: 30.sp,
//                           color: Colors.green,
//                         ))
//                   ],
//                 ),
//                 // ignore: unnecessary_new
//               ],
//             ),
//           ),
//         ),
//       );

//   Future<void> _openline() async {
//     String LineURL = 'https://page.line.me/962ekjzu';
//     await canLaunch(LineURL)
//         ? await launch(LineURL)
//         : throw 'Could not launch $LineURL';
//   }

// // Future<void> scanbarcode() async {
// //     String barcodeScanRes;
// //     // Platform messages may fail, so we use a try/catch PlatformException.
// //     try {
// //       barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
// //           '#ff6666', 'Cancel', true, ScanMode.QR);
// //       setState(() {
// //         _scanBarcode = barcodeScanRes;
// //         list = _scanBarcode.split(" ");
// //       });

// //     } on PlatformException {
// //       barcodeScanRes = 'Failed to get platform version.';
// //     }

// //     // If the widget was removed from the tree while the asynchronous platform
// //     // message was in flight, we want to discard the reply rather than calling
// //     // setState to update our non-existent appearance.

// //     if (!mounted) return;

// //     setState(() {
// //       _scanBarcode = barcodeScanRes;
// //     });
// //   }
// }
