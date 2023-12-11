import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: SvgPicture.asset(
                    'assets/404.svg',
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text('No Data Available',
                  style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600
                      )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}