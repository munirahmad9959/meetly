import 'package:flutter/foundation.dart';
import '../../domain/entities/room_entity.dart';
import '../../domain/usecases/create_room_usecase.dart';
import '../../domain/usecases/get_all_rooms_usecase.dart';
import '../../domain/usecases/get_all_rooms_stream_usecase.dart';
import '../../domain/usecases/update_room_usecase.dart';
import '../../domain/usecases/delete_room_usecase.dart';

class RoomsProvider with ChangeNotifier {
  final CreateRoomUseCase _createUseCase;
  final GetAllRoomsUseCase _getAllUseCase;
  final GetAllRoomsStreamUseCase _getAllStreamUseCase;
  final UpdateRoomUseCase _updateUseCase;
  final DeleteRoomUseCase _deleteUseCase;

  List<RoomEntity> _rooms = [];
  bool _isLoading = false;
  String? _error;

  List<RoomEntity> get rooms => _rooms;
  bool get isLoading => _isLoading;
  String? get error => _error;

  RoomsProvider({
    required CreateRoomUseCase createRoomUseCase,
    required GetAllRoomsUseCase getAllRoomsUseCase,
    required GetAllRoomsStreamUseCase getAllRoomsStreamUseCase,
    required UpdateRoomUseCase updateRoomUseCase,
    required DeleteRoomUseCase deleteRoomUseCase,
  })  : _createUseCase = createRoomUseCase,
        _getAllUseCase = getAllRoomsUseCase,
        _getAllStreamUseCase = getAllRoomsStreamUseCase,
        _updateUseCase = updateRoomUseCase,
        _deleteUseCase = deleteRoomUseCase {
    // Kick off stream to keep rooms in sync
    _getAllStreamUseCase().listen((list) {
      _rooms = list;
      notifyListeners();
    });
  }

  Future<void> loadRooms() async {
    try {
      _isLoading = true;
      notifyListeners();
      _rooms = await _getAllUseCase();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createRoom(RoomEntity room) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _createUseCase(room);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateRoom(String id, Map<String, dynamic> updates) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _updateUseCase(id, updates);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteRoom(String id) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _deleteUseCase(id);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
