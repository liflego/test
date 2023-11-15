import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sigma_space/page/sublogin/Createdealerac.dart';
import 'package:sigma_space/page/sublogin/choose.dart';
import 'classapi/class.dart';
import 'main.dart';
import 'package:sizer/sizer.dart';
import 'package:email_otp/email_otp.dart';

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
  // GoogleSignInAccount? _userObj;
  // GoogleSignIn _googleSignIn = GoogleSignIn();
  String name = "";
  String email = "";
  // final auth = FirebaseAuth.instance;
  List<String> stringpreferences1 = [];
  List<String> stringpreferences2 = [];
  EmailOTP myauth = EmailOTP();
  late List<String> users;

  @override
  void initState() {
    super.initState();
  }

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
                sentotp(),
                OTPtext(),
                loginbt(),
                registerbt()
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
          hintText: "YOUR EMAIL ADDRESS",
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

  Widget OTPtext() {
    return Padding(
      padding: EdgeInsets.only(top: 60, left: 40, right: 40),
      child: TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          filled: false,
          hintText: "OTP VERIFICATION",
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
        obscureText: false,
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

  Widget sentotp() {
    return Padding(
      padding: EdgeInsets.only(top: 5, left: 40, right: 40),
      // ignore: deprecated_member_use
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 2, color: Colors.amber)),
        child: TextButton(
          onPressed: () async {
            myauth.setConfig(
                appEmail: usernameString.text,
                appName: "SIGB OTP",
                userEmail: usernameString.text,
                otpLength: 6,
                otpType: OTPType.digitsOnly);
            if (await myauth.sendOTP() == true) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("OTP has been sent"),
              ));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Oops, OTP send failed"),
              ));
            }
          },
          child: Center(
            child: Text(
              "SENT OTP",
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

  Widget loginbt() {
    return Padding(
      padding: EdgeInsets.only(top: 5, left: 40, right: 40),
      child: TextButton(
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(ColorConstants.buttoncolor)),
        onPressed: () async {
          if (await myauth.verifyOTP(otp: passwordString.text) == true) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("OTP is verified"),
            ));
            doLogin();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Invalid OTP"),
            ));
          }
        },
        child: Center(
          child: Text(
            "LOG IN",
            style: TextStyle(
                fontSize: 20.0.sp,
                color: Colors.white,
                fontFamily: 'newbodyfont'),
          ),
        ),
      ),
    );
  }

  Widget registerbt() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 1.0.h, vertical: 40.0.w),
      child: TextButton(
        onPressed: () {
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) {
            return createAcountfordealer();
          }));
        },
        child: Text(
          "CREATE ACCOUNT !",
          style: TextStyle(
              fontSize: 18.sp,
              fontFamily: 'newbodyfont',
              color: Colors.blue[400]),
        ),
      ),
    );
  }
  // Widget googleloginbutton() {
  //   return Padding(
  //     padding: EdgeInsets.only(top: 80),
  //     // ignore: deprecated_member_use
  //     child: SizedBox(
  //       child: Center(
  //         child: SignInButton(Buttons.GoogleDark, onPressed: () {
  //           signInWithGoogle();
  //         }),
  //       ),
  //     ),
  //   );
  // }

  Future doLogin() async {
    if (_formkey.currentState!.validate()) {
      try {
        String url = "http://185.78.165.189:3000/pythonapi/login";

        var body = {
          "username": usernameString.text.trim(),
        };

        http.Response response = await http.post(Uri.parse(url),
            headers: {'Content-Type': 'application/json; charset=utf-8'},
            body: JsonEncoder().convert(body));

        var jsonRes = json.decode(response.body);

        if (jsonRes["success"] == 1 &&
            (jsonRes["loginstatus"] == null || jsonRes["loginstatus"] == 0)) {
          users = [
            jsonRes["userid"].toString(),
            jsonRes["username"].toString(),
            jsonRes["name"].toString(),
            jsonRes["position"].toString(),
            jsonRes["namestore"].toString(),
            jsonRes["loginstatus"].toString(),
            jsonRes["auth"].toString(),
          ];

          SharedPreferences preferences1 =
              await SharedPreferences.getInstance();

          preferences1.setStringList("userid", users);

          ////update login status
          String url2 =
              "http://185.78.165.189:3000/pythonapi/updateloginstatus";

          var body2 = {
            "loginstatus": "1",
            "username": usernameString.text.trim(),
          };

          http.Response response2 = await http.patch(Uri.parse(url2),
              headers: {'Content-Type': 'application/json; charset=utf-8'},
              body: JsonEncoder().convert(body2));

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => (choose()),
            ),
          );
        } else {
          return showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    content: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "EMAIL ADDRESS ALREADY IN USE!",
                        style: TextStyle(color: Colors.red, fontSize: 12.sp),
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('DONE'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ));
        }
      } catch (error) {
        return showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  content: const Text("CAN NOT LOG IN"),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('DONE'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ));
      }
    }
  }
}
