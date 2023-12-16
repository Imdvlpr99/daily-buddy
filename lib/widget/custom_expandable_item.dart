import 'dart:math';

import 'package:daily_buddy/widget/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import '../model/activity_model.dart';

class CustomExpandableItem extends StatefulWidget {
  final ActivityModel item;

  const CustomExpandableItem({Key? key, required this.item}) : super(key: key);

  @override
  State<CustomExpandableItem> createState() => _CustomExpandableItemState();
}

class _CustomExpandableItemState extends State<CustomExpandableItem> {
  bool isExpanded = false;
  late Color cardColor;

  @override
  void initState() {
    super.initState();
    cardColor = getRandomColor();
  }

  Color getRandomColor() {
    final List<Color> colorList = [
      Colors.blue.shade50,
      Colors.pink.shade50,
      Colors.purple.shade50,
      Colors.green.shade50,
    ];
    final Random random = Random();
    return colorList[random.nextInt(colorList.length)];
  }

  Color removeShade(Color shadedColor) {
    return shadedColor.withOpacity(1.0); // Masking with 0xFFFFFF removes the alpha channel (shading)
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: const BorderRadius.all(
                    Radius.circular(15.0)
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.blue,
                          child: Icon(
                            Iconsax.stickynote,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.item.title,
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            widget.item.isComplete != 'true' ?
                            Text(
                              "${Utils.formatDateString(widget.item.date, 'EEE, dd MMMM yyyy')} - ${Utils.formatTimeString(widget.item.time, 'HH:mm:ss', 'HH:mm')}",
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                )
                              ),
                            ) : Text(
                              'Complete',
                              style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  )
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Icon(
                          isExpanded ? Iconsax.arrow_circle_up4 : Iconsax.arrow_circle_down5,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                  if (isExpanded)
                    Container(
                      margin: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
                      child: Text('Description: ${widget.item.desc}'),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}