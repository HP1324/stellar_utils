import 'package:flutter/material.dart';

/// Wrap any widget that depends upon [controller] with this widget
///
/// This widget listens to [TabController.animation] instead of tab controller itself.
/// This allows to listen to changes faster when tab navigation occurs by swiping instead
/// of tapping on tabs.
///
/// [builder] gives the current selected tab index.
class TabBarListener extends StatefulWidget {
  const TabBarListener({super.key, required this.controller, required this.builder});

  /// The tab controller whose animation this widget will listen to
  final TabController controller;

  /// Gives the current selected tab and builds the child.
  final Widget Function(BuildContext, int) builder;

  @override
  State<TabBarListener> createState() => _TabBarListenerState();
}

class _TabBarListenerState extends State<TabBarListener> {
  int currentTab = 0;
  late final TabController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
    controller.animation?.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    controller.animation?.removeListener(_handleTabSelection);
    super.dispose();
  }

  void _handleTabSelection() {
    final indexChange = controller.offset.round();
    final index = controller.index + indexChange;

    if (index != currentTab) {
      setState(() {
        currentTab = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, currentTab);
  }
}
