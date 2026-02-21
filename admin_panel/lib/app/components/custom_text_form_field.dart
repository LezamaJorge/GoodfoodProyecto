// ignore_for_file: prefer_typing_uninitialized_variables, depend_on_referenced_packages, must_be_immutable, strict_top_level_inference

import 'package:admin_panel/app/utils/app_colors.dart';
import 'package:admin_panel/app/utils/app_them_data.dart';
import 'package:admin_panel/app/utils/dark_theme_provider.dart';
import 'package:admin_panel/widget/global_widgets.dart';
import 'package:admin_panel/widget/text_widget.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final String title;
  final validator;
  final String? icon;
  bool? obscureText = false;
  Color? color;
  Color? cursorColor;
  final int? maxLine;
  final TextEditingController controller;
  final Function(String)? onFieldSubmitted;
  final Widget? prefix;
  final Widget? suffix;
  final bool? enable;
  final bool? enabled;
  final bool? readOnly;
  final bool tooltipsShow;
  final String? tooltipsText;
  final Function()? onPress;
  final TextInputType? textInputType;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;

  CustomTextFormField({
    super.key,
    this.textInputType,
    this.validator,
    this.enable,
    this.icon,
    this.prefix,
    this.suffix,
    this.obscureText,
    this.inputFormatters,
    this.tooltipsText,
    this.tooltipsShow = false,
    this.onPress,
    required this.hintText,
    required this.title,
    required this.controller,
    this.enabled,
    this.readOnly,
    this.color,
    this.cursorColor,
    this.maxLine,
    this.focusNode,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty) ...{
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              tooltipsShow == true
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextCustom(
                          title: title.tr,
                          maxLine: 1,
                          fontSize: 14,
                        ),
                        Tooltip(
                          padding: paddingEdgeInsets(horizontal: 10, vertical: 0),
                          message: tooltipsText,
                          child: IconButton(
                            icon: const Icon(
                              Icons.info,
                              color: AppThemeData.lynch500,
                              size: 22,
                            ),
                            onPressed: () {},
                          ),
                        )
                      ],
                    )
                  : TextCustom(
                      title: title.tr,
                      fontSize: 14,
                    ),
              spaceH(height: tooltipsShow == true ? 0 : 10)
            ],
          )
        },
        TextFormField(
            validator: validator ?? (value) => value != null && value.isNotEmpty ? null : 'This field required'.tr,
            keyboardType: textInputType ?? TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            controller: controller,
            textAlign: TextAlign.start,
            inputFormatters: inputFormatters,
            onTap: onPress,
            enabled: enabled,
            obscureText: obscureText ?? false,
            readOnly: readOnly ?? false,
            maxLines: maxLine ?? 1,
            cursorColor: cursorColor ?? AppThemeData.primary500,
            textAlignVertical: TextAlignVertical.top,
            textInputAction: TextInputAction.next,
            focusNode: focusNode,
            onFieldSubmitted: onFieldSubmitted,
            style: TextStyle(color: themeChange.isDarkTheme() ? AppThemeData.lynch50 : AppThemeData.lynch950, fontFamily: FontFamily.regular, fontSize: 14),
            decoration: InputDecoration(
                errorStyle: const TextStyle(fontFamily: FontFamily.regular),
                isDense: true,
                filled: true,
                enabled: enable ?? true,
                fillColor: color ?? (themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch50),
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: prefix != null ? 0 : 16),
                suffixIcon: suffix,
                prefixIcon: prefix,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100, width: 1),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100, width: 1),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100, width: 1),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: const BorderSide(color: AppThemeData.secondary500, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: const BorderSide(color: AppThemeData.primary300, width: 1),
                ),
                hintText: hintText.tr,
                hintStyle: TextStyle(fontSize: 14, color: themeChange.isDarkTheme() ? AppThemeData.lynch300 : AppThemeData.lynch400, fontFamily: FontFamily.regular))),
      ],
    );
  }
}

class MobileNumberTextField extends StatelessWidget {
  final String title;
  String countryCode = "";
  final TextEditingController controller;

  final Function() onPress;
  final bool? enabled;
  final bool? readOnly;

  MobileNumberTextField({super.key, required this.controller, required this.countryCode, required this.onPress, required this.title, this.enabled, this.readOnly});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextCustom(
          title: title,
          fontSize: 14,
        ),
        spaceH(height: 10),
        TextFormField(
          validator: (value) => value != null && value.isNotEmpty ? null : 'phone number required'.tr,
          keyboardType: TextInputType.number,
          controller: controller,
          textAlign: TextAlign.start,
          readOnly: readOnly ?? false,
          cursorColor: AppThemeData.primary500,
          style: TextStyle(color: themeChange.isDarkTheme() ? AppThemeData.lynch50 : AppThemeData.lynch950, fontFamily: FontFamily.regular, fontSize: 14),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
              errorStyle: const TextStyle(color: Colors.red),
              isDense: true,
              filled: true,
              enabled: enabled ?? true,
              fillColor: (themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch50),
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              prefixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CountryCodePicker(
                    searchStyle: TextStyle(color: themeChange.isDarkTheme() ? AppThemeData.lynch100 : AppThemeData.lynch900, fontFamily: FontFamily.regular),
                    showFlag: true,
                    onChanged: (value) {
                      countryCode = value.dialCode.toString();
                    },
                    dialogTextStyle: TextStyle(fontFamily: FontFamily.regular, color: themeChange.isDarkTheme() ? AppThemeData.lynch100 : AppThemeData.lynch900),
                    dialogBackgroundColor: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                    initialSelection: countryCode,
                    comparator: (a, b) => b.name!.compareTo(a.name.toString()),
                    dialogSize: Size(200.w, 600.h),
                    backgroundColor: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                    flagDecoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                    ),
                    textStyle: TextStyle(fontSize: 15, color: themeChange.isDarkTheme() ? AppThemeData.lynch300 : AppThemeData.lynch700, fontFamily: FontFamily.regular),
                  ),
                  Text(
                    "|",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: FontFamily.light,
                      color: themeChange.isDarkTheme() ? AppThemeData.lynch600 : AppThemeData.lynch400,
                    ),
                  ),
                  spaceW(width: 16),
                ],
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100, width: 1),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100, width: 1),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: AppThemeData.secondary500, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: AppThemeData.primary300, width: 1),
              ),
              hintText: "Enter Phone number".tr,
              hintStyle: TextStyle(fontSize: 15, color: themeChange.isDarkTheme() ? AppThemeData.lynch300 : AppThemeData.lynch400, fontFamily: FontFamily.regular)),
        ),
      ],
    );
  }
}
