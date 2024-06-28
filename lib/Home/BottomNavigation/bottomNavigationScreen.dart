import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wowfit/Home/Screens/calenderScreen.dart';
import 'package:wowfit/Home/Screens/profile_screen.dart';
import 'package:wowfit/Home/Screens/settingScreen.dart';
import 'package:wowfit/Utils/color_resources.dart';
import 'package:wowfit/Utils/styles.dart';

class BottomNavigationScreen extends StatefulWidget {
  int? index;
  BottomNavigationScreen({Key? key, this.index}) : super(key: key);

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int currentPage = 1;
  GlobalKey bottomNavigationKey = GlobalKey();
  int currentBottomNavigationIndex = 0;
  String? guestID;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getIndex();
    });
  }

  getIndex() {
    currentBottomNavigationIndex = widget.index!;
  }

  onTapped(index) {
    setState(() {
      currentBottomNavigationIndex = index;
    });
  }

  final tabs = [
    const CalenderScreen(),
    const ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[currentBottomNavigationIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 10,
        onTap: onTapped,
        currentIndex: currentBottomNavigationIndex,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: sFProDisplayMedium.copyWith(
            fontSize: 16, color: ColorResources.COLOR_BLUE),
        unselectedLabelStyle: sFProDisplayMedium.copyWith(
            fontSize: 16, color: ColorResources.INPUT_HINT_COLOR),
        selectedFontSize: 12,
        unselectedFontSize: 12,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: ColorResources.COLOR_BLUE,
        items: [
          BottomNavigationBarItem(
              icon: currentBottomNavigationIndex == 0
                  ? SvgPicture.asset(
                      'assets/calendar.svg',
                      height: 24,
                      width: 24,
                      color: ColorResources.COLOR_BLUE,
                    )
                  : SvgPicture.asset(
                      'assets/calendar.svg',
                      height: 24,
                      width: 24,
                      color: ColorResources.INPUT_HINT_COLOR,
                    ),
              label: ''),
          BottomNavigationBarItem(
              icon: currentBottomNavigationIndex == 1
                  ? const Icon(
                      Icons.person,
                      color: ColorResources.COLOR_BLUE,
                      size: 30,
                    )
                  : const Icon(
                      Icons.person,
                      color: ColorResources.INPUT_HINT_COLOR,
                      size: 30,
                    ),
              label: ''),
        ],
      ),
    );
  }
}
