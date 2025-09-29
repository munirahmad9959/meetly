import 'package:flutter/material.dart';
import 'package:meetly/shared/theme/app_theme.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final List<MeetingFilter> _selectedFilters = [];
  final List<MeetingType> _selectedTypes = [];

  static final List<_Meeting> _meetings = [
    _Meeting(
      title: 'Design Sync',
      dateLabel: 'Today · Mon, 24 Jan',
      timeSlot: '10:00 AM - 11:00 AM',
      location: 'Zoom',
      notes: 'Review new branding system and approve final palette.',
      participants: ['Aisha', 'Jordan', 'Lee'],
      meetingType: MeetingType.team,
      dateTime: DateTime(2024, 1, 24, 10, 0),
    ),
    _Meeting(
      title: 'Product Standup',
      dateLabel: 'Tomorrow · Tue, 25 Jan',
      timeSlot: '09:00 AM - 09:30 AM',
      location: 'Huddle Room 2',
      notes: 'Quick surface check on active sprints and blockers.',
      participants: ['Maria', 'Zane', 'Selena', 'Abdul'],
      meetingType: MeetingType.sprint,
      dateTime: DateTime(2024, 1, 25, 9, 0),
    ),
    _Meeting(
      title: 'Client Review',
      dateLabel: 'Fri, 28 Jan',
      timeSlot: '02:30 PM - 03:30 PM',
      location: 'Google Meet',
      notes: 'Walk through the latest deliverables with the client.',
      participants: ['Nadia', 'Omar', 'Alex'],
      meetingType: MeetingType.client,
      dateTime: DateTime(2024, 1, 28, 14, 30),
    ),
    _Meeting(
      title: 'Emergency Budget Meeting',
      dateLabel: 'Today · Mon, 24 Jan',
      timeSlot: '04:00 PM - 05:00 PM',
      location: 'Conference Room A',
      notes: 'Urgent discussion about Q1 budget adjustments.',
      participants: ['CEO', 'CFO', 'CTO'],
      meetingType: MeetingType.urgent,
      dateTime: DateTime(2024, 1, 24, 16, 0),
    ),
    _Meeting(
      title: 'Sprint Planning',
      dateLabel: 'Wed, 26 Jan',
      timeSlot: '11:00 AM - 12:30 PM',
      location: 'Zoom',
      notes: 'Plan tasks for the upcoming sprint.',
      participants: ['Dev Team', 'Product Manager'],
      meetingType: MeetingType.sprint,
      dateTime: DateTime(2024, 1, 26, 11, 0),
    ),
  ];

  List<_Meeting> get _filteredMeetings {
    if (_selectedFilters.isEmpty && _selectedTypes.isEmpty) {
      return _meetings;
    }

    return _meetings.where((meeting) {
      // Time-based filtering
      var timeFilter = true;
      if (_selectedFilters.contains(MeetingFilter.morning) &&
          meeting.dateTime.hour >= 12) {
        timeFilter = false;
      }
      if (_selectedFilters.contains(MeetingFilter.afternoon) &&
          (meeting.dateTime.hour < 12 || meeting.dateTime.hour >= 17)) {
        timeFilter = false;
      }
      if (_selectedFilters.contains(MeetingFilter.evening) &&
          meeting.dateTime.hour < 17) {
        timeFilter = false;
      }

      // Date-based filtering
      var dateFilter = true;
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = today.add(const Duration(days: 1));

      if (_selectedFilters.contains(MeetingFilter.today)) {
        final meetingDate = DateTime(
          meeting.dateTime.year,
          meeting.dateTime.month,
          meeting.dateTime.day,
        );
        dateFilter = meetingDate == today;
      }
      if (_selectedFilters.contains(MeetingFilter.tomorrow)) {
        final meetingDate = DateTime(
          meeting.dateTime.year,
          meeting.dateTime.month,
          meeting.dateTime.day,
        );
        dateFilter = meetingDate == tomorrow;
      }
      if (_selectedFilters.contains(MeetingFilter.thisWeek)) {
        final nextWeek = today.add(const Duration(days: 7));
        dateFilter = meeting.dateTime.isAfter(
              today.subtract(const Duration(days: 1)),
            ) &&
            meeting.dateTime.isBefore(nextWeek);
      }

      // Type-based filtering
      final typeFilter =
          _selectedTypes.isEmpty || _selectedTypes.contains(meeting.meetingType);

      return timeFilter && dateFilter && typeFilter;
    }).toList();
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppTheme.brandBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Filter Meetings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.brandBlack,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Time Filters
                    const Text(
                      'Time of Day',
                      style: TextStyle(
                        color: AppTheme.brandBlack,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: MeetingFilter.timeFilters.map((filter) {
                        return FilterChip(
                          label: Text(filter.label),
                          selected: _selectedFilters.contains(filter),
                          onSelected: (selected) {
                            setModalState(() {
                              if (selected) {
                                _selectedFilters.add(filter);
                              } else {
                                _selectedFilters.remove(filter);
                              }
                            });
                          },
                          backgroundColor: AppTheme.brandBullet,
                          selectedColor: AppTheme.brandBlack,
                          labelStyle: TextStyle(
                            color: _selectedFilters.contains(filter)
                                ? AppTheme.brandBg
                                : AppTheme.brandBlack,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 20),

                    // Date Filters
                    const Text(
                      'Date',
                      style: TextStyle(
                        color: AppTheme.brandBlack,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: MeetingFilter.dateFilters.map((filter) {
                        return FilterChip(
                          label: Text(filter.label),
                          selected: _selectedFilters.contains(filter),
                          onSelected: (selected) {
                            setModalState(() {
                              if (selected) {
                                _selectedFilters.add(filter);
                              } else {
                                _selectedFilters.remove(filter);
                              }
                            });
                          },
                          backgroundColor: AppTheme.brandBullet,
                          selectedColor: AppTheme.brandBlack,
                          labelStyle: TextStyle(
                            color: _selectedFilters.contains(filter)
                                ? AppTheme.brandBg
                                : AppTheme.brandBlack,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 20),

                    // Meeting Type Filters
                    const Text(
                      'Meeting Type',
                      style: TextStyle(
                        color: AppTheme.brandBlack,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: MeetingType.values.map((type) {
                        return FilterChip(
                          label: Text(type.label),
                          selected: _selectedTypes.contains(type),
                          onSelected: (selected) {
                            setModalState(() {
                              if (selected) {
                                _selectedTypes.add(type);
                              } else {
                                _selectedTypes.remove(type);
                              }
                            });
                          },
                          backgroundColor: AppTheme.brandBullet,
                          selectedColor: AppTheme.brandBlack,
                          labelStyle: TextStyle(
                            color: _selectedTypes.contains(type)
                                ? AppTheme.brandBg
                                : AppTheme.brandBlack,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 28),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _selectedFilters.clear();
                                _selectedTypes.clear();
                              });
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              side:
                                  const BorderSide(color: AppTheme.brandBlack),
                            ),
                            child: const Text(
                              'Clear All',
                              style: TextStyle(
                                color: AppTheme.brandBlack,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {});
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.brandBlack,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              'Apply Filters',
                              style: TextStyle(
                                color: AppTheme.brandBg,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredMeetings = _filteredMeetings;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.brandBlack,
        title: const Text(
          'Calendar',
          style: TextStyle(
            color: AppTheme.brandBg,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.brandBg),
        actions: [
          IconButton(
            onPressed: _showFilterBottomSheet,
            icon: const Icon(Icons.filter_list_rounded),
            tooltip: 'Filter meetings',
          ),
        ],
      ),
      body: Container(
        color: AppTheme.brandBlack,
        child: Column(
          children: [
            // Active filters indicator
            if (_selectedFilters.isNotEmpty || _selectedTypes.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                color: AppTheme.brandBlack,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ..._selectedFilters.map((filter) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.brandBg,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        filter.label,
                        style: const TextStyle(
                          color: AppTheme.brandBlack,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )),
                    ..._selectedTypes.map((type) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.brandBg,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        type.label,
                        style: const TextStyle(
                          color: AppTheme.brandBlack,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )),
                  ],
                ),
              ),
            ],
            Expanded(
              child: filteredMeetings.isEmpty
                  ? const Center(
                      child: Text(
                        'No meetings match your filters yet.',
                        style: TextStyle(
                          color: AppTheme.brandBg,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 140),
                      itemCount: filteredMeetings.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 20),
                      itemBuilder: (context, index) {
                        final meeting = filteredMeetings[index];
                        return _MeetingCard(meeting: meeting);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

enum MeetingFilter {
  morning('Morning', 'AM'),
  afternoon('Afternoon', 'PM'),
  evening('Evening', 'EVE'),
  today('Today'),
  tomorrow('Tomorrow'),
  thisWeek('This Week');

  final String label;
  final String? timePrefix;

  const MeetingFilter(this.label, [this.timePrefix]);

  static List<MeetingFilter> get timeFilters => [morning, afternoon, evening];
  static List<MeetingFilter> get dateFilters => [today, tomorrow, thisWeek];
}

enum MeetingType {
  team('Team Meeting'),
  sprint('Sprint Meeting'),
  client('Client Meeting'),
  urgent('Urgent Meeting');

  final String label;

  const MeetingType(this.label);
}

class _MeetingCard extends StatelessWidget {
  const _MeetingCard({required this.meeting});

  final _Meeting meeting;

  void _showDetails(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppTheme.brandBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        meeting.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.brandBlack,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getMeetingTypeColor(meeting.meetingType),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        meeting.dateLabel,
                        style: TextStyle(
                          color: AppTheme.brandBlack.withValues(alpha: 0.7),
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color:
                        _getMeetingTypeColor(meeting.meetingType).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    meeting.meetingType.label,
                    style: TextStyle(
                      color: AppTheme.brandBlack,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _DetailRow(
                  icon: Icons.access_time,
                  label: 'Time',
                  value: meeting.timeSlot,
                ),
                const SizedBox(height: 12),
                _DetailRow(
                  icon: Icons.place_outlined,
                  label: 'Location',
                  value: meeting.location,
                ),
                if (meeting.notes != null) ...[
                  const SizedBox(height: 18),
                  const Text(
                    'Notes',
                    style: TextStyle(
                      color: AppTheme.brandBlack,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    meeting.notes!,
                    style: TextStyle(
                      color: AppTheme.brandBlack.withValues(alpha: 0.7),
                      height: 1.4,
                      fontSize: 13,
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                const Text(
                  'Participants',
                  style: TextStyle(
                    color: AppTheme.brandBlack,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: meeting.participants
                      .map(
                        (participant) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.brandBullet,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            participant,
                            style: const TextStyle(
                              color: AppTheme.brandBlack,
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getMeetingTypeColor(MeetingType type) {
    switch (type) {
      case MeetingType.team:
        return Colors.blue[100]!;
      case MeetingType.sprint:
        return Colors.green[100]!;
      case MeetingType.client:
        return Colors.orange[100]!;
      case MeetingType.urgent:
        return Colors.red[100]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.brandBg,
        borderRadius: BorderRadius.circular(28),
        boxShadow: AppTheme.cardShadow,
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getMeetingTypeColor(meeting.meetingType).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            meeting.meetingType.label,
                            style: TextStyle(
                              color: AppTheme.brandBlack,
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      meeting.dateLabel,
                      style: TextStyle(
                        color: AppTheme.brandBlack.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      meeting.title,
                      style: const TextStyle(
                        color: AppTheme.brandBlack,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_filled,
                          size: 16,
                          color: AppTheme.brandBlack.withValues(alpha: 0.7),
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            meeting.timeSlot,
                            style: TextStyle(
                              color: AppTheme.brandBlack.withValues(alpha: 0.7),
                              fontWeight: FontWeight.w500,
                              fontSize: 11,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              InkWell(
                onTap: () => _showDetails(context),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.brandBlack,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.visibility_outlined,
                    size: 18,
                    color: AppTheme.brandBg,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final participant in meeting.participants.take(3))
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.brandBullet,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    participant,
                    style: const TextStyle(
                      color: AppTheme.brandBlack,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                ),
              if (meeting.participants.length > 3)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: AppTheme.brandBlack,
                  ),
                  child: Text(
                    '+${meeting.participants.length - 3}',
                    style: const TextStyle(
                      color: AppTheme.brandBg,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
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

class _Meeting {
  const _Meeting({
    required this.title,
    required this.dateLabel,
    required this.timeSlot,
    required this.location,
    this.notes,
    required this.participants,
    required this.meetingType,
    required this.dateTime,
  });

  final String title;
  final String dateLabel;
  final String timeSlot;
  final String location;
  final String? notes;
  final List<String> participants;
  final MeetingType meetingType;
  final DateTime dateTime;
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.brandBullet,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 18,
            color: AppTheme.brandBlack,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: AppTheme.brandBlack.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: AppTheme.brandBlack,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
