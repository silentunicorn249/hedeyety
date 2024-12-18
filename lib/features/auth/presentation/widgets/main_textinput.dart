import 'package:flutter/material.dart';

class MainTextInput extends StatelessWidget {
  final String hintText;
  final bool isObscure;
  final TextInputType keyboardType;
  final Function(String) onChanged;

  const MainTextInput({
    Key? key,
    required this.hintText,
    this.isObscure = false,
    this.keyboardType = TextInputType.text,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: isObscure,
      keyboardType: keyboardType,
      textAlign: TextAlign.center,
      style: const TextStyle(color: Colors.black),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
      ),
    );
  }
}
