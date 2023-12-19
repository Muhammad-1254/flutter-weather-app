import 'package:flutter/material.dart';

class AdditionalInformationItems extends StatelessWidget {
  final IconData icon;
  final String information;
  final String value;

  const AdditionalInformationItems(
      {super.key,
      required this.icon,
      required this.information,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      // padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, size: 34),
        const SizedBox(
          height: 12,
        ),
        Text(
          information,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w100,
            color: Colors.white70,
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          value,
          style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w100, color: Colors.white60),
        )
      ]),
    );
  }
}
