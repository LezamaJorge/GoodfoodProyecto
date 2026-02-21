import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/widget/global_widgets.dart';
import 'package:restaurant/themes/app_theme_data.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';

class ContainerCustom extends StatelessWidget {
  final AlignmentGeometry alignment;
  final EdgeInsetsGeometry? padding;
  final Widget? child;
  final Color? borderColor;

  const ContainerCustom({
    super.key,
    this.alignment = Alignment.center,
    this.padding,
    this.borderColor,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Container(
        margin: paddingEdgeInsets(horizontal: 0, vertical: 8),
        alignment: alignment,
        padding: padding ?? paddingEdgeInsets(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: themeChange.isDarkTheme() ? AppThemeData.surface1000 : AppThemeData.surface50,
        ),
        child: child);
  }
}
