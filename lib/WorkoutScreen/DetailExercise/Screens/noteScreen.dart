import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wowfit/DialougBox/errorDefaultDialoug.dart';
import 'package:wowfit/Models/userHistoryModel.dart';
import 'package:wowfit/Widgets/buttonWidget.dart';

import '../../../Utils/color_resources.dart';
import '../../../Utils/showtoaist.dart';
import '../../../Utils/styles.dart';

class NoteScreen extends StatefulWidget {
  String id;

  NoteScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  UserNotes userNote = UserNotes();
  var allowSave = false.obs;
  var isLoading = false.obs;
  var isSaving = false.obs;
  var editingLink = false.obs;
  FocusNode linkFocusNode = FocusNode();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: Obx(() => ButtonWidget(
            text: "Save".tr,
            color: allowSave.value ? Colors.white : null,
            containerColor: allowSave.value ? ColorResources.COLOR_BLUE : null,
            height: 45,
            isLoading: isSaving.value,
            onTap: () async {
              if (allowSave.isTrue) {
                if(_linkController.text.trim().isNotEmpty && !(_linkController.text.toLowerCase().contains("youtube.com") || _linkController.text.toLowerCase().contains("youtu.be"))){
                  Get.dialog(DefaultDialog(
                    title: "Please enter a youtube link".tr,
                    message: "Only youtube links are allowed to be stored".tr,
                    context: Get.context,
                  ));
                  return;
                }
                isSaving(true);
                final date = DateTime.now();
                String formattedDate = DateFormat('dd-MM-yyyy').format(date);
                _noteController.text = _noteController.text.trim();
                _linkController.text = _linkController.text.trim();
                userNote.text = _noteController.text;
                userNote.link = _linkController.text;
                userNote.id = widget.id;
                userNote.date = formattedDate;
                CollectionReference ref = FirebaseFirestore.instance
                    .collection('Users')
                    .doc(GetStorage().read('user').toString())
                    .collection("UserNotes");
                var docs = await ref.doc(widget.id).get();
                if (docs.exists) {
                  await FirebaseFirestore.instance
                      .collection('Users')
                      .doc(GetStorage().read('user').toString())
                      .collection('UserNotes')
                      .doc(widget.id)
                      .update(userNote.toJson())
                      .then((value) => print("User Notes Updated"))
                      .catchError((error) {
                    showToast(error);
                    print("Failed to update user: $error");
                  });
                } else {
                  await FirebaseFirestore.instance
                      .collection('Users')
                      .doc(GetStorage().read('user').toString())
                      .collection('UserNotes')
                      .doc(widget.id)
                      .set(userNote.toJson())
                      .then((value) => print("User Notes Updated"))
                      .catchError((error) {
                    if (kDebugMode) {
                      print("Failed to update user: $error");
                    }
                    showToast(error);
                  });
                }
                FocusScope.of(context).unfocus();
                allowSave.value = false;
                editingLink.value = false;
                isSaving(false);
              }
            })),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Obx(
          () => isLoading.isFalse
              ? Column(
                  children: [
                    SizedBox(
                        height: 160,
                        child: TextField(
                          decoration: inputDecorationTextField(
                              context, 'Your notes'.tr),
                          maxLines: 10,
                          controller: _noteController,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                          onChanged: (text) {
                            if (text.trim() != userNote.text) {
                              allowSave(true);
                            } else {
                              allowSave(false);
                            }
                          },
                        )),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: editingLink.isTrue
                              ? TextField(
                                  focusNode: linkFocusNode,
                                  decoration: inputDecorationTextField(
                                      context, 'YouTube link'.tr),
                                  maxLines: 1,
                                  controller: _linkController,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                  onChanged: (text) {
                                    if (text.trim() != userNote.link) {
                                      allowSave(true);
                                    } else {
                                      allowSave(false);
                                    }
                                  },
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: const Border.fromBorderSide(
                                        BorderSide(
                                            color: ColorResources.INPUT_BORDER,
                                            width: 1)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 12, bottom: 12, right: 8, left: 8),
                                    child: _linkController.text
                                            .trim()
                                            .isNotEmpty
                                        ? Linkify(
                                            onOpen: (link) => launchUrl(
                                                Uri.parse(link.url),
                                                mode: LaunchMode
                                                    .externalApplication),
                                            text: _linkController.text,
                                            style: sFProDisplayRegular.copyWith(
                                                fontSize: 16,
                                                color: ColorResources
                                                    .COLOR_NORMAL_BLACK),
                                          )
                                        : Text(
                                            "YouTube link".tr,
                                            style: const TextStyle(
                                              color: ColorResources
                                                  .INPUT_HINT_COLOR,
                                              fontSize: 16,
                                            ),
                                          ),
                                  ),
                                ),
                        ),
                        InkWell(
                          onTap: () {
                            editingLink(!editingLink.value);
                            if (editingLink.isTrue) {
                              linkFocusNode.requestFocus();
                            } else {
                              linkFocusNode.unfocus();
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset(editingLink.isTrue
                                ? "assets/tick-square.svg"
                                : "assets/edit.svg"),
                          ),
                        )
                      ],
                    )
                  ],
                )
              : const Center(
                  child: CircularProgressIndicator(
                    color: ColorResources.COLOR_BLUE,
                  ),
                ),
        ),
      ),
    );
  }

  InputDecoration inputDecorationTextField(context, hint) {
    return InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        hintText: hint,
        errorStyle: const TextStyle(fontSize: 10),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: ColorResources.INPUT_BORDER, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: ColorResources.INPUT_BORDER, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: ColorResources.INPUT_BORDER, width: 1),
        ),
        //When the TextFormField is ON focus
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: ColorResources.INPUT_BORDER, width: 1),
        ),
        hintStyle: const TextStyle(
          color: ColorResources.INPUT_HINT_COLOR,
          fontSize: 16,
        ));
  }

  @override
  void initState() {
    super.initState();
    isLoading(true);
    FirebaseFirestore.instance
        .collection('Users')
        .doc(GetStorage().read('user').toString())
        .collection('UserNotes')
        .doc(widget.id)
        .get()
        .catchError((e) {
      showToast(e);
    }).then((value) {
      if (value.exists) {
        userNote = UserNotes.fromJson(value.data() as Map<String, dynamic>);
        _noteController.text = userNote.text ?? '';
        _linkController.text = userNote.link ?? '';
      }
      isLoading(false);
    });
  }
}
