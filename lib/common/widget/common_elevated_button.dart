import 'package:comment_like/common/spacing/common_spacing.dart';
import 'package:comment_like/common/widget/common_text.dart';
import 'package:flutter/material.dart';

class CommonElevatedButton extends StatelessWidget {

  final Color buttonColor;
  final Color textColor;
  final String text;
  final VoidCallback? onPressed;


  const CommonElevatedButton({
    super.key,
    this.buttonColor = Colors.teal,
    this.text = "",
    this.textColor = Colors.white,
    this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
        ),
      ),
      child: CommonText(text: text, textColor: textColor, fontWeight: TextWeight.bold),
    );
  }
}
