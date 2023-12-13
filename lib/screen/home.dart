import 'package:daily_buddy/screen/add_list.dart';
import 'package:daily_buddy/widget/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../widget/custom_page_route.dart';

/**
 * Created by Imdvlpr_
 */

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Home",
        showBackButton: false,
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: navigateToAddList,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          child: const Icon(Iconsax.add4
          )
      ),
    );
  }

  void navigateToAddList() {
    final route = CustomPageRoute(
        child: const AddList(),
        direction: AxisDirection.left);
    Navigator.push(context, route);
  }
}


