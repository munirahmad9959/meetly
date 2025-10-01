class RoomEntity {
  final String id;
  final String name;
  final String location;
  final int capacity;
  final List<String> amenities;
  final DateTime? createdAt;

  const RoomEntity({
    required this.id,
    required this.name,
    required this.location,
    required this.capacity,
    required this.amenities,
    this.createdAt,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RoomEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'RoomEntity(id: $id, name: $name, location: $location, capacity: $capacity)';
  }
}
