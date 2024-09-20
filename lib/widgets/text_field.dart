import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

class TextFieldWidget extends StatefulWidget {
  final String labelText;
  final String hintText;
  final String iconData;
  final TextInputType keyboardtype;
  final TextEditingController controller;
  final bool obscureText;

  const TextFieldWidget({
    required this.labelText,
    required this.hintText,
    required this.iconData,
    required this.controller,
    required this.keyboardtype,
    required this.obscureText,
    super.key,
  });

  @override
  TextFieldWidgetState createState() => TextFieldWidgetState();
}

class TextFieldWidgetState extends State<TextFieldWidget> {
  bool isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          isFocused = hasFocus;
        });
      },
      child: SizedBox(
        height: 60,
        width: double.infinity,
        child: Material(
          elevation: isFocused ? 3 : 0,
          borderRadius:
              isFocused ? BorderRadius.circular(20) : BorderRadius.circular(50),
          child: TextField(
            keyboardType: widget.keyboardtype,
            controller: widget.controller,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            cursorColor: const Color.fromARGB(255, 49, 121, 46),
            obscureText: widget.obscureText,
            decoration: InputDecoration(
              fillColor: isFocused ? Colors.white : Colors.white,
              filled: true,
              contentPadding: const EdgeInsets.all(10),
              labelText: widget.labelText,
              labelStyle: const TextStyle(
                fontSize: 18,
                color: Color.fromARGB(255, 184, 184, 184),
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Iconify(
                  widget.iconData,
                  size: 16,
                  color: const Color.fromARGB(255, 49, 121, 46),
                ),
              ),
              border: const UnderlineInputBorder(
                borderSide: BorderSide.none,
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
