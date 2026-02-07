part of 'profile_info_cubit.dart';

abstract class ProfileInfoState {}

final class ProfileInfoLoading extends ProfileInfoState {}

final class ProfileInfoLoaded extends ProfileInfoState {
  final UserEntity user;
  ProfileInfoLoaded(this.user);
}

final class ProfileInfoError extends ProfileInfoState {
  final String message;
  ProfileInfoError(this.message);
}
