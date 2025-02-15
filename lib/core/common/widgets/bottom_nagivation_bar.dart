import "dart:developer";

import "package:affinity/features/auth/presentation/pages/login_page.dart";
import "package:affinity/features/auth/presentation/pages/signup_page.dart";
import "package:flutter/material.dart";
import 'package:iconsax/iconsax.dart';

class BottomNavBar extends StatefulWidget {
  final int initialindex;
  const BottomNavBar({super.key, this.initialindex = 0});

  @override
  State<BottomNavBar> createState() => _BottomNagivationBarState();
}

class _BottomNagivationBarState extends State<BottomNavBar> {
  late int _currentIndex = widget.initialindex;

  List<Widget> _buildPages() {
    return [
      const LoginPage(),
      const SignUpPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          child: _buildPages()[_currentIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Container(
                    height: 40,
                    width: 60,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    child: Icon(Iconsax.home)),
                activeIcon: Container(
                    height: 40,
                    width: 60,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    child: Icon(Iconsax.home)),
                label: "Home"),
            BottomNavigationBarItem(
                icon: Container(
                    height: 40,
                    width: 60,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    child: Icon(Iconsax.profile)),
                activeIcon: Container(
                    height: 40,
                    width: 60,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    child: Icon(Iconsax.profile)),
                label: "Profile"),
          ],
          type: BottomNavigationBarType.fixed,
          unselectedFontSize: 14,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });

            if (index == 0) {
              log("Home page selected");
            } else if (index == 1) {
              log("Profile Page selected");
            }
          },
        ));
  }
}
