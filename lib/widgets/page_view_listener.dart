import 'package:flutter/material.dart';

/// Wrap any widget that depends upon [controller] with this widget.
/// This widget listens to [PageController] changes.
///
/// [builder] gives the current selected page index.
class PageViewListener extends StatefulWidget {
  const PageViewListener({super.key, required this.controller, required this.builder});

  /// The page controller this widget will listen to
  final PageController controller;

  /// Gives the current selected tab and builds the child.
  final Widget Function(BuildContext, int) builder;

  @override
  State<PageViewListener> createState() => _PageViewListenerState();
}

class _PageViewListenerState extends State<PageViewListener> {
  int currentPage = 0;
  late final PageController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
    controller.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    controller.removeListener(_handleTabSelection);
    super.dispose();
  }

  void _handleTabSelection() {
    final index = controller.page?.round() ?? 0;

    if (index != currentPage) {
      setState(() {
        currentPage = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, currentPage);
  }
}
