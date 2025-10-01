import '../../domain/entities/room_entity.dart';

abstract class RoomsRepository {
  Future<void> createRoom(RoomEntity room);
  Future<RoomEntity?> getRoom(String roomId);
  Future<void> updateRoom(String roomId, Map<String, dynamic> updates);
  Future<void> deleteRoom(String roomId);
  Stream<RoomEntity?> getRoomStream(String roomId);
  Future<List<RoomEntity>> getAllRooms();
  Stream<List<RoomEntity>> getAllRoomsStream();
}
