import 'package:material_ui/material_ui.dart';

class RepeatingButton extends StatefulWidget {
  const RepeatingButton({
    super.key,
    required this.onTap,
    required this.child,
    this.initialDelay = const Duration(milliseconds: 300),
    this.interval = const Duration(milliseconds: 80),
  });

  final VoidCallback? onTap;
  final Widget child;
  final Duration initialDelay;
  final Duration interval;

  @override
  State<RepeatingButton> createState() => _RepeatingButtonState();
}

class _RepeatingButtonState extends State<RepeatingButton> {
  bool _pressing = false;

  Future<void> _startRepeating() async {
    _pressing = true;
    await Future.delayed(widget.initialDelay);
    while (_pressing && mounted && widget.onTap != null) {
      widget.onTap!();
      await Future.delayed(widget.interval);
    }
  }

  void _stopRepeating() => _pressing = false;

  @override
  void dispose() {
    _pressing = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null;

    return GestureDetector(
      onTap: widget.onTap,
      onLongPressStart: enabled ? (_) => _startRepeating() : null,
      onLongPressEnd: (_) => _stopRepeating(),
      onLongPressCancel: _stopRepeating,
      child: widget.child,
    );
  }
}
