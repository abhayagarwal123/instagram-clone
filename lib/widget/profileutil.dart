import 'package:flutter/material.dart';
import 'package:igclone/util/color.dart';

class Stat extends StatelessWidget {
  final int num;
  final String label;

  const Stat({super.key, required this.label, required this.num});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
        ),
      ],
    );
  }
}

class Followbutton extends StatelessWidget {
  final String label;
  VoidCallback? Function;
  final Color backgroundcolor;
  final Color bordercolor;
  final Color textcolor;
  Followbutton(
      {super.key,
      required this.label,
      this.Function,
      required this.backgroundcolor,
      required this.bordercolor,
      required this.textcolor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: TextButton(

        onPressed: Function,
        child: Container(
          alignment: Alignment.center,
          width: 250,
          height: 30,
          decoration: BoxDecoration(
              color: backgroundcolor,
              border: Border.all(
                color: bordercolor,
              ),
              borderRadius: BorderRadius.circular(3)),
          child: Text(
            label,
            style: TextStyle(color: textcolor, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
