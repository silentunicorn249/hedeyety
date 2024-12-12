
import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  late String text;
  late Color color;
  late VoidCallback clbFn;

  MainButton({required this.clbFn, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: clbFn,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            text,
          ),
        ),
      ),
    );
  }
}
