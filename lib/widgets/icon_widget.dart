import 'package:material_ui/material_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hugeicons/hugeicons.dart';

typedef HugeIconsIconType = List<List<int>>;

/// Wrapper for icons, it is useful when we want to use multiple types of icons
/// in a project, like HugeIcons, FontAwesomeIcons etc.
class IconWidget extends StatelessWidget {
  const IconWidget({
    super.key,
    required this.icon,
    this.size =22,
    this.color,
  });

  final dynamic icon;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (icon is HugeIconsIconType) {
      return SizedBox(
        width: size,
        height: size,
        child: HugeIcon(icon: icon, color: color),
      );
    } else if (icon is FaIconData) {
      return FaIcon(icon, size: size, color: color);
    } else {
      return Icon(icon, size: size, color: color);
    }
  }
}
