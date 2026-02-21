// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/widget/text_widget.dart';
import 'package:restaurant/themes/app_fonts.dart';
import 'package:restaurant/themes/app_theme_data.dart';
import 'package:restaurant/themes/responsive.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';
import 'package:timelines_plus/timelines_plus.dart';

class PickDropPointView extends StatelessWidget {
  final String pickUpAddress;
  final String dropOutAddress;

  const PickDropPointView({
    super.key,
    required this.pickUpAddress,
    required this.dropOutAddress,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Container(
      width: Responsive.width(100, context),
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: themeChange.isDarkTheme() ? AppThemeData.surface1000 : AppThemeData.surface50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Timeline.tileBuilder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        theme: TimelineThemeData(
          nodePosition: 0,
          indicatorPosition: 0,
        ),
        builder: TimelineTileBuilder.connected(
          contentsAlign: ContentsAlign.basic,
          connectionDirection: ConnectionDirection.before,
          indicatorBuilder: (context, index) {
            return SvgPicture.asset(
              index == 0 ? "assets/icons/ic_pick_up.svg" : "assets/icons/ic_drop_out.svg",
              height: 24.h,
              width: 24.w,
              color: index == 0 ? AppThemeData.primary300 : AppThemeData.secondary300,
            );
          },
          connectorBuilder: (context, index, connectorType) {
            return const DashedLineConnector(
              gap: 2,
              dash: 3,
              thickness: 1,
              endIndent: 00,
              color: Color(0xfd4A4AF2),
            );
          },
          contentsBuilder: (context, index) => index == 0
              ? Container(
                  width: Responsive.width(100, context),
                  // padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextCustom(
                        title: 'Pickup Point',
                        fontSize: 14,
                        fontFamily: FontFamily.light,
                        textAlign: TextAlign.start,
                        color: themeChange.isDarkTheme() ? AppThemeData.grey200 : AppThemeData.grey800,
                      ),
                      TextCustom(
                        title: pickUpAddress,
                        fontSize: 16,
                        maxLine: 3,
                        textAlign: TextAlign.start,
                        fontFamily: FontFamily.medium,
                        color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                      ),
                    ],
                  ),
                )
              : Container(
                  width: Responsive.width(100, context),
                  // padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextCustom(
                        title: 'Dropout Point',
                        fontSize: 14,
                        fontFamily: FontFamily.light,
                        textAlign: TextAlign.start,
                        color: themeChange.isDarkTheme() ? AppThemeData.grey200 : AppThemeData.grey800,
                      ),
                      TextCustom(
                        title: dropOutAddress,
                        fontSize: 16,
                        maxLine: 3,
                        fontFamily: FontFamily.medium,
                        textAlign: TextAlign.start,
                        color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                      ),
                    ],
                  ),
                ),
          itemCount: 2,
        ),
      ),
    );
  }
}
