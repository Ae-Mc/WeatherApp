import 'dart:math';

import 'package:flutter/material.dart';

class CustomBottomSheet extends StatefulWidget {
  final Widget Function(BuildContext context, bool extended) builder;
  final void Function(bool extended)? onStateChange;
  final double minHeight;
  final double maxHeight;

  const CustomBottomSheet({
    Key? key,
    required this.builder,
    this.minHeight = 250,
    this.maxHeight = 500,
    this.onStateChange,
  }) : super(key: key);

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _currentChildHeight;
  bool extended = false;

  @override
  void initState() {
    _currentChildHeight = AnimationController(
      vsync: this,
      lowerBound: widget.minHeight,
      upperBound: widget.maxHeight,
    );
    _currentChildHeight.addListener(childHeightListener);
    super.initState();
  }

  void childHeightListener() {
    if (_currentChildHeight.value == widget.maxHeight) {
      if (extended != true) {
        setState(() {
          extended = true;
        });
        if (widget.onStateChange != null) {
          widget.onStateChange!(extended);
        }
      }
    } else if (_currentChildHeight.value == widget.minHeight) {
      if (extended != false) {
        setState(() {
          extended = false;
        });
        if (widget.onStateChange != null) {
          widget.onStateChange!(extended);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Duration getDuration(double finalPoint) {
      const maxDurationInMilliseconds = 300;
      abs(num x) => x < 0 ? -x : x;
      final pathLength = abs(_currentChildHeight.value - finalPoint);
      final maxPathLength = widget.maxHeight - widget.minHeight;
      return Duration(
        milliseconds:
            (maxDurationInMilliseconds * pathLength / maxPathLength).ceil(),
      );
    }

    return GestureDetector(
      onVerticalDragUpdate: (drag) {
        _currentChildHeight.value -= drag.delta.dy;
        _currentChildHeight.value =
            max(widget.minHeight, _currentChildHeight.value);
        _currentChildHeight.value =
            min(widget.maxHeight, _currentChildHeight.value);
      },
      onVerticalDragEnd: (details) {
        final middleHeightFactor = (widget.minHeight + widget.maxHeight) / 2;
        final _bottomSheetHeightFactorWithAddedVelocity =
            _currentChildHeight.value - details.velocity.pixelsPerSecond.dy;
        if (_bottomSheetHeightFactorWithAddedVelocity > middleHeightFactor) {
          _currentChildHeight.animateTo(
            widget.maxHeight,
            duration: getDuration(widget.maxHeight),
            curve: Curves.easeOut,
          );
        } else {
          _currentChildHeight.animateTo(
            widget.minHeight,
            duration: getDuration(widget.minHeight),
            curve: Curves.easeOut,
          );
        }
        setState(() {});
      },
      child: AnimatedBuilder(
        animation: _currentChildHeight,
        builder: (context, child) => SizedBox(
          width: double.infinity,
          height: _currentChildHeight.value,
          child: child,
        ),
        child: widget.builder(context, extended),
      ),
    );
  }
}
