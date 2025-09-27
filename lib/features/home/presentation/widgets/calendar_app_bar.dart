import 'package:flutter/material.dart';
import 'package:meetly/shared/theme/app_theme.dart';

class CalendarAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;

  const CalendarAppBar({super.key, this.height = 200});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final currentMonth = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ][now.month];

    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      toolbarHeight: height,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: AppTheme.brandDanger,
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(34),
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white, size: 34),
                      onPressed: () {},
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: CircleAvatar(
                      radius: 22,
                      backgroundImage: AssetImage('assets/avatar.png'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  children: [
                    Text(
                      currentMonth,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 50,
                child: Row(children: _buildWeekDays(now)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildWeekDays(DateTime now) {
    final List<Widget> dayWidgets = [];
    final startOfWeek = now.subtract(Duration(days: now.weekday % 7));

    for (int i = 0; i < 7; i++) {
      final date = startOfWeek.add(Duration(days: i));
      final dayName = [
        'Sun',
        'Mon',
        'Tue',
        'Wed',
        'Thu',
        'Fri',
        'Sat',
      ][date.weekday % 7];
      final isToday =
          date.day == now.day &&
          date.month == now.month &&
          date.year == now.year;

      dayWidgets.add(
        Expanded(
          // 🔹 Each day takes equal width
          child: _dayWidget(dayName, date.day.toString(), isSelected: isToday),
        ),
      );
    }

    return dayWidgets;
  }

  Widget _dayWidget(String day, String date, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.brandBg : Colors.transparent,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: TextStyle(
              color: isSelected ? AppTheme.brandBlack : AppTheme.brandBg,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            date,
            style: TextStyle(
              color: isSelected ? AppTheme.brandBlack : AppTheme.brandBg,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
