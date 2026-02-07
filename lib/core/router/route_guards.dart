import 'package:spotify/core/router/app_routes.dart';
import 'package:spotify/domain/usecases/auth/is_user_logged_in_usecase.dart';

class AuthGuard {
  final IsUserLoggedInUseCase isUserLoggedIn;

  AuthGuard({required this.isUserLoggedIn});

  Future<String?> redirect(String location) async {
    final loggedIn = await isUserLoggedIn.call();

    if (loggedIn) {
      return AppRoutes.home;
    }

    if (!loggedIn) {
      return AppRoutes.getStarted;
    }

    return null;
  }
}
