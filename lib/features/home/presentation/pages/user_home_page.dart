import 'package:flutter/material.dart';
import 'package:meetly/features/home/presentation/pages/calender_page.dart';
import 'package:meetly/features/home/presentation/widgets/calendar_app_bar.dart';
import 'package:meetly/features/home/presentation/widgets/highlight_card.dart';
import 'package:meetly/features/home/presentation/widgets/schedule_card.dart';
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

    final double horizontalPadding = _clamp(size.width * 0.025, 10, 24);
    final double verticalPadding = _clamp(size.height * 0.01, 10, 24);
    final double verticalSpacing = _clamp(size.height * 0.025, 14, 32);
    final double navHorizontalMargin = _clamp(size.width * 0.05, 16, 28);
    final double navBottomMargin = _clamp(size.height * 0.03, 16, 30);
    final double navItemPaddingValue = _clamp(size.width * 0.03, 10, 16);
    final double navItemRadius = _clamp(size.width * 0.08, 18, 26);
    final double navIconSize = isTabletWidth ? 30 : (isCompactWidth ? 22 : 26);

    final Widget homeView = LayoutBuilder(
      key: const ValueKey('home-layout'),
      builder: (context, constraints) {
        final EdgeInsets scrollPadding = EdgeInsets.fromLTRB(
          horizontalPadding,
          verticalPadding,
          horizontalPadding,
          verticalPadding + mediaQuery.padding.bottom + navBottomMargin,
        );

        if (isWideLayout) {
          return SingleChildScrollView(
            key: const ValueKey('home-wide'),
            padding: scrollPadding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: ScheduleCard()),
                SizedBox(width: horizontalPadding),
                Expanded(child: HighlightCard()),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          key: const ValueKey('home-compact'),
          padding: scrollPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ScheduleCard(),
              SizedBox(height: verticalSpacing),
              HighlightCard(),
            ],
          ),
        );
      },
    );

    return Scaffold(
      backgroundColor: AppTheme.brandBlack,
      appBar: _selectedIndex == 0
          ? CalendarAppBar(height: isTabletWidth ? 260 : 220)
          : null,
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

      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        child: () {
          switch (_selectedIndex) {
            case 1:
              return CalendarPage();
            case 2:
              return const SettingsPage();
            default:
              return homeView;
          }
        }(),
      ),
    );
  }
}
