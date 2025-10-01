import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/room_model.dart';

abstract class RoomsFirestoreDataSource {
  Future<void> createRoom(RoomModel room);
  Future<RoomModel?> getRoom(String roomId);
  Future<void> updateRoom(String roomId, Map<String, dynamic> updates);
  Future<void> deleteRoom(String roomId);
  Stream<RoomModel?> getRoomStream(String roomId);
  Future<List<RoomModel>> getAllRooms();
  Stream<List<RoomModel>> getAllRoomsStream();
}

class RoomsFirestoreDataSourceImpl implements RoomsFirestoreDataSource {
  final FirebaseFirestore _firestore;
  static const String _roomsCollection = 'rooms';

  RoomsFirestoreDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> createRoom(RoomModel room) async {
    try {
      await _firestore.collection(_roomsCollection).doc(room.id).set(room.toMap());
    } catch (e) {
      throw Exception('Failed to create room: ${e.toString()}');
    }
  }

  @override
  Future<RoomModel?> getRoom(String roomId) async {
    try {
      final doc = await _firestore.collection(_roomsCollection).doc(roomId).get();
      if (doc.exists && doc.data() != null) {
        return RoomModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get room: ${e.toString()}');
    }
  }

  @override
  Future<void> updateRoom(String roomId, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection(_roomsCollection).doc(roomId).update(updates);
    } catch (e) {
      throw Exception('Failed to update room: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteRoom(String roomId) async {
    try {
      await _firestore.collection(_roomsCollection).doc(roomId).delete();
    } catch (e) {
      throw Exception('Failed to delete room: ${e.toString()}');
    }
  }

  @override
  Stream<RoomModel?> getRoomStream(String roomId) {
    try {
      return _firestore
          .collection(_roomsCollection)
          .doc(roomId)
          .snapshots()
          .map((doc) => doc.exists && doc.data() != null ? RoomModel.fromMap(doc.data()!) : null);
    } catch (e) {
      throw Exception('Failed to get room stream: ${e.toString()}');
    }
  }

  @override
  Future<List<RoomModel>> getAllRooms() async {
    try {
      final snapshot = await _firestore.collection(_roomsCollection).orderBy('createdAt', descending: false).get();
      return snapshot.docs.map((d) => RoomModel.fromMap(d.data())).toList();
    } catch (e) {
      throw Exception('Failed to get rooms: ${e.toString()}');
    }
  }

  @override
  Stream<List<RoomModel>> getAllRoomsStream() {
    try {
      return _firestore.collection(_roomsCollection).orderBy('createdAt', descending: false).snapshots().map((snap) =>
          snap.docs.map((d) => RoomModel.fromMap(d.data())).toList());
    } catch (e) {
      throw Exception('Failed to get rooms stream: ${e.toString()}');
    }
  }
}
