import 'package:mockito/annotations.dart';
import 'package:spotify/domain/repository/auth/auth_repositoy.dart';
import 'package:spotify/domain/usecases/auth/is_user_logged_in_usecase.dart';

@GenerateMocks([
  AuthRepository,
  IsUserLoggedInUseCase,
])
export 'mocks.mocks.dart';
