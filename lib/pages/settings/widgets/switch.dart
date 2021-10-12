import 'package:flutter/material.dart';

class Switch extends StatelessWidget {
  final Duration duration;
  final bool state;
  final String text1;
  final String text2;

  const Switch({
    Key? key,
    required this.duration,
    required this.state,
    required this.text1,
    required this.text2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1000),
        ),
        constraints: const BoxConstraints(minHeight: 25, minWidth: 122),
        child: IntrinsicHeight(
          child: Stack(
            children: [
              AnimatedAlign(
                alignment: state ? Alignment.centerRight : Alignment.centerLeft,
                duration: duration,
                curve: Curves.easeInOut,
                child: FractionallySizedBox(
                  widthFactor: 0.5,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(1000),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Center(
                      child: AnimatedDefaultTextStyle(
                        child: Text(text1),
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                              color: state
                                  ? Theme.of(context).colorScheme.onBackground
                                  : Theme.of(context).colorScheme.onSecondary,
                            ),
                        duration: duration,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: AnimatedDefaultTextStyle(
                        child: Text(text2),
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                              color: state
                                  ? Theme.of(context).colorScheme.onSecondary
                                  : Theme.of(context).colorScheme.onBackground,
                            ),
                        duration: duration,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
