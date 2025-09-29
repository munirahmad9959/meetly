import 'package:flutter/material.dart';
import 'package:meetly/features/settings/presentation/pages/settings_page.dart';
import 'package:meetly/shared/theme/app_theme.dart';

class HighlightCard extends StatelessWidget {
  const HighlightCard({Key? key}) : super(key: key);

  double _clamp(double value, double min, double max) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;
    final bool isCompactWidth = size.width < 360;
    final bool isTabletWidth = size.width >= 600;
    final double verticalSpacingSmall = _clamp(size.height * 0.015, 8, 20);

    final double cardPadding = _clamp(size.width * 0.05, 20, 32);
    final double actionButtonSize = _clamp(size.width * 0.18, 44, 60);
    final double actionIconSize = isTabletWidth ? 26 : 24;

    // Fixed font sizes - more balanced and consistent
    final double highlightTitleFont = isTabletWidth
        ? 20 // Reduced from 26
        : (isCompactWidth ? 16 : 18); // Reduced from 16/20
    final double highlightSubtitleFont = isTabletWidth
        ? 14 // Reduced from 16
        : (isCompactWidth ? 12 : 13); // Reduced from 12/13
    return Container(
      padding: EdgeInsets.all(cardPadding),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(34)),
        color: AppTheme.brandSkin,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Team Meeting',
                  style: TextStyle(
                    color: AppTheme.brandBlack,
                    fontSize: highlightTitleFont,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: verticalSpacingSmall),
                Text(
                  'Discussing the project with the team',
                  style: TextStyle(
                    color: AppTheme.brandBlack,
                    fontSize: highlightSubtitleFont,
                    fontWeight: FontWeight.normal,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: verticalSpacingSmall),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
            child: Container(
              width: actionButtonSize,
              height: actionButtonSize,
              decoration: const BoxDecoration(
                color: AppTheme.brandBlack,
                borderRadius: BorderRadius.all(Radius.circular(34)),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: actionIconSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
