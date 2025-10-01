import '../entities/room_entity.dart';
import '../repositories/rooms_repository.dart';

class CreateRoomUseCase {
  final RoomsRepository _repository;
  CreateRoomUseCase(this._repository);

  Future<void> call(RoomEntity room) async {
    if (room.name.trim().isEmpty) throw Exception('Room name cannot be empty');
    await _repository.createRoom(room);
  }
}
