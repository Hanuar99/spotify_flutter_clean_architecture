import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotify/data/models/song/song_model.dart';
import 'package:spotify/domain/usecases/song/is_favorite_usecase.dart';
import 'package:spotify/service_locator.dart';

abstract class SongFirebaseService {
  Future<Either> getNewsSongs();

  Future<Either> getPlayList();

  Future<Either> addOrRemoveFavoriteSong(String songId);

  Future<bool> isFavoriteSong(String songId);

  Future<Either> getUserFavoriteSongs();
}

class SongFirebaseServiceImpl implements SongFirebaseService {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  SongFirebaseServiceImpl({required this.auth, required this.firestore});

  @override
  Future<Either> getNewsSongs() async {
    try {
      List<SongModel> songs = [];

      final data = await firestore
          .collection('Songs')
          .orderBy('release', descending: true)
          .limit(3)
          .get();

      for (final element in data.docs) {
        final isFavorite =
            await sl<IsFavoriteUsecase>().call(element.reference.id);

        final song = SongModel.fromJson(
          element.data(),
          isFavorite: isFavorite,
          songId: element.reference.id,
        );

        songs.add(song);
      }

      return Right(songs);
    } catch (e) {
      return Left('An error occurred, please try again');
    }
  }

  @override
  Future<Either> getPlayList() async {
    try {
      List<SongModel> songs = [];
      var data = await firestore
          .collection('Songs')
          .orderBy('release', descending: true)
          .limit(3)
          .get();
      for (var element in data.docs) {
        final isFavorite =
            await sl<IsFavoriteUsecase>().call(element.reference.id);

        final song = SongModel.fromJson(
          element.data(),
          isFavorite: isFavorite,
          songId: element.reference.id,
        );

        songs.add(song);
      }

      return Right(songs);
    } catch (e) {
      return Left('An error occurred, please try again');
    }
  }

  @override
  Future<Either> addOrRemoveFavoriteSong(String songId) async {
    try {
      final uid = auth.currentUser!.uid;

      final favRef = firestore
          .collection('Users')
          .doc(uid)
          .collection('Favorites')
          .doc(songId);

      final favDoc = await favRef.get();

      if (favDoc.exists) {
        await favRef.delete();
        return const Right(false);
      } else {
        await favRef.set({
          'songId': songId,
          'addedDate': Timestamp.now(),
        });
        return const Right(true);
      }
    } catch (e) {
      return Left('An error occurred, please try again');
    }
  }

  @override
  Future<bool> isFavoriteSong(String songId) async {
    try {
      final user = auth.currentUser;
      String uid = user!.uid;

      QuerySnapshot favoriteSongs = await firestore
          .collection('Users')
          .doc(uid)
          .collection('Favorites')
          .where('songId', isEqualTo: songId)
          .get();

      if (favoriteSongs.docs.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Either> getUserFavoriteSongs() async {
    try {
      final user = auth.currentUser;
      final uid = user!.uid;

      QuerySnapshot favoriteSongs = await firestore
          .collection('Users')
          .doc(uid)
          .collection('Favorites')
          .get();

      List<SongModel> songs = [];
      for (var element in favoriteSongs.docs) {
        String songId = element.get('songId');
        var song = await firestore.collection('Songs').doc(songId).get();
        SongModel songModel =
            SongModel.fromJson(song.data()!, isFavorite: true, songId: songId);

        songs.add(songModel);
      }

      return Right(songs);
    } catch (e) {
      return Left('An error occurred, please try again');
    }
  }
}
