import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:plan_cfe/page/inicio/inicio.dart';
import 'package:plan_cfe/page/perfil/perfil.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: 0,
          height: 70.0,
          items: const <Widget>[
            Icon(Icons.home, size: 30, color: Colors.white,),
            
            Icon(Icons.person, size: 30, color: Colors.white,),
          ],
          color: const Color.fromARGB(255, 10, 93, 21),
          buttonBackgroundColor: const Color.fromARGB(255, 10, 88, 7),
          backgroundColor: Colors.transparent,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 500),
          onTap: (index) {
            setState(() {
              _page = index;
            });
          },
          letIndexChange: (index) => true,
        ),
        body: Container(
          color: Colors.transparent,
          child: Center(
            child: getPage(_page),
          ),
        ));
  }

  Widget getPage(int page) {
    switch (page) {
      case 0:
        return const Inicio();
      case 1:
        return const UserScreen();
      // case 2:
      //   return UserScreen();
      default:
        return Container();
    }
  }
}
