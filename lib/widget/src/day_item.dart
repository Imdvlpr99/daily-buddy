import 'package:flutter/material.dart';

/// Creates a Widget representing the day.
class DayItem extends StatelessWidget {
  const DayItem({
    Key? key,
    required this.dayNumber,
    required this.shortName,
    required this.onTap,
    this.isSelected = false,
    this.dayColor,
    this.activeDayColor,
    this.activeDayBackgroundColor,
    this.available = true,
    this.dotsColor,
    this.dayNameColor,
    this.shrink = false,
  }) : super(key: key);
  final int dayNumber;
  final String shortName;
  final bool isSelected;
  final Function onTap;
  final Color? dayColor;
  final Color? activeDayColor;
  final Color? activeDayBackgroundColor;
  final bool available;
  final Color? dotsColor;
  final Color? dayNameColor;
  final bool shrink;

  GestureDetector _buildDay(BuildContext context) {
    final textStyle = TextStyle(
      color: available
          ? dayColor ?? Theme.of(context).colorScheme.secondary
          : dayColor?.withOpacity(0.5) ??
              Theme.of(context).colorScheme.secondary.withOpacity(0.5),
      fontSize: shrink ? 14 : 28,
      fontWeight: FontWeight.normal,
    );
    final selectedStyle = TextStyle(
      color: activeDayColor ?? Colors.white,
      fontSize: shrink ? 14 : 32,
      fontWeight: FontWeight.bold,
      height: 0.8,
    );

    return GestureDetector(
      onTap: available ? onTap as void Function()? : null,
      child: Column(
        children: [
          Text(
            shortName,
            style: TextStyle(
              color: dayNameColor ?? activeDayColor ?? Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14, // Adjust the font size as needed
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            height: 60,
            width: 60,
            child: Container(
              decoration: isSelected ? BoxDecoration(
                color: activeDayBackgroundColor ?? Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(15),) :
              BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.white,
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  dayNumber.toString(),
                  style: isSelected ? selectedStyle : textStyle.copyWith(
                    fontWeight: FontWeight.normal, // Set to normal when unselected
                  ),
                  textAlign: TextAlign.center, // Center the text horizontally
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildDay(context);
  }
}
