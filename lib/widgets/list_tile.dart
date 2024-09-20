import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const CustomListTile({
    Key? key,
    required this.text,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 191, 230, 188),
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon(
              icon,
              color: const Color.fromARGB(255, 49, 121, 46),
              size: 30,
            ),
          ),
        ),
        title: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 30,
          color: Color.fromARGB(255, 49, 121, 46),
        ),
      ),
    );
  }
}
