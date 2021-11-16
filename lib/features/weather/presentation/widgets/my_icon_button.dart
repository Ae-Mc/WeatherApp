import 'package:flutter/material.dart';

class MyIconButton extends StatelessWidget {
  final void Function() onTap;
  final Widget icon;
  final int size;

  const MyIconButton({
    Key? key,
    required this.onTap,
    required this.icon,
    this.size = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Ink(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).brightness == Brightness.light
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.background,
          boxShadow: [
            const BoxShadow(
              color: Colors.white12,
              blurRadius: 3,
              offset: Offset(-2, -2),
            ),
            if (Theme.of(context).brightness == Brightness.light)
              const BoxShadow(
                color: Colors.black26,
                blurRadius: 3,
                offset: Offset(1, 2),
              ),
          ],
        ),
        child: Center(child: icon),
      ),
    );
  }
}
