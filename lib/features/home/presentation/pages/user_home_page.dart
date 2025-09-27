import 'package:flutter/material.dart';
import 'package:meetly/features/home/presentation/widgets/calendar_app_bar.dart';
import 'package:meetly/features/settings/presentation/pages/settings_page.dart';
import 'package:meetly/shared/theme/app_theme.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({Key? key}) : super(key: key);

  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  int _selectedIndex = 0;

  final List<IconData> _navIcons = const [
    Icons.home_rounded,
    Icons.calendar_month_rounded,
    Icons.person_rounded,
  ];

  double _clamp(double value, double min, double max) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
  }

  void _onNavTapped(int index) {
    if (_selectedIndex == index) return;
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildNavItem({
    required int index,
    required double iconSize,
    required EdgeInsets padding,
    required double radius,
  }) {
    final bool isSelected = _selectedIndex == index;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(radius),
        onTap: () => _onNavTapped(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: padding,
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.brandBlack : Colors.transparent,
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Icon(
            _navIcons[index],
            size: iconSize,
            color: isSelected ? Colors.white : AppTheme.brandBlack,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;
    final bool isCompactWidth = size.width < 360;
    final bool isTabletWidth = size.width >= 600;
    final bool isWideLayout = size.width >= 720;

    final double horizontalPadding = _clamp(size.width * 0.06, 12, 28);
    final double verticalPadding = _clamp(size.height * 0.02, 12, 28);
    final double verticalSpacing = _clamp(size.height * 0.025, 14, 32);
    final double verticalSpacingSmall = _clamp(size.height * 0.015, 8, 20);
    final double navHorizontalMargin = _clamp(size.width * 0.05, 16, 28);
    final double navBottomMargin = _clamp(size.height * 0.03, 16, 30);
    final double navItemPaddingValue = _clamp(size.width * 0.03, 10, 16);
    final double navItemRadius = _clamp(size.width * 0.08, 18, 26);
    final double navIconSize = isTabletWidth ? 30 : (isCompactWidth ? 22 : 26);

    final double cardPadding = _clamp(size.width * 0.05, 20, 32);
    final double actionButtonSize = _clamp(size.width * 0.18, 44, 60);
    final double actionIconSize = isTabletWidth ? 26 : 24;
    final double avatarSize = _clamp(size.width * 0.15, 36, 56);
    final double scheduleRowSpacing = verticalSpacingSmall;

    final double highlightTitleFont = isTabletWidth ? 26 : (isCompactWidth ? 16 : 20);
    final double highlightSubtitleFont = isTabletWidth ? 16 : (isCompactWidth ? 12 : 13);
    final double sessionTitleFont = isTabletWidth ? 36 : (isCompactWidth ? 24 : 30);
    final double sessionSubtitleFont = isTabletWidth ? 20 : (isCompactWidth ? 14 : 16.5);
    final double tagFontSize = isTabletWidth ? 20 : (isCompactWidth ? 15 : 18);
    final EdgeInsets tagPadding = EdgeInsets.symmetric(
      horizontal: _clamp(size.width * 0.03, 8, 14),
      vertical: _clamp(size.height * 0.005, 4, 8),
    );

    Widget highlightCard() {
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
                      fontWeight: FontWeight.bold,
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

    Widget scheduleCard() {
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
                fontWeight: FontWeight.bold,
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
                            fontSize: tagFontSize - 2,
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

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CalendarAppBar(height: isTabletWidth ? 260 : 220),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(
          navHorizontalMargin,
          0,
          navHorizontalMargin,
          navBottomMargin,
        ),
        child: SafeArea(
          top: false,
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.brandBg,
              borderRadius: BorderRadius.circular(navItemRadius + 8),
              boxShadow: AppTheme.cardShadow,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(navItemRadius + 8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                    _navIcons.length,
                    (index) => _buildNavItem(
                      index: index,
                      iconSize: navIconSize,
                      padding: EdgeInsets.all(navItemPaddingValue),
                      radius: navItemRadius,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          final EdgeInsets scrollPadding = EdgeInsets.fromLTRB(
            horizontalPadding,
            verticalPadding,
            horizontalPadding,
            verticalPadding + mediaQuery.padding.bottom + navBottomMargin,
          );

          if (isWideLayout) {
            return SingleChildScrollView(
              padding: scrollPadding,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: highlightCard()),
                  SizedBox(width: horizontalPadding),
                  Expanded(child: scheduleCard()),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: scrollPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                highlightCard(),
                SizedBox(height: verticalSpacing),
                scheduleCard(),
              ],
            ),
          );
        },
      ),
    );
  }
}
