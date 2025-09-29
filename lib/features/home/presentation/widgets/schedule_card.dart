import 'package:flutter/material.dart';
import 'package:meetly/features/settings/presentation/pages/settings_page.dart';
import 'package:meetly/shared/theme/app_theme.dart';

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({Key? key}) : super(key: key);

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
    final double verticalSpacing = _clamp(size.height * 0.025, 14, 32);
    final double verticalSpacingSmall = _clamp(size.height * 0.015, 8, 20);

    final double cardPadding = _clamp(size.width * 0.05, 20, 32);
    final double actionButtonSize = _clamp(size.width * 0.18, 44, 60);
    final double actionIconSize = isTabletWidth ? 26 : 24;
    final double avatarSize = _clamp(size.width * 0.15, 36, 56);
    final double scheduleRowSpacing = verticalSpacingSmall;

    // Fixed font sizes - more balanced and consistent
    final double highlightSubtitleFont = isTabletWidth
        ? 14 // Reduced from 16
        : (isCompactWidth ? 12 : 13);
    final double sessionTitleFont = isTabletWidth
        ? 24 // Reduced from 36
        : (isCompactWidth ? 20 : 22); // Reduced from 24/30
    final double sessionSubtitleFont = isTabletWidth
        ? 14 // Reduced from 20
        : (isCompactWidth ? 12 : 13); // Reduced from 14/16.5
    final double tagFontSize = isTabletWidth 
        ? 14 // Reduced from 20
        : (isCompactWidth ? 12 : 13); // Reduced from 15/18
    
    final EdgeInsets tagPadding = EdgeInsets.symmetric(
      horizontal: _clamp(size.width * 0.03, 8, 14),
      vertical: _clamp(size.height * 0.005, 4, 8),
    );
    
    return Container(
      padding: EdgeInsets.all(cardPadding),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(34)),
        color: AppTheme.brandBg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  '12:00 - 13:00 PM',
                  style: TextStyle(
                    color: AppTheme.brandBlack,
                    fontSize: highlightSubtitleFont,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                width: avatarSize + (avatarSize * 0.6),
                height: avatarSize,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: 0,
                      child: ClipOval(
                        child: Image.asset(
                          'assets/avatar-removebg.png',
                          width: avatarSize,
                          height: avatarSize,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      left: avatarSize * 0.45,
                      child: ClipOval(
                        child: Image.asset(
                          'assets/avatar-removebg.png',
                          width: avatarSize,
                          height: avatarSize,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: verticalSpacing),
          Text(
            'One-to-one',
            style: TextStyle(
              color: AppTheme.brandBlack,
              fontSize: sessionTitleFont,
              fontWeight: FontWeight.w600,
              height: 1.1,
            ),
          ),
          SizedBox(height: verticalSpacingSmall),
          Text(
            'Repeats every two weeks',
            style: TextStyle(
              color: AppTheme.brandBlack,
              fontSize: sessionSubtitleFont,
              fontWeight: FontWeight.w400,
              height: 1.3,
            ),
          ),
          SizedBox(height: verticalSpacing),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Wrap(
                  spacing: scheduleRowSpacing,
                  runSpacing: scheduleRowSpacing / 2,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.brandBullet,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: tagPadding,
                      child: Text(
                        'Today',
                        style: TextStyle(
                          color: AppTheme.brandBlack,
                          fontSize: tagFontSize,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.brandBullet,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: tagPadding,
                      child: Text(
                        '1h',
                        style: TextStyle(
                          color: AppTheme.brandBlack,
                          fontSize: tagFontSize - 1, // Reduced from -2 for better balance
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: scheduleRowSpacing),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
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
                    Icons.arrow_outward_rounded,
                    color: Colors.white,
                    size: actionIconSize,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}