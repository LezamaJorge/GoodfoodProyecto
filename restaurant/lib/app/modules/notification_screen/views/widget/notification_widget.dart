import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/models/notification_model.dart';
import 'package:restaurant/app/widget/global_widgets.dart';
import 'package:restaurant/app/widget/text_widget.dart';
import 'package:restaurant/themes/app_fonts.dart';
import 'package:restaurant/themes/app_theme_data.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';

class NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final Function onDelete;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Slidable(
      key: ValueKey(notification.id),
      endActionPane: ActionPane(
        extentRatio: 0.20,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => onDelete(notification),
            backgroundColor: AppThemeData.danger300,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Container(
        margin:  paddingEdgeInsets(horizontal: 0, vertical: 8),
        alignment: Alignment.center,
        padding:  paddingEdgeInsets(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: themeChange.isDarkTheme() ? AppThemeData.grey800 : AppThemeData.grey100,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextCustom(
                  title: notification.title!,
                  fontFamily: FontFamily.medium,
                  fontSize: 16,
                  maxLine: 2,
                ),

              ],
            ),
            spaceH(height: 2.h),
            TextCustom(
              title: notification.description!,
              fontFamily: FontFamily.medium,
              fontSize: 14,
              textAlign: TextAlign.start,
              maxLine: 2,
              color: AppThemeData.grey600,
            ),
          ],
        ),
      ),
    );
  }
}
