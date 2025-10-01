import '../entities/room_entity.dart';
import '../repositories/rooms_repository.dart';

class GetAllRoomsUseCase {
  final RoomsRepository _repository;
  GetAllRoomsUseCase(this._repository);

  Future<List<RoomEntity>> call() async {
    return await _repository.getAllRooms();
  }
}
