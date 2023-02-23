import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sigma_space/login.dart';
import 'package:sigma_space/main.dart';

class showlogo extends StatefulWidget {
  showlogo({Key? key}) : super(key: key);

  @override
  _showlogoState createState() => _showlogoState();
}

class _showlogoState extends State<showlogo> {
  List<String>? strintpre;
  @override
  void initState() {
    autologin();
    Future.delayed(const Duration(seconds: 2), () async {
      if (strintpre!.isEmpty) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => login()));
      } else {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => MyApp()));
      }
    });

    super.initState();
  }

  Future autologin() async {
    final preferences1 = await SharedPreferences.getInstance();
    strintpre = await preferences1.getStringList("codestore")!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#39474F'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: Image.asset("assets/images/logo.png"),
            ),
          ],
        ),
      ),
    );
  }
}
