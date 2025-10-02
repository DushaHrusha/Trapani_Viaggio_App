import 'package:flutter/cupertino.dart';

class GreyLine extends StatelessWidget {
  const GreyLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Color.fromRGBO(224, 224, 224, 1), width: 1.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(255, 255, 255, 0.75),
            offset: Offset(0, 1),
            blurRadius: 1.0,
          ),
          BoxShadow(
            color: Color.fromRGBO(255, 255, 255, 0.75),
            offset: Offset(0, -1),
            blurRadius: 1.0,
          ),
        ],
      ),
    );
  }
}
