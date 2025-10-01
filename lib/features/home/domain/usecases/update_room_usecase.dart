import '../repositories/rooms_repository.dart';

class UpdateRoomUseCase {
  final RoomsRepository _repository;
  UpdateRoomUseCase(this._repository);

  Future<void> call(String roomId, Map<String, dynamic> updates) async {
    if (roomId.isEmpty) throw Exception('Room id is required');
    await _repository.updateRoom(roomId, updates);
  }
}
