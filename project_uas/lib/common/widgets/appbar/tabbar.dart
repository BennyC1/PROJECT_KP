
import 'package:flutter/material.dart';
import 'package:project_uas/utils/constants/colors.dart';
import 'package:project_uas/utils/device/device_utility.dart';
import 'package:project_uas/utils/helpers/helper_function.dart';

class BTabBar extends StatelessWidget implements PreferredSizeWidget {

  const BTabBar({super.key, required this.tabs});

  final List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    final dark = BHelperFunctions.isDarkMode(context);
    return Material(
      color: dark ? BColors.black : BColors.white,
      child: TabBar (
        tabs: tabs,
        isScrollable: true,
        indicatorColor: BColors.primary,
        labelColor: dark ? BColors. white : BColors.primary,
        unselectedLabelColor : BColors. darkGrey,
      ),
    ); 
  }
  @override
  Size get preferredSize => Size.fromHeight(BDeviceUtils.getAppBarHeight());
}