import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

/**
 * Created by Imdvlpr_
 */

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    this.title = '',
    this.showBackButton = false,
    this.showActionIcon = false,
    this.onMenuActionTap,
    this.onBackButtonTap,
  }) : super(key: key);

  final String title;
  final bool showBackButton;
  final bool showActionIcon;
  final VoidCallback? onBackButtonTap;
  final VoidCallback? onMenuActionTap;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: AppBarClipper(),
      child: Container(
        color: Colors.blue, // Set your desired background color
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 25,
              vertical: 25 / 2.5,
            ),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (showBackButton)
                      Transform.translate(
                        offset: const Offset(-14, 0),
                        child: InkWell(
                          onTap: onBackButtonTap,
                          child: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Icon(Iconsax.arrow_left4, color: Colors.white,),
                          )
                        )
                      ),
                    if (showActionIcon)
                      Transform.translate(
                        offset: const Offset(10, 0),
                        child: InkWell(
                          onTap: onMenuActionTap,
                          child: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Icon(Icons.menu),
                          ),
                        ),
                      )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size(
    double.maxFinite,
    70,
  );
}

class AppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - 20);
    path.quadraticBezierTo(size.width, size.height, size.width - 20, size.height);
    path.lineTo(20, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - 20);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}