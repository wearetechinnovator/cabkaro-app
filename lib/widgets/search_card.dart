import 'package:flutter/material.dart';
import 'package:dashed_border/dashed_border.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:cabkaro/screens/user/AvailableCabsScreen.dart';
class Searchcard extends StatelessWidget {
  const Searchcard({
    super.key,
    required this.onSubmit,
  });
  final GestureTapCallback onSubmit;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,

          decoration: BoxDecoration(
            color: Color.fromARGB(255, 248, 182, 0),
            borderRadius: BorderRadius.all(Radius.circular(25)),
            border: Border(
              bottom: BorderSide(color: Color(0xFF4D4D4D), width: 4),
              right: BorderSide(color: Color(0xFF4D4D4D), width: 4),
              top: BorderSide(color: Color(0xFF4D4D4D), width: 2),
              left: BorderSide(color: Color(0xFF4D4D4D), width: 2),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 35),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),

                  height: 45,
                  decoration: BoxDecoration(
                    border: DashedBorder(
                      color: const Color(0xFF5E5951),
                      width: 1.1,
                      dashLength: 4.0,
                      dashGap: 4.0,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      hintStyle: GoogleFonts.oswald(),
                      hintText: "Pickup Location",
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      // contentPadding: EdgeInsets.zero,
                      isDense: true,
                      prefixIcon: Icon(Icons.my_location_outlined),
                      prefixIconConstraints: BoxConstraints(
                        minWidth: 5,
                        minHeight: 0,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),

                  height: 40,
                  decoration: BoxDecoration(
                    border: DashedBorder(
                      color: const Color(0xFF5E5951),
                      width: 1.1,
                      dashLength: 4.0,
                      dashGap: 4.0,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      hintStyle: GoogleFonts.oswald(),
                      hintText: "Drop Location",
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      // contentPadding: EdgeInsets.zero,
                      isDense: true,
                      prefixIcon: Icon(Icons.my_location_outlined),
                      prefixIconConstraints: BoxConstraints(
                        minWidth: 5,
                        minHeight: 0,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 2,
                        ),

                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(
                          border: DashedBorder(
                            color: const Color(0xFF5E5951),
                            width: 1.1,
                            dashLength: 4.0,
                            dashGap: 4.0,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextField(
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            hintStyle: GoogleFonts.oswald(),
                            hintText: "Price",
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            // contentPadding: EdgeInsets.zero,
                            isDense: true,
                            prefixIcon: Icon(Icons.currency_rupee_outlined),
                            prefixIconConstraints: BoxConstraints(
                              minWidth: 5,
                              minHeight: 0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 2,
                        ),

                        height: 40,
                        // width: 100,
                        decoration: BoxDecoration(
                          border: DashedBorder(
                            color: const Color(0xFF5E5951),
                            width: 1.1,
                            dashLength: 4.0,
                            dashGap: 4.0,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextField(
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            hintStyle: GoogleFonts.oswald(),
                            hintText: "Date",
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            // contentPadding: EdgeInsets.zero,
                            isDense: true,
                            prefixIcon: Icon(Icons.date_range_outlined),
                            prefixIconConstraints: BoxConstraints(
                              minWidth: 5,
                              minHeight: 0,
                            ),

                            // contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 2,
                        ),
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(
                          border: DashedBorder(
                            color: const Color(0xFF5E5951),
                            width: 1.1,
                            dashLength: 4.0,
                            dashGap: 4.0,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextField(
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            hintText: "Time",
                            hintStyle: GoogleFonts.oswald(),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            // contentPadding: EdgeInsets.zero,
                            isDense: true,
                            prefixIcon: Icon(Icons.access_time),
                            prefixIconConstraints: BoxConstraints(
                              minWidth: 5,
                              minHeight: 0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(10),
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: GestureDetector(
                    onTap: onSubmit,
                    child: Center(
                      child: Text(
                        "Submit",
                        style: GoogleFonts.oswald(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),

        // three lines
        Positioned(
          left: -3,
          child: Image.asset('assets/images/Rectangle8.png', width: 74),
        ),
        Positioned(
          left: -10.9,
          child: Image.asset('assets/images/Rectangle9.png', width: 74),
        ),
        Positioned(
          left: -3,
          child: Image.asset('assets/images/Rectangle10.png', width: 74),
        ),
        Positioned(
          right: 45,
          top: 72,
          child: Image.asset('assets/icons/upndownicon.png', width: 30),
        ),
      ],
    );
  }
}
