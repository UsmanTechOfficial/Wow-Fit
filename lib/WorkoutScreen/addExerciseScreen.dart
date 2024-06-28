import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:wowfit/Models/ExceriseCategories.dart';
import 'package:wowfit/Models/userHistoryModel.dart';
import 'package:wowfit/Utils/color_resources.dart';
import 'package:wowfit/Utils/image_utils.dart';
import 'package:wowfit/Widgets/buttonWidget.dart';
import 'package:wowfit/Widgets/floatingActionButton.dart';
import 'package:wowfit/Widgets/searchInputField.dart';
import 'package:wowfit/WorkoutScreen/addNewExerciseScreen.dart';
import 'package:wowfit/WorkoutScreen/newWorkOutScreen.dart';
import 'package:wowfit/controller/addExcerciseController.dart';
import 'package:wowfit/controller/newWorkoutController.dart';

import '../Models/WorkOutModel.dart';
import '../Models/userAddedExcercise.dart';
import '../Utils/showtoaist.dart';
import '../Utils/styles.dart';
import '../Widgets/CustomCheckBox.dart';
import '../Widgets/dairyWidget2.dart';

class AddExerciseScreen extends StatefulWidget {
  bool fromUpdate;
  int? mainIndex;
  List<UserList>? updateList;
  Function()? callback;
  WorkOutData? workOutData;

  AddExerciseScreen(
      {Key? key,
      required this.fromUpdate,
      this.updateList,
      this.workOutData,
      this.callback,
      this.mainIndex})
      : super(key: key);

