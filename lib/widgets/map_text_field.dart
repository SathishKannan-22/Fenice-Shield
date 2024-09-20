import 'package:flutter/material.dart';

class CurvedTextField extends StatefulWidget {
  final Function(String) onSubmitted;
  final TextEditingController controller;

  const CurvedTextField(
      {super.key, required this.onSubmitted, required this.controller});

  @override
  CurvedTextFieldState createState() => CurvedTextFieldState();
}

class CurvedTextFieldState extends State<CurvedTextField> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 60,
      left: 20,
      right: 20,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          cursorColor: const Color.fromARGB(255, 49, 121, 46),
          controller: widget.controller,
          onSubmitted: widget.onSubmitted,
          decoration: const InputDecoration(
            hintText: "Search for an address",
            border: InputBorder.none,
            prefixIcon: Icon(
              Icons.location_on_outlined,
              color: Color.fromARGB(255, 49, 121, 46),
            ),
            suffixIcon: Icon(
              Icons.search,
              color: Color.fromARGB(255, 49, 121, 46),
            ),
          ),
        ),
      ),
    );
  }
}
