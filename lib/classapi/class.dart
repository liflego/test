import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';

import 'package:sizer/sizer.dart';

class ColorConstants {
  static Color? backgroundbody = Colors.white;
  static Color? appbarcolor = HexColor('#1034A6');
  static Color? buttoncolor = Colors.amber;
  static Color? cardcolor = HexColor("#FFDC2E");
  static Color? sc4 = HexColor("#FFB117");
  static Color? sc3 = HexColor("#FFDC2E");
  static Color? sc2 = HexColor("#FAE39C");
  static Color? colorcardorder = HexColor("#E5E5E5");
}

class TextConstants {
  static TextStyle? textstyle = TextStyle(
      fontSize: 18.sp, fontFamily: 'newbodyfont', color: Colors.black);
  static TextStyle? textstyleforhistory = TextStyle(
      fontSize: 16.sp, fontFamily: 'newbodyfont', color: Colors.black);
  static TextStyle? textstyleforheader = TextStyle(
      fontSize: 20.sp, fontFamily: 'newbodyfont', color: Colors.black);
  static TextStyle? textStylenotes = TextStyle(
      fontSize: 18.sp, fontFamily: 'newbodyfont', color: Colors.grey[600]);
  static TextStyle? appbartextsyle = TextStyle(
      fontFamily: 'newtitlefont', fontSize: 25.sp, color: Colors.white);
  static TextStyle? textstyleheadnotice = TextStyle(
      fontSize: 20.sp, fontFamily: 'newbodyfont', color: Colors.white);
}

class Getallproduct {
  String codeproduct;
  String nameproduct;
  int amount;
  int amountpercrate;
  String productset;
  String alltype;
  int score;
  int price;
  int fav;

  Getallproduct(
      this.codeproduct,
      this.nameproduct,
      this.amount,
      this.amountpercrate,
      this.productset,
      this.alltype,
      this.score,
      this.price,
      this.fav);
}

class Getallcustomer {
  String cuscode;
  String cusname;
  String phone;
  String address;
  String codestore;
  String notes;
  int score;
  Getallcustomer(this.cuscode, this.cusname, this.phone, this.address,
      this.codestore, this.notes, this.score);
}

class Getalldealer {
  String dealercode;
  String dealername;
  String phone;
  String codestore;
  String notes;
  Getalldealer(
      this.dealercode, this.dealername, this.phone, this.codestore, this.notes);
}

//get data from table order by codestore and customer code
class GetorderBycodestoreandcuscodeandordernumber {
  int ordernumber;
  String codeproduct;
  String nameproduct;
  int amount;
  String pay;
  String notes;
  String date;
  num price;

  GetorderBycodestoreandcuscodeandordernumber(
      this.ordernumber,
      this.codeproduct,
      this.nameproduct,
      this.amount,
      this.pay,
      this.notes,
      this.date,
      this.price);
}

class Getalldelivery {
  int? orders;
  String? codeproduct;
  String? nameproduct;
  int numbers;
  String? address;
  String? iddelivery;
  String? username;
  int? success;
  int? companyid;
  String codestore;
  String? cpn_deliveryname;
  String? cpn_deliverylink;

  Getalldelivery(
      this.orders,
      this.codeproduct,
      this.nameproduct,
      this.numbers,
      this.address,
      this.iddelivery,
      this.username,
      this.success,
      this.companyid,
      this.codestore,
      this.cpn_deliveryname,
      this.cpn_deliverylink);
}

class Getdeliverylist {
  int? orders;
  String? codeproduct;
  String? nameproduct;
  int? numbers;
  String? address;

  Getdeliverylist(this.orders, this.codeproduct, this.nameproduct, this.numbers,
      this.address);
}

class Getuser {
  String position;
  Getuser(this.position);
}

class Getcustomerstore {
  String name;
  String code;
  Getcustomerstore(this.name, this.code);
}

class Getallorders {
  String cuscode;
  int ordernumber;
  String pay;
  num price;
  int saleconfirm;
  String cusname;
  int amountlist;
  String date;

  Getallorders(this.cuscode, this.ordernumber, this.pay, this.price,
      this.saleconfirm, this.cusname, this.amountlist, this.date);
}

// class for get data from noti database
class Getnotifordealer {
  int ordernumber;
  String fromwho;
  String towho;
  String message;
  String date;
  String namestore;
  String pay;
  int countorder;
  num priceall;
  String company;
  String track;

  Getnotifordealer(
      this.ordernumber,
      this.fromwho,
      this.towho,
      this.message,
      this.date,
      this.namestore,
      this.pay,
      this.countorder,
      this.priceall,
      this.company,
      this.track);
}
