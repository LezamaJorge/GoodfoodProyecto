// ignore_for_file: deprecated_member_use, use_super_parameters

import 'dart:developer';

import 'package:admin_panel/app/components/custom_button.dart';
import 'package:admin_panel/app/components/dialog_box.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/models/constant_model.dart';
import 'package:admin_panel/app/modules/policy_setting/controllers/about_app_controller.dart';
import 'package:admin_panel/app/utils/app_colors.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:admin_panel/app/utils/responsive.dart';
import 'package:admin_panel/widget/common_ui.dart';

import 'package:admin_panel/widget/container_custom.dart';
import 'package:admin_panel/widget/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:provider/provider.dart';

import '../../../../constant/constants.dart';
import '../../../../utils/dark_theme_provider.dart';

class AboutAppView extends GetView<AboutAppController> {
  AboutAppView({Key? key}) : super(key: key);
  final HtmlEditorController htmlEditorController = HtmlEditorController();

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return GetBuilder<AboutAppController>(
      init: AboutAppController(),
      builder: (controller) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
            ContainerCustom(
              child: Column(children: [
                ResponsiveWidget.isDesktop(context)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                style: TextButton.styleFrom(backgroundColor: Colors.blueGrey),
                                onPressed: () {
                                  htmlEditorController.undo();
                                },
                                icon: const Icon(
                                  Icons.undo_outlined,
                                  color: AppThemeData.lynch500,
                                ),
                              ),
                              spaceW(),
                              IconButton(
                                  style: TextButton.styleFrom(backgroundColor: Colors.blueGrey),
                                  onPressed: () {
                                    htmlEditorController.clear();
                                  },
                                  icon: const Icon(
                                    Icons.refresh,
                                    color: AppThemeData.lynch500,
                                  )),
                              spaceW(),
                              IconButton(
                                  style: TextButton.styleFrom(backgroundColor: Colors.blueGrey),
                                  onPressed: () {
                                    htmlEditorController.toggleCodeView();
                                  },
                                  icon: const Icon(
                                    Icons.code,
                                    color: AppThemeData.lynch500,
                                  )),
                              spaceW(),
                              CustomButtonWidget(
                                padding: const EdgeInsets.symmetric(horizontal: 22),
                                title: "Save".tr,
                                onPress: () async {
                                  if (Constant.isDemo) {
                                    DialogBox.demoDialogBox();
                                  } else {
                                    var txt = await htmlEditorController.getText();
                                    if (txt.contains('src="data:')) {
                                      txt = '<text removed due to base-64 data, displaying the text could cause the app to crash>';
                                    }
                                    controller.result.value = txt;
                                    Constant.waitingLoader();
                                    Constant.constantModel!.aboutApp = controller.result.value;
                                    await FireStoreUtils.setGeneralSetting(Constant.constantModel!).then((value) {
                                      ShowToastDialog.successToast("About App updated".tr);
                                      Get.back();
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          spaceH(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                style: TextButton.styleFrom(backgroundColor: Colors.blueGrey),
                                onPressed: () {
                                  htmlEditorController.undo();
                                },
                                icon: const Icon(
                                  Icons.undo_outlined,
                                  color: AppThemeData.lynch500,
                                ),
                              ),
                              spaceW(),
                              IconButton(
                                  style: TextButton.styleFrom(backgroundColor: Colors.blueGrey),
                                  onPressed: () {
                                    htmlEditorController.clear();
                                  },
                                  icon: const Icon(
                                    Icons.refresh,
                                    color: AppThemeData.lynch500,
                                  )),
                              spaceW(),
                              IconButton(
                                  style: TextButton.styleFrom(backgroundColor: Colors.blueGrey),
                                  onPressed: () {
                                    htmlEditorController.toggleCodeView();
                                  },
                                  icon: const Icon(
                                    Icons.code,
                                    color: AppThemeData.lynch500,
                                  )),
                              spaceW(),
                              CustomButtonWidget(
                                padding: const EdgeInsets.symmetric(horizontal: 22),
                                title: "Save",
                                onPress: () async {
                                  if (Constant.isDemo) {
                                    DialogBox.demoDialogBox();
                                  } else {
                                    var txt = await htmlEditorController.getText();
                                    if (txt.contains('src="data:')) {
                                      txt = '<text removed due to base-64 data, displaying the text could cause the app to crash>';
                                    }
                                    controller.result.value = txt;
                                    Constant.waitingLoader();
                                    Constant.constantModel!.aboutApp = controller.result.value;
                                    await FireStoreUtils.setGeneralSetting(Constant.constantModel!).then((value) {
                                      ShowToastDialog.successToast("About App updated".tr);
                                      Get.back();
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                spaceH(height: 20),
                FutureBuilder<ConstantModel?>(
                    future: FireStoreUtils.getGeneralSetting(),
                    builder: (BuildContext context, AsyncSnapshot<ConstantModel?> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const TextShimmer();
                        default:
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            ConstantModel constantModel = snapshot.data!;
                            return SingleChildScrollView(
                              child: Container(
                                height: 0.6.sh,
                                decoration: BoxDecoration(
                                  color: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch50,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: HtmlEditor(
                                  controller: htmlEditorController,
                                  htmlEditorOptions: HtmlEditorOptions(
                                    hint: 'Your text here...'.tr,
                                    initialText: constantModel.aboutApp,
                                    shouldEnsureVisible: true,
                                  ),
                                  htmlToolbarOptions: HtmlToolbarOptions(
                                    toolbarPosition: ToolbarPosition.aboveEditor,

                                    //by default
                                    toolbarType: ToolbarType.nativeScrollable,
                                    buttonSelectedColor: AppThemeData.primary500,
                                    dropdownIconColor: AppThemeData.lynch500,
                                    buttonSplashColor: themeChange.isDarkTheme() ? AppThemeData.primary950 : AppThemeData.primary100,
                                    buttonFillColor: themeChange.isDarkTheme() ? AppThemeData.primary950 : AppThemeData.primary100,
                                    //by default
                                    onButtonPressed: (ButtonType type, bool? status, Function? updateStatus) {
                                      return true;
                                    },
                                    onDropdownChanged: (DropdownType type, dynamic changed, Function(dynamic)? updateSelectedItem) {
                                      return true;
                                    },
                                    mediaLinkInsertInterceptor: (String url, InsertFileType type) {
                                      return true;
                                    },
                                  ),
                                  otherOptions: const OtherOptions(height: 500),
                                  callbacks: Callbacks(
                                      onBeforeCommand: (String? currentHtml) {},
                                      onChangeContent: (String? changed) {},
                                      onChangeCodeview: (String? changed) {},
                                      onChangeSelection: (EditorSettings settings) {},
                                      onDialogShown: () {},
                                      onEnter: () {},
                                      onFocus: () {},
                                      onBlur: () {},
                                      onBlurCodeview: () {},
                                      onInit: () {},
                                      onImageUploadError: (FileUpload? file, String? base64Str, UploadError error) {
                                        if (file != null) {}
                                      },
                                      onKeyDown: (int? keyCode) {},
                                      onKeyUp: (int? keyCode) {},
                                      onMouseDown: () {},
                                      onMouseUp: () {},
                                      onNavigationRequestMobile: (String url) {
                                        return NavigationActionPolicy.ALLOW;
                                      },
                                      onPaste: () {},
                                      onScroll: () {}),
                                  plugins: [
                                    SummernoteAtMention(
                                        getSuggestionsMobile: (String value) {
                                          var mentions = <String>['test1', 'test2', 'test3'];
                                          return mentions.where((element) => element.contains(value)).toList();
                                        },
                                        mentionsWeb: ['test1', 'test2', 'test3'],
                                        onSelect: (String value) {
                                          log(value);
                                        }),
                                  ],
                                ),
                              ),
                            );
                          }
                      }
                    }),
                spaceH(),
              ]),
            )
          ]),
        );
      },
    );
  }
}
