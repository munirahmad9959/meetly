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
import '../features/auth/presentation/providers/auth_provider.dart';

class ServiceLocator {
  static ServiceLocator? _instance;
  static ServiceLocator get instance => _instance ??= ServiceLocator._();
  
  ServiceLocator._();

  // Data Sources
  late final AuthRemoteDataSource _authRemoteDataSource;
  late final FirestoreDataSource _firestoreDataSource;
  
  // Repositories
  late final AuthRepository _authRepository;
  
  // Use Cases
  late final SignInUseCase _signInUseCase;
  late final SignUpUseCase _signUpUseCase;
  late final SignOutUseCase _signOutUseCase;
  late final GetCurrentUserUseCase _getCurrentUserUseCase;
  late final GetAuthStateUseCase _getAuthStateUseCase;
  late final ResetPasswordUseCase _resetPasswordUseCase;
  
  // Providers
  late final AuthProvider _authProvider;

  void init() {
    // Initialize data sources
    _firestoreDataSource = FirestoreDataSourceImpl();
    _authRemoteDataSource = AuthRemoteDataSourceImpl(
      firestoreDataSource: _firestoreDataSource,
    );
    
    // Initialize repositories
    _authRepository = AuthRepositoryImpl(
      remoteDataSource: _authRemoteDataSource,
    );
    
    // Initialize use cases
    _signInUseCase = SignInUseCase(_authRepository);
    _signUpUseCase = SignUpUseCase(_authRepository);
    _signOutUseCase = SignOutUseCase(_authRepository);
    _getCurrentUserUseCase = GetCurrentUserUseCase(_authRepository);
    _getAuthStateUseCase = GetAuthStateUseCase(_authRepository);
    _resetPasswordUseCase = ResetPasswordUseCase(_authRepository);
    
    // Initialize providers
    _authProvider = AuthProvider(
      signInUseCase: _signInUseCase,
      signUpUseCase: _signUpUseCase,
      signOutUseCase: _signOutUseCase,
      getCurrentUserUseCase: _getCurrentUserUseCase,
      getAuthStateUseCase: _getAuthStateUseCase,
      resetPasswordUseCase: _resetPasswordUseCase,
    );
  }

  // Getters for dependencies
  AuthRemoteDataSource get authRemoteDataSource => _authRemoteDataSource;
  FirestoreDataSource get firestoreDataSource => _firestoreDataSource;
  AuthRepository get authRepository => _authRepository;
  SignInUseCase get signInUseCase => _signInUseCase;
  SignUpUseCase get signUpUseCase => _signUpUseCase;
  SignOutUseCase get signOutUseCase => _signOutUseCase;
  GetCurrentUserUseCase get getCurrentUserUseCase => _getCurrentUserUseCase;
  GetAuthStateUseCase get getAuthStateUseCase => _getAuthStateUseCase;
  ResetPasswordUseCase get resetPasswordUseCase => _resetPasswordUseCase;
  AuthProvider get authProvider => _authProvider;
}