import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotify/core/failure/failure.dart';
import 'package:spotify/data/dtos/auth/create_user_dto.dart';
import 'package:spotify/data/models/auth/signin_user_req.dart';
import 'package:spotify/data/models/auth/user_model.dart';

abstract class AuthFirebaseService {
  Future<Either<Failure, String>> signup(CreateUserDto user);
  Future<Either<Failure, String>> signin(SigninUserReq user);
  Future<Either<Failure, UserModel>> getUser();
  bool isLoggedIn();
}

class AuthFirebaseServiceImpl implements AuthFirebaseService {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthFirebaseServiceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  @override
  Future<Either<Failure, String>> signin(SigninUserReq user) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      return const Right('Signin was Successfully');
    } on FirebaseAuthException catch (e) {
      String message = '';

      if (e.code == 'invalid-email') {
        message = 'The email address is not valid.';
      } else if (e.code == 'invalid-credential') {
        message = 'Wrong Password provided for that user.';
      }
      return Left(Failure(message));
    }
  }

  @override
  Future<Either<Failure, String>> signup(CreateUserDto user) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      try {
        await firestore.collection('Users').doc(credential.user!.uid).set({
          'name': user.fullName,
          'email': credential.user!.email,
          'uid': credential.user!.uid,
        });
      } on FirebaseException {
        return Left(Failure('Failed to save user data.'));
      }
      return const Right('Signup was Successfully');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return Left(Failure('The password provided is too weak.'));
      }
      if (e.code == 'email-already-in-use') {
        return Left(Failure('The account already exists for that email.'));
      }
      return Left(Failure('Unknown error'));
    }
  }

  @override
  Future<Either<Failure, UserModel>> getUser() async {
    try {
      var user = await firestore
          .collection('Users')
          .doc(firebaseAuth.currentUser?.uid)
          .get();

      UserModel userModel = UserModel.fromJson(user.data()!,
          imageUrl: firebaseAuth.currentUser?.photoURL);

      return Right(userModel);
    } catch (e) {
      return Left(Failure('An error occurred, please try again'));
    }
  }

  @override
  bool isLoggedIn() {
    return firebaseAuth.currentUser != null;
  }
}
