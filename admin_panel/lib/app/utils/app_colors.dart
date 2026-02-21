// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';

class AppThemeData {
  static LinearGradient primaryGradient = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xffFF5D5D),
      Color(0xffFFB648),
    ],
  );

  static LinearGradient appNameColor = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xffF24A4A),
      Color(0xffFF790F),
    ],
  );

  static Color primaryWhite = Colors.white;
  static Color primaryBlack = Colors.black;
  static const Color background = Color(0xff7D8793);
  static const Color textBlack = Color(0xFF242424);
  static const Color textGrey = Color(0xFF707070);
  static const Color chartColor = Color(0xFF0CB9C1);

  static const Color appColor = Color(0xff331D00);
  static const Color primary = Color(0xff331D00);
  static const Color borderGrey = Color(0xFF7D7D7D);

  static const Color primary950 = Color(0xff431207);
  static const Color primary900 = Color(0xff7C2A12);
  static const Color primary800 = Color(0xff993013);
  static const Color primary700 = Color(0xffC13C0D);
  static const Color primary600 = Color(0xffF25812);
  static const Color primary500 = Color(0xffF98339);
  static const Color primary400 = Color(0xffFB9347);
  static const Color primary300 = Color(0xffFCB675);
  static const Color primary200 = Color(0xffFED5AA);
  static const Color primary100 = Color(0xffFFECD5);
  static const Color primary50 =  Color(0xffFFF7ED);

  static const Color secondary950 = Color(0xff331000);
  static const Color secondary900 = Color(0xff651F01);
  static const Color secondary800 = Color(0xff982F01);
  static const Color secondary700 = Color(0xffCB3E01);
  static const Color secondary600 = Color(0xffFE4E01);
  static const Color secondary500 = Color(0xffFE7235);
  static const Color secondary400 = Color(0xffFF7C64);
  static const Color secondary300 = Color(0xffFFAC9D);
  static const Color secondary200 = Color(0xffFFCEC5);
  static const Color secondary100 = Color(0xffFFE4DF);
  static const Color secondary50 = Color(0xffFFF3F1);

  static const Color lynch950 = Color(0xff181B20);
  static const Color lynch900 = Color(0xff343A46);
  static const Color lynch800 = Color(0xff3A4252);
  static const Color lynch700 = Color(0xff434E61);
  static const Color lynch600 = Color(0xff526077);
  static const Color lynch500 = Color(0xff64748B);
  static const Color lynch400 = Color(0xff8695AA);
  static const Color lynch300 = Color(0xffB1BBC8);
  static const Color lynch200 = Color(0xffD5D9E2);
  static const Color lynch100 = Color(0xffECEEF2);
  static const Color lynch50 = Color(0xffF6F7F9);
  static const Color lynch25 = Color(0xffFFFFFF);

  static const Color green950 = Color(0xff062D0E);
  static const Color green900 = Color(0xff165122);
  static const Color green800 = Color(0xff186326);
  static const Color green700 = Color(0xff187D2A);
  static const Color green600 = Color(0xff1A9F31);
  static const Color green500 = Color(0xff27C041);
  static const Color green400 = Color(0xff4CD964);
  static const Color green300 = Color(0xff89EC9A);
  static const Color green200 = Color(0xffBDF5C6);
  static const Color green100 = Color(0xffDDFBE1);
  static const Color green50 = Color(0xffF0FDF1);

  static const Color success600 = Color(0xff04150E);
  static const Color success500 = Color(0xff115536);
  static const Color success400 = Color(0xff1E955E);
  static const Color success300 = Color(0xff2AD587);
  static const Color success200 = Color(0xff6AE2AB);
  static const Color success100 = Color(0xffAAEFCF);
  static const Color success50 = Color(0xffEAFBF3);

  static const Color danger600 = Color(0xff1A0300);
  static const Color danger500 = Color(0xff590900);
  static const Color danger400 = Color(0xff980F00);
  static const Color danger300 = Color(0xffD61600);
  static const Color danger200 = Color(0xffE45C4C);
  static const Color danger100 = Color(0xffF2A298);
  static const Color danger50 = Color(0xffFFE8E5);

  static const Color blue950 = Color(0xff0E315D);
  static const Color blue900 = Color(0xff0D519B);
  static const Color blue800 = Color(0xff085EC5);
  static const Color blue700 = Color(0xff068FFF);
  static const Color blue600 = Color(0xff007BFF);
  static const Color blue500 = Color(0xff1EADFF);
  static const Color blue400 = Color(0xff48CBFF);
  static const Color blue300 = Color(0xff83DFFF);
  static const Color blue200 = Color(0xffB5EAFF);
  static const Color blue100 = Color(0xffD6F2FF);
  static const Color blue50 = Color(0xffEDFAFF);

  static const Color tertiary950 = Color(0xff020b17);
  static const Color tertiary900 = Color(0xff0b2242);
  static const Color tertiary800 = Color(0xff14396d);
  static const Color tertiary700 = Color(0xff1d5098);
  static const Color tertiary600 = Color(0xff2667c3);
  static const Color tertiary500 = Color(0xff2F80ED);
  static const Color tertiary400 = Color(0xff5497f0);
  static const Color tertiary300 = Color(0xff79aef3);
  static const Color tertiary200 = Color(0xff9ec5f6);
  static const Color tertiary100 = Color(0xffc3dcf9);
  static const Color tertiary50 = Color(0xffe8f1fd);

  static const Color yellow950 = Color(0xff442504);
  static const Color yellow900 = Color(0xff74470F);
  static const Color yellow800 = Color(0xff89570A);
  static const Color yellow700 = Color(0xffA67102);
  static const Color yellow600 = Color(0xffD19D00);
  static const Color yellow500 = Color(0xffFEFFC1);
  static const Color yellow400 = Color(0xffFFD600);
  static const Color yellow300 = Color(0xffFFE50D);
  static const Color yellow200 = Color(0xffFFF441);
  static const Color yellow100 = Color(0xffFFFD86);
  static const Color yellow50 = Color(0xffFFFFE7);

  static const Color red950 = Color(0xff4B0804);
  static const Color red900 = Color(0xff881A14);
  static const Color red800 = Color(0xffA5170F);
  static const Color red700 = Color(0xffC8170D);
  static const Color red600 = Color(0xffED2015);
  static const Color red500 = Color(0xffFF3B30);
  static const Color red400 = Color(0xffFF6C64);
  static const Color red300 = Color(0xffFFA29D);
  static const Color red200 = Color(0xffFFC8C5);
  static const Color red100 = Color(0xffFFE1DF);
  static const Color red50 = Color(0xffFFF2F1);

  static const Color lightGrey01 = Color(0xffFEFEFE);
  static const Color lightGrey02 = Color(0xffFBFCFD);
  static const Color lightGrey05 = Color(0xffF5F6F9);
  static const Color lightGrey06 = Color(0xffF3F4F7);
  static const Color lightGrey07 = Color(0xffDDDEE1);
  static const Color lightGrey08 = Color(0xffb7b7b9);
  static const Color lightGrey10 = Color(0xff666668);

  static const Color black02 = Color(0x33000000);
  static const Color black03 = Color(0x4D000000);
  static const Color black04 = Color(0x66000000);
  static const Color black05 = Color(0x80000000);
  static const Color black07 = Color(0xB3000000);
  static const Color black08 = Color(0xCC000000);
  static const Color black09 = Color(0xE6000000);

  static const Color gallery50 = Color(0xFFF8F8F8);
  static const Color gallery100 = Color(0xFFEDEDED);
  static const Color gallery400 = Color(0xFF989898);
  static const Color gallery500 = Color(0xFF7C7C7C);
  static const Color gallery700 = Color(0xFF525252);
  static const Color gallery800 = Color(0xFF464646);
  static const Color gallery950 = Color(0xFF292929);

  static const Color accent600 = Color(0xff020218);
  static const Color accent500 = Color(0xff1A1A61);
  static const Color accent400 = Color(0xff3232AA);
  static const Color accent300 = Color(0xff4A4AF2);
  static const Color accent200 = Color(0xff7E7EF6);
  static const Color accent100 = Color(0xffB2B2FA);
  static const Color accent50 = Color(0xffE7E7FD);

  static const Color warning200 = Color(0xffF99007);
}
