import 'package:app/api/authApi/auth_api_handler.dart';
import 'package:app/main.dart';
import 'package:app/pages/common/create_ticket/create_ticket.dart';
import 'package:app/pages/common/main_page/main_page.dart';
import 'package:app/pages/common/profile_page/profile_page.dart';
import 'package:app/pages/common/search_ticket/search_ticket.dart';
import 'package:app/pages/common/tickets/tickets.dart';
import 'package:app/provider/user/user_storage.dart';
import 'package:app/themes/custom_colors.dart';
import 'package:app/urls/imageURL.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class CommonPage extends StatefulWidget {
  const CommonPage({super.key});

  @override
  State<CommonPage> createState() => _CommonPageState();
}

List<Widget> _buildScreens = [
  MainPage(),
  TicketsPage(),
  SearchTicket(),
  ProfilePage(),
];

PersistentTabController controllerCommonPages =
    PersistentTabController(initialIndex: 0);

List<PersistentBottomNavBarItem> _navBarsItems() {
  bool selected = false;

  return [
    PersistentBottomNavBarItem(
        icon: const Image(
          image: NetworkImage(CustomIMG.logoHome),
          color: Colors.white,
        ),
        inactiveIcon: const Image(
          image: NetworkImage(CustomIMG.logoHome),
          color: Colors.black,
        ),
        onSelectedTabPressWhenNoScreensPushed: () {
          selected = true;
        },
        title: "Главная",
        activeColorPrimary: Theme.of(navigatorKey.currentContext!)
            .extension<CustomColors>()!
            .secondaryColor!,
        activeColorSecondary: Colors.white),
    PersistentBottomNavBarItem(
      icon: const Image(
        image: NetworkImage(CustomIMG.logoAdd),
        color: Colors.white,
      ),
      inactiveIcon: const Image(
        image: NetworkImage(CustomIMG.logoAdd),
        color: Colors.black,
      ),
      title: "Бронь",
      activeColorPrimary: Theme.of(navigatorKey.currentContext!)
          .extension<CustomColors>()!
          .secondaryColor!,
      activeColorSecondary: Colors.white,
    ),
    PersistentBottomNavBarItem(
      icon: const Image(
        image: NetworkImage(CustomIMG.historyIcon),
        color: Colors.white,
      ),
      inactiveIcon: const Image(
        image: NetworkImage(CustomIMG.historyIcon),
        color: Colors.black,
      ),
      activeColorPrimary: Theme.of(navigatorKey.currentContext!)
          .extension<CustomColors>()!
          .secondaryColor!,
      title: "Очередь",
      activeColorSecondary: Colors.white,
    ),
    PersistentBottomNavBarItem(
      icon: const Image(
        image: NetworkImage(CustomIMG.logoProfile),
        color: Colors.white,
      ),
      inactiveIcon: const Image(
        image: NetworkImage(CustomIMG.logoProfile),
        color: Colors.black,
      ),
      activeColorPrimary: Theme.of(navigatorKey.currentContext!)
          .extension<CustomColors>()!
          .secondaryColor!,
      title: "Профиль",
      activeColorSecondary: Colors.white,
    ),
  ];
}

class _CommonPageState extends State<CommonPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        context,
        controller: controllerCommonPages,
        screens: _buildScreens,
        items: _navBarsItems(),
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset:
            true, // This needs to be true if you want to move up the screen on a non-scrollable screen when keyboard appears. Default is true.
        stateManagement: false,
        hideNavigationBarWhenKeyboardAppears: true,
        navBarStyle: NavBarStyle.style7,
        padding: const EdgeInsets.only(top: 8),

        isVisible: true,
        animationSettings: const NavBarAnimationSettings(
          navBarItemAnimation: ItemAnimationSettings(
            // Navigation Bar's items animation properties.
            duration: Duration(milliseconds: 400),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: ScreenTransitionAnimationSettings(
            // Screen transition animation on change of selected tab.
            animateTabTransition: true,
            duration: Duration(milliseconds: 200),
            screenTransitionAnimationType: ScreenTransitionAnimationType.slide,
          ),
        ),
        confineToSafeArea: true,
        navBarHeight: kBottomNavigationBarHeight,
      ),
      extendBody: true,
    );
  }
}
