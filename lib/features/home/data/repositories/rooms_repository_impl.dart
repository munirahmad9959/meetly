import '../../domain/entities/room_entity.dart';
import '../../domain/repositories/rooms_repository.dart';
import '../datasources/rooms_firestore_data_source.dart';
import '../models/room_model.dart';

class RoomsRepositoryImpl implements RoomsRepository {
  final RoomsFirestoreDataSource _dataSource;

  RoomsRepositoryImpl({required RoomsFirestoreDataSource dataSource}) : _dataSource = dataSource;

  @override
  Future<void> createRoom(RoomEntity room) async {
    final model = room is RoomModel ? room : RoomModel(
      id: room.id,
      name: room.name,
      location: room.location,
      capacity: room.capacity,
      amenities: room.amenities,
      createdAt: room.createdAt,
    );
    await _dataSource.createRoom(model);
  }

  @override
  Future<void> deleteRoom(String roomId) async {
    await _dataSource.deleteRoom(roomId);
  }

  @override
  Future<RoomEntity?> getRoom(String roomId) async {
    return await _dataSource.getRoom(roomId);
  }

  @override
  Stream<RoomEntity?> getRoomStream(String roomId) {
    return _dataSource.getRoomStream(roomId);
  }

  @override
  Future<List<RoomEntity>> getAllRooms() async {
    return await _dataSource.getAllRooms();
  }

  @override
  Stream<List<RoomEntity>> getAllRoomsStream() {
    return _dataSource.getAllRoomsStream();
  }

  @override
  Future<void> updateRoom(String roomId, Map<String, dynamic> updates) async {
    await _dataSource.updateRoom(roomId, updates);
  }
}
