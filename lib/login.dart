import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:sigma_space/page/sublogin/googlelogin.dart';
import 'package:url_launcher/url_launcher.dart';
import 'classapi/class.dart';
import 'main.dart';
import 'package:sizer/sizer.dart';

class login extends StatefulWidget {
  login({Key? key}) : super(key: key);

  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController usernameString = TextEditingController();
  TextEditingController passwordString = TextEditingController();
  int? status;
  int? status2;
  GoogleSignInAccount? _userObj;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  String name = "";
  String email = "";
  final auth = FirebaseAuth.instance;
  List<String> stringpreferences1 = [];
  List<String> stringpreferences2 = [];
  String location = 'Current';
  late String lat;
  late String long;

  @override
  void initState() {
    super.initState();
  }

  // Future loginauto() async {
  //   SharedPreferences preferences1 = await SharedPreferences.getInstance();

  //   setState(() {
  //     stringpreferences1 = preferences1.getStringList("codestore")!;
  //     Navigator.of(context)
  //         .pushReplacement(MaterialPageRoute(builder: (context) {
  //       return MyApp();
  //     }));
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        backgroundColor: ColorConstants.backgroundbody,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          toolbarHeight: 10.h,
          title: Text(
            "SIGB",
            style: TextStyle(fontSize: 30.0.sp, fontFamily: 'newtitlefont'),
          ),
          backgroundColor: ColorConstants.appbarcolor,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 70.0),
                ),
                usernametext(),
                passwordtext(),
                buttonlogin(),
                register(),
                googleloginbutton(),
              ],
            ),
          ),
        ),
      );
    });
  }

  ///for usename tab
  Widget usernametext() {
    return Padding(
      padding: EdgeInsets.only(top: 50, left: 40, right: 40),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: "Username",
          hintStyle: TextStyle(
              fontFamily: "newbodyfont",
              fontSize: 15.sp,
              color: Colors.black45),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.amber, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.amber, width: 2),
          ),
        ),
        controller: usernameString,
        // ignore: body_might_complete_normally_nullable
        validator: (input) {
          if (input!.length < 1) {
            return "Please enter Username";
          }
        },
      ),
    );
  }

  Widget passwordtext() {
    return Padding(
      padding: EdgeInsets.only(top: 5, left: 40, right: 40),
      child: TextFormField(
        decoration: InputDecoration(
          filled: false,
          hintText: "Password",
          hintStyle: TextStyle(
              fontFamily: "newbodyfont",
              fontSize: 15.sp,
              color: Colors.black45),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.amber, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.amber, width: 2),
          ),
        ),
        obscureText: true,
        controller: passwordString,
        validator: (input) {
          if (input!.isEmpty) {
            return "Please enter password";
          }
          return null;
        },
      ),
    );
  }

  Widget buttonlogin() {
    return Padding(
      padding: EdgeInsets.only(top: 60, left: 40, right: 40),
      // ignore: deprecated_member_use
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 2, color: Colors.amber)),
        child: TextButton(
          onPressed: doLogin,
          child: Center(
            child: Text(
              "Sign in",
              style: TextStyle(
                  fontSize: 20.0.sp,
                  color: ColorConstants.buttoncolor,
                  fontFamily: 'newbodyfont'),
            ),
          ),
        ),
      ),
    );
  }

  Widget register() {
    return Padding(
      padding: EdgeInsets.only(top: 5, left: 40, right: 40),
      child: TextButton(
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(ColorConstants.buttoncolor)),
        onPressed: null,
        child: Center(
          child: Text(
            "Register",
            style: TextStyle(
                fontSize: 20.0.sp,
                color: Colors.white,
                fontFamily: 'newbodyfont'),
          ),
        ),
      ),
    );
  }

  Widget googleloginbutton() {
    return Padding(
      padding: EdgeInsets.only(top: 80),
      // ignore: deprecated_member_use
      child: SizedBox(
        child: Center(
          child: SignInButton(Buttons.GoogleDark, onPressed: () {
            signInWithGoogle();
          }),
        ),
      ),
    );
  }

  Future doLogin() async {
    if (_formkey.currentState!.validate()) {
      try {
        String url = "http://185.78.165.189:3000/pythonapi/login";

        var body = {
          "username": usernameString.text.trim(),
          "uid": passwordString.text.trim()
        };

        http.Response response = await http.post(Uri.parse(url),
            headers: {'Content-Type': 'application/json; charset=utf-8'},
            body: JsonEncoder().convert(body));

        var jsonRes = json.decode(response.body);

        if (jsonRes["success"] == 1) {
          if (jsonRes["auth"] == null) {
            stringpreferences1 = [
              jsonRes["codestore"],
              jsonRes["position"],
              jsonRes["userid"].toString(),
              jsonRes["namestore"],
              "null",
            ];
          } else {
            stringpreferences1 = [
              jsonRes["codestore"],
              jsonRes["position"],
              jsonRes["userid"].toString(),
              jsonRes["namestore"],
              jsonRes["auth"],
            ];
          }

          SharedPreferences preferences1 =
              await SharedPreferences.getInstance();

          preferences1.setStringList("codestore", stringpreferences1);

          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) {
            return MyApp();
          }));
        }
      } catch (error) {
        return showDialog(
            context: context,
            builder: (_) => new AlertDialog(
                  content: new Text("Email or password is not correct"),
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
    }
  }

  Future doLogingg() async {
    try {
      String url = "http://185.78.165.189:3000/pythonapi/login";

      var body = {
        "username": FirebaseAuth.instance.currentUser!.email,
        "uid": FirebaseAuth.instance.currentUser!.uid
      };
      print(body);

      http.Response response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json; charset=utf-8'},
          body: JsonEncoder().convert(body));

      if (response.statusCode == 200) {
        var jsonRes = json.decode(response.body);

        if (jsonRes["success"] == 1) {
          if (jsonRes["auth"] == null) {
            stringpreferences1 = [
              jsonRes["codestore"],
              jsonRes["position"],
              jsonRes["userid"].toString(),
              jsonRes["namestore"],
              "null",
            ];
          } else {
            stringpreferences1 = [
              jsonRes["codestore"],
              jsonRes["position"],
              jsonRes["userid"].toString(),
              jsonRes["namestore"],
              jsonRes["auth"],
            ];
          }

          SharedPreferences preferences1 =
              await SharedPreferences.getInstance();
          preferences1.setStringList("codestore", stringpreferences1);

          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) {
            return MyApp();
          }));
        } else {
          return Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) {
            return handleAuthState();
          }));
        }
      } else {
        //print("Server error");
        return Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          return googlelogin();
        }));
      }
    } catch (error) {
      print(error);
    }
  }

  signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn(scopes: <String>["email"]).signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    doLogingg();
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  handleAuthState() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return googlelogin();
          } else {
            return login();
          }
        });
  }

  Future<void> _openmap(double lat, double long) async {
    String googleURL =
        'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    await canLaunch(googleURL)
        ? await launch(googleURL)
        : throw 'Could not launch $googleURL';
  }
}
