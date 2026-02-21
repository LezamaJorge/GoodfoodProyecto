// ignore_for_file: depend_on_referenced_packages, deprecated_member_use

import 'package:admin_panel/widget/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/utils/app_them_data.dart';

import '../utils/app_colors.dart';

class CustomButtonWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final Color? buttonColor;
  final Color? borderColor;
  final Color? textColor;
  final String? title;
  final double? textSize;
  final double? radius;

  final Widget? titleWidget;

  final VoidCallback? onPress;

  const CustomButtonWidget({
    super.key,
    this.width,
    this.height,
    this.padding,
    this.buttonColor,
    this.borderColor,
    this.textSize,
    this.radius,

    required this.title,
    this.textColor,
    this.titleWidget,

    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: onPress,
      child: Container(
        width: width,
        height: height,
        decoration:buttonColor==null ? BoxDecoration(
          color: AppThemeData.primary500,
          borderRadius: BorderRadius.circular(radius??4),
        ):BoxDecoration(
          color: buttonColor,
          border: Border.all(color: borderColor??buttonColor!),
          borderRadius: BorderRadius.circular(radius??4),
        ),
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: Padding(
              padding: paddingEdgeInsets(vertical: 10,horizontal: 16),
              child: titleWidget ??
                  Text(
                    title!,
                    style: TextStyle(
                      fontFamily: FontFamily.regular,
                      fontSize: textSize ?? 14,
                      fontWeight: FontWeight.w700,
                      color: textColor ?? (AppThemeData.primaryWhite),
                    ),
                  ),
            ),
          ),
        ),
      ),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return AppButton(
  //       color: buttonColor ?? AppThemeData.primary500,
  //       elevation: 0,
  //       shapeBorder: RoundedRectangleBorder(
  //         borderRadius: radius(borderRadius ?? 10),
  //       ),
  //       padding: padding ?? paddingEdgeInsets(),
  //       height: height ?? 50,
  //       width: width,
  //       onTap: onPress,
  //       child: Text(title ?? "", style: TextStyle(fontFamily: AppThemeData.medium, fontSize: 16, color: textColor ?? AppThemeData.primaryBlack), textAlign: TextAlign.center));
  // }
}

class CustomCard extends StatelessWidget {
  final String title;
  final String value;
  final String imageAssets;

  const CustomCard({super.key, required this.value, required this.imageAssets, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        margin: const EdgeInsets.all(10),
        // padding: const EdgeInsets.only(left: 25),
        height: 100,
        width: 310,
        decoration: BoxDecoration(
          image: const DecorationImage(image: AssetImage("assets/image/Card1.png"), fit: BoxFit.fill),
          border: Border.all(color: AppThemeData.lightGrey06.withOpacity(.5)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(shape: BoxShape.circle, color: AppThemeData.primaryWhite.withOpacity(.2)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    imageAssets,
                    color: Colors.white,
                    height: 30,
                    width: 30,
                  ),
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      style: Constant.defaultTextStyle(size: 14, color: AppThemeData.primaryWhite.withOpacity(.7)),
                      textAlign: TextAlign.center,
                    ),
                    // SizedBox(height: 5,),
                    FittedBox(
                      child: Text(
                        value,
                        style: Constant.defaultTextStyle(size: 18, color: AppThemeData.primaryWhite),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
