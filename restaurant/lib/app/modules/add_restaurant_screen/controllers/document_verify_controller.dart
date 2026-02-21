import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurant/app/models/document_model.dart';
import 'package:restaurant/app/models/owner_model.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/constant/show_toast_dialogue.dart';
import 'package:restaurant/utils/fire_store_utils.dart';

class DocumentVerifyController extends GetxController {
  RxList<DocumentModel> documentsList = <DocumentModel>[].obs;
  RxList<VerifyDocumentModel> verifyDocumentList = <VerifyDocumentModel>[].obs;
  Rx<OwnerModel> ownerModel = OwnerModel().obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    try {
      ownerModel.value = await FireStoreUtils.getOwnerProfile(FireStoreUtils.getCurrentUid().toString()) ?? OwnerModel();
      documentsList.value = await FireStoreUtils.getDocumentsList() ?? [];

      verifyDocumentList.clear();

      for (var doc in documentsList) {
        // Check if this doc already exists in owner's verifyDocument
        var existing = ownerModel.value.verifyDocument?.firstWhereOrNull(
          (v) => v.documentId == doc.id,
        );

        if (existing != null) {
          verifyDocumentList.add(existing);
        } else {
          verifyDocumentList.add(
            VerifyDocumentModel(
              documentId: doc.id,
              documentImage: "",
              status: "pending",
            ),
          );
        }
      }

      isLoading.value = false;
    } catch (e, stack) {
      developer.log("Error fetching documents list:", error: e, stackTrace: stack);
    }
  }

  final ImagePicker documentImagePicker = ImagePicker();

  Future<void> documentPickFile({
    required ImageSource source,
    required VerifyDocumentModel verifyDocumentModel,
    required int index,
  }) async {
    try {
      XFile? image = await documentImagePicker.pickImage(
        source: source,
        imageQuality: 60,
      );

      if (image == null) return;

      final allowedExtensions = ['jpg', 'jpeg', 'png'];
      final extension = image.name.split('.').last.toLowerCase();

      if (!allowedExtensions.contains(extension)) {
        ShowToastDialog.toast("Only JPG, JPEG and PNG images are allowed".tr);
        return;
      }

      Uint8List? compressedBytes = await FlutterImageCompress.compressWithFile(
        image.path,
        quality: 50,
      );

      if (compressedBytes != null) {
        final tempPath = "${Directory.systemTemp.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";
        File compressedFile = File(tempPath);
        await compressedFile.writeAsBytes(compressedBytes);

        verifyDocumentList[index].documentImage = compressedFile.path;
        verifyDocumentList[index].status = "pending";
        verifyDocumentList.refresh();
      } else {
        throw Exception("Image compression failed");
      }
    } on PlatformException catch (e, stack) {
      developer.log("Error picking document image:", error: e, stackTrace: stack);
    } catch (e, stack) {
      developer.log("Error picking document image:", error: e, stackTrace: stack);
    }
  }

  Future<void> uploadDocument() async {
    try {
      ShowToastDialog.showLoader("Please Wait..".tr);

      if (verifyDocumentList.isNotEmpty) {
        for (int i = 0; i < verifyDocumentList.length; i++) {
          VerifyDocumentModel verifyDocumentModel = verifyDocumentList[i];

          if (!Constant.hasValidUrl(verifyDocumentModel.documentImage.toString())) {
            try {
              String image = await Constant.uploadImageToFireStorage(
                File(verifyDocumentModel.documentImage.toString()),
                "documentImage/${verifyDocumentModel.documentId}/${FireStoreUtils.getCurrentUid()}",
                verifyDocumentModel.documentImage!.split('/').last,
              );

              verifyDocumentModel.documentImage = image;
              verifyDocumentModel.status = "uploaded";
            } catch (e, stack) {
              developer.log("Error uploading document image:", error: e, stackTrace: stack);
            }
          }
          verifyDocumentList[i] = verifyDocumentModel;
        }
      }

      ownerModel.value.verifyDocument = verifyDocumentList;
      await FireStoreUtils.addOwner(ownerModel.value).then((_) async {
        ShowToastDialog.closeLoader();
        getData();
        ShowToastDialog.toast('your documents is send to admin. please contact administrator'.tr);
      });
    } catch (e, stack) {
      developer.log("Error uploading documents:", error: e, stackTrace: stack);
      ShowToastDialog.closeLoader();
    }
  }

  bool checkCondition() {
    try {
      bool isEmpty = false;
      for (var element in verifyDocumentList) {
        if (element.documentImage!.isEmpty) {
          isEmpty = true;
          break;
        }
      }
      return isEmpty;
    } catch (e, stack) {
      developer.log("Error in checkCondition:", error: e, stackTrace: stack);
      return true;
    }
  }
}
