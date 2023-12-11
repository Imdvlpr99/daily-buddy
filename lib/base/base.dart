import 'package:daily_buddy/screen/category.dart';
import 'package:daily_buddy/screen/credit.dart';
import 'package:daily_buddy/screen/home.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:iconsax/iconsax.dart';

/**
 * Created by Imdvlpr_
 */

class Base extends StatefulWidget {
  const Base({super.key});
  @override
  State<Base> createState() => _BaseState();
}

class _BaseState extends State<Base> {
  int _selectedIndex = 0;
  static final List<Widget> _navScreen = <Widget> [
    const Home(),
    const Category(),
    const Credit()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _navScreen.elementAt(_selectedIndex),
      ),
        bottomNavigationBar: Container(
          height: 80,
          decoration: const BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15.0)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0),
              child: GNav(
                backgroundColor: Colors.blue,
                color: Colors.white,
                activeColor: Colors.white,
                tabBackgroundColor: Colors.blue.shade800,
                gap: 8,
                padding: const EdgeInsets.all(16),
                tabs: const [
                  GButton(
                    icon: Iconsax.home_15,
                    text: "Home",
                  ),
                  GButton(
                    icon: Iconsax.task_square5,
                    text: "Category",
                  ),
                  GButton(
                    icon: Iconsax.star5,
                    text: "Credit",)
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                mainAxisAlignment: MainAxisAlignment.spaceAround,
              ),
            ),
          ),
        )
    );
  }

}