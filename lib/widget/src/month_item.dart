import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Creates a Widget to represent the months.
class MonthItem extends StatelessWidget {
  const MonthItem({
    Key? key,
    required this.name,
    required this.onTap,
    this.isSelected = false,
    this.color,
    this.activeColor,
    this.shrink = false,
  }) : super(key: key);
  final String name;
  final Function onTap;
  final bool isSelected;
  final Color? color;
  final Color? activeColor;
  final bool shrink;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Text(
        name.isEmpty
            ? ''
            : '${name[0].toUpperCase()}${name.substring(1).toLowerCase()}',
        style: GoogleFonts.poppins(
          fontSize: shrink ? 10 : 22,
          color: isSelected
              ? Colors.white
              : color ?? Colors.black87,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}