  @override
  State<AddExerciseScreen> createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> {
  AddExerciseController con = Get.put(AddExerciseController());
  List<SubCategories> temp = [];
  var showSpinner = false.obs;
  var blue = false.obs;
  String index = '11';
  int? _groupValue;
  var allDocuments;
  List<DocumentSnapshot> docsId = [];

  @override
  void initState() {
    super.initState();
  }

  final TextEditingController _searchController = TextEditingController();
  NewWorkOutController con1 = NewWorkOutController();

  String getRandomGeneratedId() {
    const int AUTO_ID_LENGTH = 10;
    const String AUTO_ID_ALPHABET =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

    const int maxRandom = AUTO_ID_ALPHABET.length;
    final Random randomGen = Random();

    String id = '';
    for (int i = 0; i < AUTO_ID_LENGTH; i++) {
      id = id + AUTO_ID_ALPHABET[randomGen.nextInt(maxRandom)];
    }
    return id;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return true;
      },
      child: Scaffold(
        bottomNavigationBar: Obx(
          () => Padding(
            padding: const EdgeInsets.only(bottom: 25, left: 25, right: 20),
            child: ButtonWidget(
              text: "Save".tr,
              color: blue.value ? Colors.white : null,
              containerColor: blue.value ? ColorResources.COLOR_BLUE : null,
              height: 50,
              onTap: widget.fromUpdate
                  ? () async {
                      if (kDebugMode) {
                        print('fromUpdate');
                      }
                      showSpinner.value = true;

                      if (temp.isNotEmpty) {
                        for (var item in temp) {
                          widget.updateList!.add(
                            UserList(
                              item.img,
                              item.subCategoryName,
                              false,
                              false,
                              false,
                              false,
                              false,
                              0,
                              id: getRandomGeneratedId(),
                              rap1Controller: null,
                              rap2Controller: null,
                              selectedIndex: null,
                              weight1Controller: null,
                              weight2Controller: null,
                              items: <Widget>[],
                              subcategoriesId: item.id,
                              dairy: <UserHistoryModel>[],
                            ),
                          );
                        }
                        for (int i = 0; i < widget.updateList!.length; i++) {
                          widget.updateList![i].index = i;
                        }
                        widget.workOutData!.workOut![widget.mainIndex!]
                            .addedExercise!
                            .clear();
                        for (var item in widget.updateList!) {
                          widget.workOutData!.workOut![widget.mainIndex!]
                              .addedExercise!
                              .add(item);
                        }

                        con.updateWorkList(
                            widget.workOutData!.workDate.toString(),
                            widget.workOutData!,
                            widget.mainIndex!);
                        if (temp.isNotEmpty) {
                          con.refreshSubCategories();
                        }

                        /* for (DocumentSnapshot doc in docsId) {
                          await con.updateUserSubCategory(doc.id, false);
                        }*/
                        blue.value = false;
                        showSpinner.value = false;

                        widget.callback!();
                        showToast('Exercise created successfully'.tr);
                        Get.back();
                      } else {
                        blue.value = false;
                        showSpinner.value = false;

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Please select exercises'.tr)));
                      }
                    }
                  : () async {
                      showSpinner.value = true;

                      final TextEditingController _weightController =
                          TextEditingController();
                      final TextEditingController _weight1Controller =
                          TextEditingController();
                      final TextEditingController _rapController =
                          TextEditingController();
                      final TextEditingController _rap1Controller =
                          TextEditingController();
                      int a = 0;
                      if (temp.isNotEmpty) {
                        for (var item in temp) {
                          var u = UserList(
                            item.img,
                            item.subCategoryName,
                            false,
                            false,
                            false,
                            false,
                            false,
                            0,
                            id: getRandomGeneratedId(),
                            rap1Controller: TextEditingController(),
                            rap2Controller: TextEditingController(),
                            selectedIndex: null,
                            weight1Controller: TextEditingController(),
                            weight2Controller: TextEditingController(),
                            items: <Widget>[],
                            subcategoriesId: item.id,
                            dairy: [],
                          );
                          userList.add(u);
                          a++;
                        }

                        for (var i = 0; i < userList.length; i++) {
                          userList[i].index = i;
                          if (userList[i].items != null &&
                              userList[i].items.isNotEmpty) {
                            for (var item in userList[i].items) {
                              if (item is DairyWidgetTwo) {
                                item.parrentindex = i;
                              }
                            }
                          }
                        }

                        if (temp.isNotEmpty) {
                          con.refreshSubCategories();
                        }

                        /*for (DocumentSnapshot doc in docsId) {
                          await con.updateUserSubCategory(doc.id, false);
                        }*/

                        showSpinner.value = false;

                        showToast('Exercise created successfully'.tr);
                        Get.back();
                      } else {
                        blue.value = false;
                        showSpinner.value = false;

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Please select exercises'.tr)));
                      }
                    },
            ),
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: FloatingActionButton(
            backgroundColor: Colors.transparent,
            elevation: 0,
            onPressed: () {
              /* Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddNewExerciseScreen()));*/
              Get.to(() => const AddNewExerciseScreen());
            },
            child: const FloatingActionButtonWidget(),
          ),
        ),
        backgroundColor: Colors.white,
        body: Obx(
          () => ModalProgressHUD(
            inAsyncCall: showSpinner.value,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    top: 40,
                    bottom: 10,
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          if (temp.isNotEmpty) {
                            con.refreshSubCategories();
                          }
                          Get.back();
                        },
                        child: const Icon(
                          Icons.arrow_back_ios,
                          size: 18,
                          color: ColorResources.COLOR_NORMAL_BLACK,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 15),
                          child: SearchInputFields(
                            "Search ".tr,
                            "your search".tr,
                            isEmail: true,
                            controller: null,
                            callback: (value) {
                              if (value.isNotEmpty) {
                                setState(() {
                                  _searchController.text = value;
                                });
                              } else {
                                setState(() {
                                  _searchController.text = "";
                                  index = '11';
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          index = "11";
                        });
                      },
                      child: SizedBox(
                        width: 70,
                        height: 70,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                          ),
                          child: SvgPicture.asset(
                            getGenderPathString('assets/all_exs.svg'),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.horizontal,
                            itemCount: con.cateList.length,
                            itemBuilder: (context, i) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    index = con.cateList[i].id.toString();
                                  });
                                },
                                child: SizedBox(
                                  width: 70,
                                  height: 70,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: SvgPicture.asset(
                                      getGenderPathString(con.cateList[i].img!),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    child: StreamBuilder<DocumentSnapshot>(
                      stream: con.readUserCategories(_searchController.text),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something went wrong'.tr);
                        }
                        //removed waiting state because it blinking the screen
                        /*if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text("Loading".tr);
                        }*/

                        /*snapshot.data!.docs.map((DocumentSnapshot document) {
                        subCate.add(SubCategories.fromJson(
                            document.data() as Map<String, dynamic>));
                      });*/
                        /*subCate.add(SubCategories.fromJson(snapshot.data!.docs.map(  (DocumentSnapshot document) {
                        return document;
                      }))); */
                        // allDocuments = snapshot.data.docs;
                        if (snapshot.hasData) {
                          // print(snapshot.data.docs.map((data)=> ));
                          BuiltinCategories subCates =
                              BuiltinCategories.fromJson(
                                  snapshot.data.data() as Map<String, dynamic>);

                          var orignal = BuiltinCategories.fromJson(
                              snapshot.data.data() as Map<String, dynamic>);
                          List<SubCategories> list = [];
                          List<SubCategories> listfilter = [];
                          if (_searchController.text.toString().isNotEmpty) {
                            listfilter.addAll(orignal.subCategories!.where(
                                (poll) => poll.subCategoryName!.tr
                                    .toLowerCase()
                                    .contains(_searchController.text
                                        .toString()
                                        .toLowerCase())));
                          }
                          List<SubCategories> activePollsList = [];
                          List<SubCategories> inactivePollsList = [];

                          activePollsList.addAll(_searchController.text
                                  .toString()
                                  .isNotEmpty
                              ? listfilter.where((poll) => poll.rBtn == true)
                              : orignal.subCategories!
                                  .where((poll) => poll.rBtn == true));
                          activePollsList.sort((a, b) => a.subCategoryName!.tr
                              .toLowerCase()
                              .toString()
                              .compareTo(b.subCategoryName!.tr
                                  .toLowerCase()
                                  .toString()));

                          inactivePollsList.addAll(_searchController.text
                                  .toString()
                                  .isNotEmpty
                              ? listfilter.where((poll) => poll.rBtn == false)
                              : orignal.subCategories!
                                  .where((poll) => poll.rBtn == false));
                          inactivePollsList.sort((a, b) => a.subCategoryName!.tr
                              .toLowerCase()
                              .toString()
                              .compareTo(b.subCategoryName!.tr
                                  .toLowerCase()
                                  .toString()));

                          list = activePollsList + inactivePollsList;
                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.vertical,
                            itemCount: list.length,
                            itemBuilder: (context, itemIndex) {

                              if (index == list[itemIndex].id) {
                                return Slidable(
                                  key: UniqueKey(),
                                  endActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context) {
                                          con.deleteUserCategories(list[itemIndex].subCategoryName!);
                                        },
                                        backgroundColor:
                                            const Color(0xFFFE4A49),
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete,
                                        label: 'Delete'.tr,
                                      ),
                                    ],
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      if (list[itemIndex].rBtn == false) {
                                        blue.value = true;
                                        var index = subCates.subCategories!
                                            .indexWhere((st) =>
                                        st.subCategoryName ==
                                            list[itemIndex].subCategoryName);
                                        list[itemIndex].rBtn = true;

                                        con
                                            .updateUserSubCategory(
                                            index, true)
                                            .whenComplete(() {
                                          temp.add(list[itemIndex]);
                                        });
                                      } else {
                                        var index = subCates.subCategories!
                                            .indexWhere((st) =>
                                        st.subCategoryName ==
                                            list[itemIndex].subCategoryName);
                                        list[itemIndex].rBtn = false;

                                        con
                                            .updateUserSubCategory(
                                            index, false)
                                            .whenComplete(() {
                                          temp.removeWhere((element) =>
                                          element.subCategoryName ==
                                              list[itemIndex].subCategoryName);
                                        });
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 45,
                                          height: 45,
                                          child: SvgPicture.asset(
                                            getGenderPathString(list[itemIndex].img.toString()),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Text(
                                            list[itemIndex]
                                                .subCategoryName
                                                .toString()
                                                .tr,
                                            textAlign: TextAlign.start,
                                            maxLines: 3,
                                            style: sFProDisplayRegular.copyWith(
                                                fontSize: 16,
                                                overflow: TextOverflow.visible,
                                                color: ColorResources
                                                    .COLOR_NORMAL_BLACK),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8),
                                          child: SizedBox(
                                            width: 40,
                                            height: 50,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: SizedBox(
                                                width: 40,
                                                height: 50,
                                                child: AbsorbPointer(
                                                  child: CustomCheckBox(
                                                    index: itemIndex,
                                                    isSelected:
                                                        list[itemIndex].rBtn == false
                                                            ? false
                                                            : true
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }

                              return index == "11"
                                  ? Slidable(
                                      key: UniqueKey(),
                                      endActionPane: ActionPane(
                                        motion: const ScrollMotion(),
                                        children: [
                                          SlidableAction(
                                            onPressed: (context) {
                                              con.deleteUserCategories(list[itemIndex].subCategoryName!);
                                            },
                                            backgroundColor:
                                                const Color(0xFFFE4A49),
                                            foregroundColor: Colors.white,
                                            icon: Icons.delete,
                                            label: 'Delete'.tr,
                                          ),
                                        ],
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          if (list[itemIndex].rBtn == false) {
                                            blue.value = true;
                                            var index = subCates.subCategories!
                                                .indexWhere((st) =>
                                                    st.subCategoryName ==
                                                    list[itemIndex].subCategoryName);
                                            list[itemIndex].rBtn = true;

                                            con
                                                .updateUserSubCategory(
                                                    index, true)
                                                .whenComplete(() {
                                              temp.add(list[itemIndex]);
                                            });
                                          } else {
                                            var index = subCates.subCategories!
                                                .indexWhere((st) =>
                                                    st.subCategoryName ==
                                                    list[itemIndex].subCategoryName);
                                            list[itemIndex].rBtn = false;

                                            con
                                                .updateUserSubCategory(
                                                    index, false)
                                                .whenComplete(() {
                                              temp.removeWhere((element) =>
                                                  element.subCategoryName ==
                                                  list[itemIndex].subCategoryName);
                                            });
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 45,
                                              height: 45,
                                              child: SvgPicture.asset(
                                                getGenderPathString(list[itemIndex].img.toString()),
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Text(
                                                list[itemIndex]
                                                    .subCategoryName
                                                    .toString()
                                                    .tr,
                                                textAlign: TextAlign.start,
                                                maxLines: 3,
                                                style: sFProDisplayRegular
                                                    .copyWith(
                                                        fontSize: 16,
                                                        color: ColorResources
                                                            .COLOR_NORMAL_BLACK),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: SizedBox(
                                                width: 40,
                                                height: 50,
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: SizedBox(
                                                    width: 40,
                                                    height: 50,
                                                    child: AbsorbPointer(
                                                      child: CustomCheckBox(
                                                        index: itemIndex,
                                                        isSelected:
                                                            list[itemIndex].rBtn ==
                                                                    false
                                                                ? false
                                                                : true,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container();
                            },
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void doNothing(BuildContext context, int index) {
  subCate.removeAt(index);
}
