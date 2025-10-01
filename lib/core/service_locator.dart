import '../features/auth/data/datasources/auth_remote_data_source.dart';
import '../features/auth/data/datasources/firestore_data_source.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/sign_in_usecase.dart';
import '../features/auth/domain/usecases/sign_up_usecase.dart';
import '../features/auth/domain/usecases/sign_out_usecase.dart';
import '../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../features/auth/domain/usecases/get_auth_state_usecase.dart';
import '../features/auth/domain/usecases/reset_password_usecase.dart';
import '../features/auth/domain/usecases/update_user_usecase.dart';
import '../features/auth/domain/usecases/delete_user_usecase.dart';
import '../features/auth/domain/usecases/get_all_users_usecase.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../features/auth/presentation/providers/users_provider.dart';

import '../features/home/data/datasources/rooms_firestore_data_source.dart';
import '../features/home/data/repositories/rooms_repository_impl.dart';
import '../features/home/domain/usecases/create_room_usecase.dart';
import '../features/home/domain/usecases/get_all_rooms_usecase.dart';
import '../features/home/domain/usecases/get_all_rooms_stream_usecase.dart';
import '../features/home/domain/usecases/update_room_usecase.dart';
import '../features/home/domain/usecases/delete_room_usecase.dart';
import '../features/home/presentation/providers/rooms_provider.dart';

class ServiceLocator {
  static ServiceLocator? _instance;
  static ServiceLocator get instance => _instance ??= ServiceLocator._();

  ServiceLocator._();

  // Data Sources
  late final AuthRemoteDataSource _authRemoteDataSource;
  late final FirestoreDataSource _firestoreDataSource;
  late final RoomsFirestoreDataSource _roomsFirestoreDataSource;

  // Repositories
  late final AuthRepository _authRepository;
  late final RoomsRepositoryImpl _roomsRepository;

  // Use Cases - Auth
  late final SignInUseCase _signInUseCase;
  late final SignUpUseCase _signUpUseCase;
  late final SignOutUseCase _signOutUseCase;
  late final GetCurrentUserUseCase _getCurrentUserUseCase;
  late final GetAuthStateUseCase _getAuthStateUseCase;
  late final ResetPasswordUseCase _resetPasswordUseCase;
  late final UpdateUserUseCase _updateUserUseCase;
  late final DeleteUserUseCase _deleteUserUseCase;
  late final GetAllUsersUseCase _getAllUsersUseCase;

  // Use Cases - Rooms
  late final CreateRoomUseCase _createRoomUseCase;
  late final GetAllRoomsUseCase _getAllRoomsUseCase;
  late final GetAllRoomsStreamUseCase _getAllRoomsStreamUseCase;
  late final UpdateRoomUseCase _updateRoomUseCase;
  late final DeleteRoomUseCase _deleteRoomUseCase;

  // Providers
  late final AuthProvider _authProvider;
  late final RoomsProvider _roomsProvider;
  late final UsersProvider _usersProvider;

  void init() {
    // Initialize data sources
    _firestoreDataSource = FirestoreDataSourceImpl();
    _roomsFirestoreDataSource = RoomsFirestoreDataSourceImpl();
    _authRemoteDataSource = AuthRemoteDataSourceImpl(
      firestoreDataSource: _firestoreDataSource,
    );

    // Initialize repositories
    _authRepository = AuthRepositoryImpl(
      remoteDataSource: _authRemoteDataSource,
    );
    _roomsRepository = RoomsRepositoryImpl(dataSource: _roomsFirestoreDataSource);

    // Initialize use cases - auth
    _signInUseCase = SignInUseCase(_authRepository);
    _signUpUseCase = SignUpUseCase(_authRepository);
    _signOutUseCase = SignOutUseCase(_authRepository);
    _getCurrentUserUseCase = GetCurrentUserUseCase(_authRepository);
    _getAuthStateUseCase = GetAuthStateUseCase(_authRepository);
    _resetPasswordUseCase = ResetPasswordUseCase(_authRepository);
    _updateUserUseCase = UpdateUserUseCase(_firestoreDataSource);
    _deleteUserUseCase = DeleteUserUseCase(_firestoreDataSource);
    _getAllUsersUseCase = GetAllUsersUseCase(_firestoreDataSource);

    // Initialize use cases - rooms
    _createRoomUseCase = CreateRoomUseCase(_roomsRepository);
    _getAllRoomsUseCase = GetAllRoomsUseCase(_roomsRepository);
    _getAllRoomsStreamUseCase = GetAllRoomsStreamUseCase(_roomsRepository);
    _updateRoomUseCase = UpdateRoomUseCase(_roomsRepository);
    _deleteRoomUseCase = DeleteRoomUseCase(_roomsRepository);

    // Initialize providers
    _authProvider = AuthProvider(
      signInUseCase: _signInUseCase,
      signUpUseCase: _signUpUseCase,
      signOutUseCase: _signOutUseCase,
      getCurrentUserUseCase: _getCurrentUserUseCase,
      getAuthStateUseCase: _getAuthStateUseCase,
      resetPasswordUseCase: _resetPasswordUseCase,
    );

    _roomsProvider = RoomsProvider(
      createRoomUseCase: _createRoomUseCase,
      getAllRoomsUseCase: _getAllRoomsUseCase,
      getAllRoomsStreamUseCase: _getAllRoomsStreamUseCase,
      updateRoomUseCase: _updateRoomUseCase,
      deleteRoomUseCase: _deleteRoomUseCase,
    );

    _usersProvider = UsersProvider(
      firestoreDataSource: _firestoreDataSource,
      signUpUseCase: _signUpUseCase,
      updateUserUseCase: _updateUserUseCase,
      deleteUserUseCase: _deleteUserUseCase,
      getAllUsersUseCase: _getAllUsersUseCase,
    );
  }

  // Getters for dependencies
  AuthRemoteDataSource get authRemoteDataSource => _authRemoteDataSource;
  FirestoreDataSource get firestoreDataSource => _firestoreDataSource;
  RoomsFirestoreDataSource get roomsFirestoreDataSource => _roomsFirestoreDataSource;
  AuthRepository get authRepository => _authRepository;
  RoomsRepositoryImpl get roomsRepository => _roomsRepository;
  SignInUseCase get signInUseCase => _signInUseCase;
  SignUpUseCase get signUpUseCase => _signUpUseCase;
  SignOutUseCase get signOutUseCase => _signOutUseCase;
  GetCurrentUserUseCase get getCurrentUserUseCase => _getCurrentUserUseCase;
  GetAuthStateUseCase get getAuthStateUseCase => _getAuthStateUseCase;
  ResetPasswordUseCase get resetPasswordUseCase => _resetPasswordUseCase;
  UpdateUserUseCase get updateUserUseCase => _updateUserUseCase;
  DeleteUserUseCase get deleteUserUseCase => _deleteUserUseCase;
  GetAllUsersUseCase get getAllUsersUseCase => _getAllUsersUseCase;
  AuthProvider get authProvider => _authProvider;
  RoomsProvider get roomsProvider => _roomsProvider;
  UsersProvider get usersProvider => _usersProvider;
}