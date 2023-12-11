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
    this.leading,
    this.titleWidget,
    this.showActionIcon = false,
    this.onMenuActionTap,
  }) : super(key: key);

  final String title;
  final Widget? leading;
  final Widget? titleWidget;
  final bool showActionIcon;
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
              vertical: 50 / 2.5,
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: titleWidget == null
                      ? Center(
                    child: Text(
                      title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white),
                    ),
                  )
                      : Center(
                    child: titleWidget,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    leading ??
                        Transform.translate(
                          offset: const Offset(-14, 0),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              iconTheme: const IconThemeData(color: Colors.white), // Set your desired color
                            ),
                            child: const BackButton(),
                          ),
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
    80,
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