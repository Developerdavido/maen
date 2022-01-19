import 'package:flutter/material.dart';
import 'package:maen/screens/Cart.dart';
import 'package:maen/screens/category_page.dart';
import 'package:maen/screens/favorite_screen.dart';
import 'package:maen/screens/store_home.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key key}) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}
final PersistentTabController _controller =  PersistentTabController(initialIndex: 0);

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: false,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: Colors.white
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties(
          duration: Duration(milliseconds: 200),
          curve: Curves.ease
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style12,
    );
  }

  List<PersistentBottomNavBarItem>_navBarItems() {
    return [
      PersistentBottomNavBarItem(
          icon: Icon(Icons.home),
          title: ("Home"),
          activeColorPrimary: Colors.blue,
          inactiveColorPrimary: Colors.grey
      ),
      PersistentBottomNavBarItem(
          icon: Icon(Icons.category_rounded),
          title: ("Catalogue"),
          activeColorPrimary: Colors.blue,
          inactiveColorPrimary: Colors.grey
      ),
      PersistentBottomNavBarItem(
          icon: Icon(Icons.favorite),
          title: ("Favourites"),
          activeColorPrimary: Colors.blue,
          inactiveColorPrimary: Colors.grey
      ),
      PersistentBottomNavBarItem(
          icon: Icon(Icons.shopping_bag),
          title: ("Cart"),
          activeColorPrimary: Colors.blue,
          inactiveColorPrimary: Colors.grey
      )

    ];
  }


  List<Widget> _buildScreens() {
    return [
      StoreHome(),
      CategoryPage(),
      FavoriteScreen(),
      CartScreen()
    ];
  }
}

