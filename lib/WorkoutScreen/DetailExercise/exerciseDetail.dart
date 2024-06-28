import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wowfit/Utils/color_resources.dart';
import 'package:wowfit/Utils/styles.dart';
import 'package:wowfit/WorkoutScreen/DetailExercise/Screens/noteScreen.dart';

import 'Screens/diaryTrainingTableScreen.dart';

class ExerciseDetail extends StatefulWidget {
  String id;
  String categoryId;
  ExerciseDetail({Key? key, required this.id, required this.categoryId})
      : super(key: key);

  @override
  State<ExerciseDetail> createState() => _ExerciseDetailState();
}

class _ExerciseDetailState extends State<ExerciseDetail>
    with TickerProviderStateMixin {
  TabController? _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        /*Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const WorkOutScreen()),
            (route) => false);*/
        Get.back();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            widget.id.toString().tr,
            style: sFProDisplayRegular.copyWith(
                fontSize: 18, color: ColorResources.COLOR_NORMAL_BLACK),
          ),
          leading: InkWell(
            onTap: () {
              /*Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WorkOutScreen()),
                  (route) => false);*/
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back_ios,
              size: 18,
              color: ColorResources.COLOR_NORMAL_BLACK,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: DefaultTabController(
              length: 2,
              initialIndex: 0,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Material(
                      child: TabBar(
                        controller: _controller,
                        padding: const EdgeInsets.symmetric(horizontal: 45),
                        indicatorSize: TabBarIndicatorSize.label,
                        tabs: [
                          Tab(
                            text: "  Diary training  ".tr,
                          ),
                          Tab(
                            text: "  Notes  ".tr,
                          ),
                        ],
                        labelColor: Colors.white,
                        unselectedLabelColor: ColorResources.COLOR_NORMAL_BLACK,
                        labelStyle: sFProDisplayRegular.copyWith(
                            fontSize: 16,
                            color: ColorResources.COLOR_NORMAL_BLACK),
                        unselectedLabelStyle: sFProDisplayRegular.copyWith(
                            fontSize: 16,
                            color: ColorResources.COLOR_NORMAL_BLACK),
                        indicator: const BubbleTabIndicator(
                            tabBarIndicatorSize: TabBarIndicatorSize.label,
                            indicatorHeight: 30.0,
                            indicatorColor: ColorResources.COLOR_BLUE,
                            padding: EdgeInsets.symmetric(horizontal: 5)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: _controller,
          children: <Widget>[
            DiaryTrainingTableScreen(
              id: widget.id,
              categoryId: widget.categoryId,
            ),
            NoteScreen(id: widget.id),
          ],
        ),
      ),
    );
  }
}
