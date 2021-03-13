import 'package:flutter/material.dart';
import 'package:sqlite_crud/constant.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    Key key,
    this.press,
    this.text,
  }) : super(key: key);

  final Function press;
  final String text;

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return RaisedButton(
      onPressed: press,
      color: kPrimaryColor,
      textColor: Colors.white,
      child: Text(
        text,
      ),
    );
  }
}
