import 'package:admin_panel/app/utils/app_colors.dart';
import 'package:admin_panel/app/utils/app_them_data.dart';
import 'package:admin_panel/widget/global_widgets.dart';
import 'package:admin_panel/widget/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/dark_theme_provider.dart';

class PriceRowView extends StatelessWidget {
  final String price;
  final String title;
  final Color? priceColor;
  final Color? titleColor;

  const PriceRowView({
    super.key,
    required this.price,
    required this.title,
    required this.priceColor,
    required this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: SizedBox(
            child: TextCustom(
              title: title,
              fontFamily: FontFamily.regular,
              fontSize: 14,
              color: titleColor ?? (themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite),

            ),
          ),
        ),
        spaceW(width: 10),
        SizedBox(
          child: Text(
            price,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 14,
                color: priceColor ?? (themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite),
                fontFamily: FontFamily.medium),
            // style:
            // GoogleFonts.inter(
            //   color: priceColor,
            //   fontSize: 14,
            //   fontWeight: FontWeight.w600,
            // ),
          ),
        ),
      ],
    );
  }
}
