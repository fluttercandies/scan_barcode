import 'package:flutter/material.dart';

class FullScreenWidthBox extends StatelessWidget {
  const FullScreenWidthBox({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.cover,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width,
        ),
        child: child,
      ),
    );
  }
}
