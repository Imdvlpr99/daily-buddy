import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

/**
 * Created by Imdvlpr_
 */

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType? keyboardType;
  final bool? isObscureText;
  final String? obscureCharacter;
  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? isReadOnly;
  final int? minLines;
  final int? maxLines;
  final VoidCallback? onMenuActionTap;
  final List<String>? dropdownItems;
  final String? selectedDropdownItem;
  final Function(String)? onDropdownChanged;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.keyboardType = TextInputType.text,
    this.isObscureText = false,
    this.obscureCharacter = '*',
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.isReadOnly = false,
    this.minLines,
    this.maxLines,
    this.onMenuActionTap,
    this.dropdownItems,
    this.selectedDropdownItem,
    this.onDropdownChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return TextFormField(
      onTap: onMenuActionTap,
      readOnly: isReadOnly ?? false,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isObscureText!,
      obscuringCharacter: obscureCharacter!,
      minLines: minLines,
      maxLines: maxLines,
      style: GoogleFonts.poppins().copyWith(
        color: Colors.black,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        isDense: true,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        constraints: BoxConstraints(
          maxWidth: width,
        ),
        filled: true,
        fillColor: Colors.white,
        labelText: labelText,
        hintText: hintText,
        hintStyle: GoogleFonts.poppins().copyWith(
          color: Colors.grey,
          fontSize: 14,
        ),
        prefixIcon: prefixIcon,
        suffixIcon: dropdownItems != null
            ? Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: DropdownButton<String>(
            value: selectedDropdownItem,
            icon: const Icon(Iconsax.arrow_down_1),
            iconSize: 24,
            elevation: 16,
            onChanged: (String? newValue) {
              onDropdownChanged?.call(newValue!);
            },
            items: dropdownItems!.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Container(
                  width: 200,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Text(value),
                ),
              );
            }).toList(),
            underline: Container(),
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
          ),
        )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
      ),
    );
  }
}