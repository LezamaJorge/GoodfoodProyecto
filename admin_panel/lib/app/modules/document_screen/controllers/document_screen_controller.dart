// ignore_for_file: depend_on_referenced_packages

import 'package:admin_panel/app/constant/collection_name.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/models/documents_model.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../views/document_screen_view.dart';

class DocumentScreenController extends GetxController {
  RxString title = "Document".tr.obs;

  Rx<TextEditingController> documentNameController = TextEditingController().obs;
  Rx<SideAt> documentSide = SideAt.isOneSide.obs;
  RxBool isEditing = false.obs;
  RxBool isLoading = false.obs;
  RxBool isActive = true.obs;
  Rx<String> editingId = "".obs;
  RxList<DocumentsModel> documentsList = <DocumentsModel>[].obs;
  List<String> documentType = ["Driver", "Vendor"];
  RxString selectedDocumentType = "Driver".obs;

  @override
  Future<void> onInit() async {
    await getData();
    super.onInit();
  }

  Future<void> getData() async {
    isLoading(true);
    documentsList.clear();
    List<DocumentsModel> data = await FireStoreUtils.getDocument();
    documentsList.addAll(data);
    isLoading(false);
  }

  void setDefaultData() {
    documentNameController.value.text = "";
    editingId.value = "";
    documentSide = SideAt.isOneSide.obs;
    selectedDocumentType.value = "Driver";
    isActive.value = true;
    isEditing.value = false;
  }

  Future<void> updateDocument() async {
    isEditing = true.obs;
    await FireStoreUtils.addDocument(DocumentsModel(
        id: editingId.value,
        active: isActive.value,
        isTwoSide: documentSide.value == SideAt.isTwoSide ? true : false,
        title: documentNameController.value.text,
        type: selectedDocumentType.value));
    await getData();
    isEditing = false.obs;
  }

  Future<void> addDocument() async {
    isLoading = true.obs;
    await FireStoreUtils.addDocument(DocumentsModel(
        id: Constant.getRandomString(20),
        active: isActive.value,
        isTwoSide: documentSide.value == SideAt.isTwoSide ? true : false,
        title: documentNameController.value.text,
        type: selectedDocumentType.value));
    await getData();
    isLoading = false.obs;
  }

  Future<void> removeDocument(DocumentsModel documentsModel) async {
    isLoading = true.obs;

    await FirebaseFirestore.instance.collection(CollectionName.documents).doc(documentsModel.id).delete().then((value) {
      ShowToastDialog.successToast("Document deleted...!".tr);
    }).catchError((error) {
      ShowToastDialog.errorToast("An error occurred. Please try again.".tr);
    });
    await getData();
    isLoading = false.obs;
  }
}
