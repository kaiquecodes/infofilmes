import 'package:flutter/material.dart';

const primary = Color(0xFF141221);
const secondary = Color(0xff4d4da5);
const tertiary = Color(0xfff1f1f6);

const buttonColor = Color(0xff2b3fbb);

const bottomNav =  Color(0xff282831);
const bottomNavUnselect = Color(0xffededf3);

const primaryText = Color(0xffffffff);
const secondaryText = Color(0xffa8a8b3);
const tertiaryText = Color(0xff282831);
const titles = Color(0xff5e5ea3);

const white = Colors.white;
const black = Colors.black;
const grey = Color.fromRGBO(0, 0, 0, .6);

Widget AppText(
    {FontWeight isBold = FontWeight.normal,
    Color color = primaryText,
    required double size,
    required String text,
    int maxLines = 0,
    bool overflow = false,
    bool lineThrough = false,
    bool alignCenter = false}) {
  return Text(
    text,
    textAlign: alignCenter == true ? TextAlign.center : null,
    maxLines: maxLines == 0 ? null : maxLines,
    overflow: overflow == true ? TextOverflow.ellipsis : null,
    style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: isBold,
        decoration: lineThrough ? TextDecoration.lineThrough : null),
  );
}

showSnackBar(BuildContext context, String text, {Color color = secondary}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: color,
      elevation: 3,
      content: Text(text, textAlign: TextAlign.center),
    ),
  );
}

class StarDisplayWidget extends StatelessWidget {
  final int value;
  final Widget filledStar;
  final Widget unfilledStar;
  const StarDisplayWidget({
    Key? key,
    this.value = 0,
    this.filledStar : const Icon(
      Icons.star,
      color: Colors.amber,
    ),
    this.unfilledStar : const Icon(
      Icons.star_border,
      color: Colors.amber,
    ),
  }) : assert(value != null), super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return index < value ? filledStar : unfilledStar;
      }),
    );
  }
}


