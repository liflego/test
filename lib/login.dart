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
import 'package:sigma_space/showlogo.dart';
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
          centerTitle: true,
          toolbarHeight: 10.h,
          title: Text(
            "SENTOR",
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
                googleloginbutton()
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
      padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 4.h),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: "Username",
          hintStyle: TextStyle(fontFamily: "newbodyfont", fontSize: 15.sp),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: HexColor('#39474F'), width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.yellow.shade800, width: 2),
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
      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.h),
      child: TextFormField(
        decoration: InputDecoration(
          filled: false,
          hintText: "Password",
          hintStyle: TextStyle(fontFamily: "newbodyfont", fontSize: 15.sp),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: HexColor('#39474F'), width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.yellow.shade800, width: 2),
          ),
        ),
        obscureText: true,
        controller: passwordString,
        validator: (input) {
          if (input!.length < 1) {
            return "Please enter password";
          }
        },
      ),
    );
  }

  Widget buttonlogin() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.h),
      // ignore: deprecated_member_use
      child: TextButton(
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(ColorConstants.buttoncolor)),
        onPressed: doLogin,
        child: Center(
          child: Text(
            "Sign in",
            style: TextStyle(
                fontSize: 25.0.sp,
                color: Colors.white,
                fontFamily: 'newbodyfont'),
          ),
        ),
      ),
    );
  }

  Widget googleloginbutton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.h),
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
          stringpreferences1 = [
            jsonRes["codestore"],
            jsonRes["position"],
            jsonRes["userid"].toString(),
            jsonRes["namestore"]
          ];

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
          List<String> stringpreferences1 = [
            jsonRes["codestore"],
            jsonRes["position"],
            jsonRes["userid"].toString(),
            jsonRes["namestore"]
          ];

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
        print("Server error");
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
}
