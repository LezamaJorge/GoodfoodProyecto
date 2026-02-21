// ignore_for_file: depend_on_referenced_packages

import 'package:admin_panel/app/utils/app_colors.dart';
import 'package:admin_panel/app/utils/dark_theme_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/utils/screen_size.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class NetworkImageWidget extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final Widget? errorWidget;
  final BoxFit? fit;
  final double? borderRadius;
  final Color? color;

  const NetworkImageWidget({
    super.key,
    this.height,
    this.width,
    this.fit,
    required this.imageUrl,
    this.borderRadius,
    this.errorWidget,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Container(
      decoration: BoxDecoration(
        // color: AppColors.darkGrey01,
        borderRadius: BorderRadius.circular(borderRadius ?? 60),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? 60),
        child: CachedNetworkImage(
          fit: fit ?? BoxFit.cover,
          height: height ?? ScreenSize.height(8, context),
          width: width ?? ScreenSize.width(15, context),
          imageUrl: imageUrl,
          color: color,
          progressIndicatorBuilder: (context, url, downloadProgress) => Center(
            child: Shimmer.fromColors(
              baseColor: themeChange.isDarkTheme() ? AppThemeData.lynch800 :AppThemeData.lynch200,
              highlightColor: themeChange.isDarkTheme() ? AppThemeData.lynch800 :AppThemeData.lynch200,
              child: Container(
                height: height ?? ScreenSize.height(8, context),
                width: width ?? ScreenSize.width(15, context),
                color: AppThemeData.lynch200,
              ),
            ),
          ),
          errorWidget: (context, url, error) =>
              errorWidget ??
              Image.asset(
                Constant.userPlaceHolder,
                height: height ?? ScreenSize.height(8, context),
                width: width ?? ScreenSize.width(15, context),
              ),
        ),
      ),
    );
  }
}
