import 'package:flutter/material.dart';
import 'package:meetly/shared/theme/app_theme.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  static final List<_RecentActivity> _recentActivities = [
    _RecentActivity(
      title: 'New room "Design Hub" added',
      timestamp: '12 mins ago',
      icon: Icons.add_business_rounded,
      iconColor: AppTheme.brandGreen,
    ),
    _RecentActivity(
      title: 'Fatima updated profile information',
      timestamp: '30 mins ago',
      icon: Icons.account_circle_outlined,
      iconColor: AppTheme.brandSkin,
    ),
    _RecentActivity(
      title: 'Sprint Planning reserved Room 4A',
      timestamp: '1 hr ago',
      icon: Icons.event_available_rounded,
      iconColor: AppTheme.brandBlack,
    ),
  ];

  static final List<_UtilizationSlot> _utilization = [
    _UtilizationSlot(label: 'Morning', percentage: 0.82),
    _UtilizationSlot(label: 'Afternoon', percentage: 0.64),
    _UtilizationSlot(label: 'Evening', percentage: 0.37),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.brandBlack,
      appBar: AppBar(
        backgroundColor: AppTheme.brandBlack,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(
            color: AppTheme.brandBg,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // key: const PageStorageKey<String>('admin_dashboard_scroll'),
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // StatsGrid without padding - using Container to ensure proper sizing
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: const _StatsGrid(),
              ),

              // Everything else WITH padding
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    const _SectionTitle(title: 'Room Utilization'),
                    const SizedBox(height: 16),
                    _UtilizationList(utilization: _utilization),
                    const SizedBox(height: 32),
                    const _SectionTitle(title: 'Recent Activity'),
                    const SizedBox(height: 16),
                    _ActivityList(activities: _recentActivities),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: 270, // Fixed height to prevent layout issues
          child: Row(
            children: [
              // LEFT: Active Rooms (big rectangle)
              Expanded(
                // flex: , // takes more horizontal space
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: AppTheme.cardShadow,
                    color: AppTheme.brandDanger,
                  ),
                  // color: AppTheme.brandBg,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Active Rooms",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.brandBg,
                          ),
                        ),
                        SizedBox(height: 16),
                        Icon(
                          Icons.meeting_room_outlined,
                          size: 36,
                          color: AppTheme.brandBg,
                        ),
                        SizedBox(height: 16),
                        Text(
                          "24",
                          style: TextStyle(
                            color: AppTheme.brandBg,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // RIGHT: two stacked rectangles
              Expanded(
                flex: 1, // smaller horizontal space
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: AppTheme.cardDecoration,

                        padding: const EdgeInsets.all(10),
                        child: const Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center, // center vertically
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Scheduled Meetings",
                              style: TextStyle(
                                color: AppTheme.brandBlack,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                            SizedBox(height: 16),
                            Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.center, // center row
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.schedule_rounded,
                                  size: 18,
                                  color: AppTheme.brandBlack,
                                ),
                                SizedBox(
                                  width: 12,
                                ), // space between icon & text
                                Text(
                                  "18",
                                  style: TextStyle(
                                    color: AppTheme.brandBlack,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: AppTheme.cardDecoration,
                        padding: const EdgeInsets.all(10),
                        child: const Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center, // center vertically
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              "Total Users",
                              style: TextStyle(
                                color: AppTheme.brandBlack,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                            SizedBox(height: 16),
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment:
                                  CrossAxisAlignment.center, // center row
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.people_alt_rounded,
                                  size: 18,
                                  color: AppTheme.brandBlack,
                                ),
                                SizedBox(
                                  width: 12,
                                ), // space between icon & text
                                Text(
                                  "18",
                                  style: TextStyle(
                                    color: AppTheme.brandBlack,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _UtilizationList extends StatelessWidget {
  const _UtilizationList({required this.utilization});

  final List<_UtilizationSlot> utilization;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: AppTheme.brandBg,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          for (var slot in utilization) ...[
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    slot.label,
                    style: const TextStyle(
                      color: AppTheme.brandBlack,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: AppTheme.brandBullet,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: slot.percentage.clamp(0.0, 1.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.brandGreen,
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${(slot.percentage * 100).round()}%',
                  style: const TextStyle(
                    color: AppTheme.brandBlack,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            if (slot != utilization.last) const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }
}

class _ActivityList extends StatelessWidget {
  const _ActivityList({required this.activities});

  final List<_RecentActivity> activities;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.brandBg,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppTheme.cardShadow,
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: activities.length,
        separatorBuilder: (_, __) =>
            const Divider(height: 1, color: Color(0xFFE6E6E6)),
        itemBuilder: (context, index) {
          final activity = activities[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
            leading: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: activity.iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: Icon(activity.icon, color: AppTheme.brandBlack),
            ),
            title: Text(
              activity.title,
              style: const TextStyle(
                color: AppTheme.brandBlack,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            subtitle: Text(
              activity.timestamp,
              style: TextStyle(
                color: AppTheme.brandBlack.withOpacity(0.55),
                fontSize: 12,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: AppTheme.brandBg,
        fontWeight: FontWeight.w600,
        fontSize: 15,
      ),
    );
  }
}

class _RecentActivity {
  const _RecentActivity({
    required this.title,
    required this.timestamp,
    required this.icon,
    required this.iconColor,
  });

  final String title;
  final String timestamp;
  final IconData icon;
  final Color iconColor;
}

class _UtilizationSlot {
  const _UtilizationSlot({required this.label, required this.percentage});

  final String label;
  final double percentage;
}
