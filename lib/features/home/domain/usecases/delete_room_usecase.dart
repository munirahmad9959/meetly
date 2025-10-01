import '../repositories/rooms_repository.dart';

class DeleteRoomUseCase {
  final RoomsRepository _repository;
  DeleteRoomUseCase(this._repository);

  Future<void> call(String roomId) async {
    if (roomId.isEmpty) throw Exception('Room id is required');
    await _repository.deleteRoom(roomId);
  }
}
