import 'package:chatbot_and_image_generator/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Feature_box extends StatelessWidget {
  final Color color;
  final String header_text;
  final String desc_text;
  const Feature_box(
      {Key? key,
      required this.color,
      required this.header_text,
      required this.desc_text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.all(Radius.circular(15.0))),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0).copyWith(left: 15),
        child: Column(children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              header_text,
              style: TextStyle(
                  fontFamily: "Cera-pro",
                  color: My_Colors.blackColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Text(
              desc_text,
              style: TextStyle(
                  fontFamily: "Cera-pro",
                  color: My_Colors.blackColor,
                  fontWeight: FontWeight.w300),
            ),
          ),
        ]),
      ),
    );
  }
}
