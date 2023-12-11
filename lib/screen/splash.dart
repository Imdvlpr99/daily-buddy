import 'package:daily_buddy/base/base.dart';
import 'package:daily_buddy/widget/custom_page_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/**
 * Created by Imdvlpr_
 */

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();
    setState(() {});
    navigateToHome(context);
  }

  navigateToHome(BuildContext context) {
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        CustomPageRoute(
            child: const Base(),
            direction: AxisDirection.left),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/splash.svg',
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16)
          ],
        ),
      ),
    );
  }
}