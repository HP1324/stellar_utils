import 'package:material_ui/material_ui.dart';
import 'package:stellar_utils/extensions.dart';

class EmptyPlaceholder extends StatefulWidget {
  const EmptyPlaceholder({super.key, required this.title, this.description, this.icon});

  final String title;

  final String? description;

  final Icon? icon;


  @override
  State<EmptyPlaceholder> createState() => _EmptyPlaceholderState();
}

class _EmptyPlaceholderState extends State<EmptyPlaceholder> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _scaleAnimation = Tween(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    final textTheme = context.textTheme;
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Decorative illustration container
                if (widget.icon != null) widget.icon!,
                Text(
                  widget.title,
                  textAlign: .center,
                  style: textTheme.bodyLarge!.copyWith(
                    fontSize: textTheme.bodyLarge!.fontSize! + 3,
                    fontWeight: FontWeight.bold,
                    color: scheme.onSurface.withValues(alpha: 0.88),
                  ),
                ),
                if (widget.description != null)
                  Text(
                    widget.description!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: scheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GradientCircleContainer extends StatelessWidget {
  const GradientCircleContainer({super.key, this.child, this.width, this.height});

  final Widget? child;

  final double? width;

  final double? height;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    return Container(
      width: width ?? 95,
      height: height ?? 95,
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        gradient: LinearGradient(
          colors: [
            scheme.primary,
            scheme.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(60),
      ),
      child: child,
    );
  }
}
