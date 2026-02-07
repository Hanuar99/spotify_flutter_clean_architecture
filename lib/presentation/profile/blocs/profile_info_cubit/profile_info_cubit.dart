import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/domain/entities/auth/user_entity.dart';
import 'package:spotify/domain/usecases/auth/get_user_usecase.dart';

part 'profile_info_state.dart';

class ProfileInfoCubit extends Cubit<ProfileInfoState> {
  final GetUserUseCase getUserUseCase;
  ProfileInfoCubit(this.getUserUseCase) : super(ProfileInfoLoading());

  Future<void> getUser() async {
    var user = await getUserUseCase();

    user.fold((l) => emit(ProfileInfoError(l.toString())),
        (r) => emit(ProfileInfoLoaded(r)));
  }
}
