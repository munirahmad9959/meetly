import '../entities/room_entity.dart';
import '../repositories/rooms_repository.dart';

class GetAllRoomsStreamUseCase {
  final RoomsRepository _repository;
  GetAllRoomsStreamUseCase(this._repository);

  Stream<List<RoomEntity>> call() {
    return _repository.getAllRoomsStream();
  }
}
