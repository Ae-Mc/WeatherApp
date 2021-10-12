import 'dart:math';

import 'package:flutter/material.dart';

class CustomBottomSheet extends StatefulWidget {
  final Widget Function(BuildContext context, bool extended) builder;
  final double minChildFactor;
  final double maxChildFactor;

  const CustomBottomSheet({
    Key? key,
    required this.builder,
    this.minChildFactor = 0.25,
    this.maxChildFactor = 0.5,
  }) : super(key: key);

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _currentChildFactor;
  bool extended = false;

  @override
  void initState() {
    _currentChildFactor = AnimationController(
      vsync: this,
      value: widget.minChildFactor,
    );
    _currentChildFactor.addListener(childFactorListener);
    super.initState();
  }

  void childFactorListener() {
    if (_currentChildFactor.value == widget.maxChildFactor) {
      setState(() {
        extended = true;
      });
    } else if (_currentChildFactor.value == widget.minChildFactor) {
      setState(() {
        extended = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Duration getDuration(double value) {
      const maxDurationInMilliseconds = 300;
      final pathLength = _currentChildFactor.value - widget.minChildFactor;
      final maxPathLength = widget.maxChildFactor - widget.minChildFactor;
      return Duration(
        milliseconds:
            (maxDurationInMilliseconds * pathLength / maxPathLength).ceil(),
      );
    }

    final mediaQuery = MediaQuery.of(context);
    final safeScreenHeight = mediaQuery.size.height -
        mediaQuery.padding.top -
        mediaQuery.padding.bottom;

    return GestureDetector(
      onVerticalDragUpdate: (drag) {
        _currentChildFactor.value -= drag.delta.dy / safeScreenHeight;
        _currentChildFactor.value =
            max(widget.minChildFactor, _currentChildFactor.value);
        _currentChildFactor.value =
            min(widget.maxChildFactor, _currentChildFactor.value);
      },
      onVerticalDragEnd: (details) {
        final middleHeightFactor =
            (widget.maxChildFactor + widget.minChildFactor) / 2;
        final _bottomSheetHeightFactorWithAddedVelocity =
            _currentChildFactor.value -
                details.velocity.pixelsPerSecond.dy / safeScreenHeight;
        if (_bottomSheetHeightFactorWithAddedVelocity > middleHeightFactor) {
          _currentChildFactor.animateTo(
            widget.maxChildFactor,
            duration:
                getDuration(widget.maxChildFactor - _currentChildFactor.value),
            curve: Curves.easeOut,
          );
        } else {
          _currentChildFactor.animateTo(
            widget.minChildFactor,
            duration:
                getDuration(_currentChildFactor.value - widget.minChildFactor),
            curve: Curves.easeOut,
          );
        }
        setState(() {});
      },
      child: AnimatedBuilder(
        animation: _currentChildFactor,
        builder: (context, child) => FractionallySizedBox(
          widthFactor: 1,
          heightFactor: _currentChildFactor.value,
          child: child,
        ),
        child: widget.builder(context, extended),
      ),
    );
  }
}
