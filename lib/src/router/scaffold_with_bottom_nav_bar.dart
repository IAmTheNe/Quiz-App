import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:whizz/src/router/app_router.dart';

class ScaffoldWithBottomNavBar extends StatefulWidget {
  const ScaffoldWithBottomNavBar({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<ScaffoldWithBottomNavBar> createState() =>
      _ScaffoldWithBottomNavBarState();
}

class _ScaffoldWithBottomNavBarState extends State<ScaffoldWithBottomNavBar> {
  int currentIndex = 0;

  void onTap(int index) {
    if (index == currentIndex) {
      return;
    }
    if (index != 3) {
      setState(() {
        currentIndex = index;
      });
    }

    switch (index) {
      case 0:
        context.goNamed(RouterPath.home.name);
        break;
      case 1:
        context.goNamed(RouterPath.discovery.name);
        break;
      case 2:
        context.goNamed(RouterPath.play.name);
        break;
      case 3:
        context.pushNamed(RouterPath.create.name);
        break;
      case 4:
        context.goNamed(RouterPath.profile.name);
        break;
      default:
        context.goNamed(RouterPath.home.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: onTap,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Discovery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.games),
            label: 'Play',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}