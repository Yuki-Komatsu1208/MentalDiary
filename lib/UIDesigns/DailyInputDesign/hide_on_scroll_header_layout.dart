import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HideOnScrollHeaderLayout extends StatefulWidget {
  const HideOnScrollHeaderLayout({
    super.key,
    required this.header,
    required this.body,
  });

  final Widget header;
  final Widget body;

  @override
  State<HideOnScrollHeaderLayout> createState() =>
      _HideOnScrollHeaderLayoutState();
}

class _HideOnScrollHeaderLayoutState extends State<HideOnScrollHeaderLayout> {
  bool _isHeaderVisible = true;

  bool _handleScrollNotification(UserScrollNotification notification) {
    if (notification.metrics.pixels <= 0) {
      if (!_isHeaderVisible && mounted) {
        setState(() {
          _isHeaderVisible = true;
        });
      }
      return false;
    }

    if (notification.direction == ScrollDirection.reverse && _isHeaderVisible) {
      setState(() {
        _isHeaderVisible = false;
      });
    } else if (notification.direction == ScrollDirection.forward &&
        !_isHeaderVisible) {
      setState(() {
        _isHeaderVisible = true;
      });
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 1, end: _isHeaderVisible ? 1 : 0),
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            builder: (
              BuildContext context,
              double visibilityFactor,
              Widget? child,
            ) {
              return ClipRect(
                child: Align(
                  heightFactor: visibilityFactor,
                  child: Opacity(
                    opacity: visibilityFactor.clamp(0.0, 1.0),
                    child: child,
                  ),
                ),
              );
            },
            child: widget.header,
          ),
          Expanded(
            child: NotificationListener<UserScrollNotification>(
              onNotification: _handleScrollNotification,
              child: widget.body,
            ),
          ),
        ],
      ),
    );
  }
}
