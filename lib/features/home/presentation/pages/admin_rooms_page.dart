import 'package:flutter/material.dart';
import 'package:meetly/shared/theme/app_theme.dart';

class AdminRoomsPage extends StatefulWidget {
  const AdminRoomsPage({super.key});

  @override
  State<AdminRoomsPage> createState() => _AdminRoomsPageState();
}

class _AdminRoomsPageState extends State<AdminRoomsPage>
    with AutomaticKeepAliveClientMixin {

  final List<RoomRecord> _rooms = [
    RoomRecord(
      id: 'room-1',
      name: 'Design Hub',
      location: '3rd Floor · North Wing',
      capacity: 12,
      amenities: const ['4K Display', 'Figma Mirror', 'Whiteboard'],
    ),
    RoomRecord(
      id: 'room-2',
      name: 'Strategy War Room',
      location: '2nd Floor · East Wing',
      capacity: 20,
      amenities: const ['Conference Camera', 'Acoustic Panels', 'Coffee Bar'],
    ),
    RoomRecord(
      id: 'room-3',
      name: 'Sprint Pod',
      location: '1st Floor · West Wing',
      capacity: 8,
      amenities: const ['Focus Lighting', 'Scrum Board', 'HDMI Hub'],
    ),
  ];

  String _searchQuery = '';

  @override
  bool get wantKeepAlive => true;

  List<RoomRecord> get _filteredRooms {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return _rooms;
    return _rooms.where((room) {
      final haystack = [
        room.name.toLowerCase(),
        room.location.toLowerCase(),
        ...room.amenities.map((a) => a.toLowerCase()),
      ].join(' ');
      return haystack.contains(query);
    }).toList();
  }

  void _showRoomForm({RoomRecord? room, int? roomIndex}) {
    final nameController = TextEditingController(text: room?.name ?? '');
    final locationController = TextEditingController(
      text: room?.location ?? '',
    );
    final capacityController = TextEditingController(
      text: room?.capacity.toString() ?? '',
    );
    final amenitiesController = TextEditingController(
      text: room?.amenities.join(', ') ?? '',
    );
    final formKey = GlobalKey<FormState>(debugLabel: 'roomForm_${DateTime.now().millisecondsSinceEpoch}');

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.brandBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            top: 24,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text(
                  room == null ? 'Add Room' : 'Update Room',
                  style: const TextStyle(
                    color: AppTheme.brandBlack,
                    fontSize: 16, // Reduced from 18
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),
                _RoomTextField(
                  controller: nameController,
                  label: 'Room Name',
                  hintText: 'E.g. Innovation Lab',
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a room name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _RoomTextField(
                  controller: locationController,
                  label: 'Location',
                  hintText: 'E.g. 2nd Floor · West Wing',
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a location';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _RoomTextField(
                  controller: capacityController,
                  label: 'Capacity',
                  hintText: 'E.g. 12',
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    final parsed = int.tryParse(value ?? '');
                    if (parsed == null || parsed <= 0) {
                      return 'Capacity must be a positive number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _RoomTextField(
                  controller: amenitiesController,
                  label: 'Amenities',
                  hintText: 'Separate amenities with commas',
                  maxLines: 2,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: AppTheme.brandBlack),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: AppTheme.brandBlack,
                            fontWeight: FontWeight.w600,
                            fontSize: 12, // Reduced from 13
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (!(formKey.currentState?.validate() ?? false)) {
                            return;
                          }
                          final amenities = amenitiesController.text
                              .split(',')
                              .map((item) => item.trim())
                              .where((item) => item.isNotEmpty)
                              .toList();
                          final capacity =
                              int.tryParse(capacityController.text.trim()) ?? 0;

                          final record = RoomRecord(
                            id:
                                room?.id ??
                                DateTime.now().millisecondsSinceEpoch
                                    .toString(),
                            name: nameController.text.trim(),
                            location: locationController.text.trim(),
                            capacity: capacity,
                            amenities: amenities,
                          );

                          setState(() {
                            if (roomIndex != null) {
                              _rooms[roomIndex] = record;
                            } else {
                              _rooms.add(record);
                            }
                          });

                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.brandBlack,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Save Room',
                          style: TextStyle(
                            color: AppTheme.brandBg,
                            fontWeight: FontWeight.w700,
                            fontSize: 12, // Reduced from 13
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ),
        );
      },
    ).whenComplete(() {
      // Dispose controllers after a brief delay to ensure bottom sheet is fully closed
      Future.delayed(const Duration(milliseconds: 100), () {
        nameController.dispose();
        locationController.dispose();
        capacityController.dispose();
        amenitiesController.dispose();
      });
    });
  }

  void _removeRoom(RoomRecord room) {
    setState(() {
      _rooms.removeWhere((item) => item.id == room.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final filteredRooms = _filteredRooms;

    return Scaffold(
      backgroundColor: AppTheme.brandBlack,
      appBar: AppBar(
        backgroundColor: AppTheme.brandBlack,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Rooms',
          style: TextStyle(
            color: AppTheme.brandBg,
            fontWeight: FontWeight.w700,
            fontSize: 16, // Reduced from 18
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'addRoomFAB',
        onPressed: () => _showRoomForm(),
        backgroundColor: AppTheme.brandGreen,
        icon: const Icon(Icons.add_rounded, color: AppTheme.brandBlack),
        label: const Text(
          'Add Room',
          style: TextStyle(
            color: AppTheme.brandBlack,
            fontWeight: FontWeight.w700,
            fontSize: 12, // Added font size reduction
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              color: AppTheme.brandBlack,
              child: TextField(
                onChanged: (value) => setState(() => _searchQuery = value),
                style: const TextStyle(
                  color: AppTheme.brandBg,
                  fontSize: 12,
                ), // Reduced from default
                decoration: InputDecoration(
                  hintText: 'Search rooms or amenities',
                  hintStyle: TextStyle(
                    color: AppTheme.brandBg.withOpacity(0.55),
                    fontSize: 12, // Reduced from 13
                  ),
                  filled: true,
                  fillColor: AppTheme.brandBlack.withOpacity(0.35),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: AppTheme.brandBg.withOpacity(0.7),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(color: AppTheme.brandBlack),
                child: filteredRooms.isEmpty
                    ? _EmptyRoomsState(onAddTap: () => _showRoomForm())
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
                        itemBuilder: (context, index) {
                          final room = filteredRooms[index];
                          return _RoomCard(
                            room: room,
                            onEdit: () {
                              final originalIndex = _rooms.indexWhere(
                                (r) => r.id == room.id,
                              );
                              _showRoomForm(
                                room: room,
                                roomIndex: originalIndex,
                              );
                            },
                            onDelete: () => _removeRoom(room),
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemCount: filteredRooms.length,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RoomRecord {
  const RoomRecord({
    required this.id,
    required this.name,
    required this.location,
    required this.capacity,
    required this.amenities,
  });

  final String id;
  final String name;
  final String location;
  final int capacity;
  final List<String> amenities;

  RoomRecord copyWith({
    String? id,
    String? name,
    String? location,
    int? capacity,
    List<String>? amenities,
  }) {
    return RoomRecord(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      capacity: capacity ?? this.capacity,
      amenities: amenities ?? this.amenities,
    );
  }
}

class _RoomCard extends StatelessWidget {
  const _RoomCard({
    required this.room,
    required this.onEdit,
    required this.onDelete,
  });

  final RoomRecord room;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.brandBg,
        borderRadius: BorderRadius.circular(24),
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
                    Text(
                      room.name,
                      style: const TextStyle(
                        color: AppTheme.brandBlack,
                        fontSize: 16, // Reduced from 18
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      room.location,
                      style: TextStyle(
                        color: AppTheme.brandBlack.withOpacity(0.6),
                        fontSize: 11, // Reduced from 12
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Text(
                      'Edit',
                      style: TextStyle(fontSize: 12),
                    ), // Reduced
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text(
                      'Remove',
                      style: TextStyle(fontSize: 12),
                    ), // Reduced
                  ),
                ],
                onSelected: (value) {
                  if (value == 'edit') {
                    onEdit();
                  } else if (value == 'delete') {
                    onDelete();
                  }
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                icon: const Icon(Icons.more_horiz, color: AppTheme.brandBlack),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.brandBullet,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.people_outline,
                      size: 14, // Reduced from 16
                      color: AppTheme.brandBlack,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${room.capacity} seats',
                      style: const TextStyle(
                        color: AppTheme.brandBlack,
                        fontSize: 11, // Reduced from 12
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (room.amenities.isNotEmpty) const SizedBox(width: 12),
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: room.amenities
                      .map(
                        (amenity) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.brandSkin.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            amenity,
                            style: const TextStyle(
                              color: AppTheme.brandBlack,
                              fontSize: 11, // Reduced from 12
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoomTextField extends StatelessWidget {
  const _RoomTextField({
    required this.controller,
    required this.label,
    this.hintText,
    this.validator,
    this.maxLines = 1,
    this.keyboardType,
    this.textInputAction,
  });

  final TextEditingController controller;
  final String label;
  final String? hintText;
  final String? Function(String?)? validator;
  final int maxLines;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.brandBlack,
            fontWeight: FontWeight.w600,
            fontSize: 12, // Reduced from 13
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          maxLines: maxLines,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          style: const TextStyle(fontSize: 12), // Added font size reduction
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              fontSize: 12,
            ), // Added font size reduction
            filled: true,
            fillColor: AppTheme.brandBullet,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyRoomsState extends StatelessWidget {
  const _EmptyRoomsState({required this.onAddTap});

  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppTheme.brandBg,
                borderRadius: BorderRadius.circular(28),
                boxShadow: AppTheme.cardShadow,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.meeting_room_outlined,
                size: 32, // Reduced from 36
                color: AppTheme.brandBlack,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No rooms yet',
              style: TextStyle(
                color: AppTheme.brandBg,
                fontSize: 16, // Reduced from 18
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first collaboration space and make it available for teams right away.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.brandBg.withOpacity(0.7),
                fontSize: 12, // Reduced from 13
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: onAddTap,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.brandBg,
                side: const BorderSide(color: AppTheme.brandBg),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              icon: const Icon(
                Icons.add_rounded,
                size: 16,
              ), // Reduced icon size
              label: const Text(
                'Add Room',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ), // Reduced
              ),
            ),
          ],
        ),
      ),
    );
  }
}
