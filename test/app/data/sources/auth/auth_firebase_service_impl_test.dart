import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:spotify/core/failure/failure.dart';
import 'package:spotify/data/dtos/auth/create_user_dto.dart';
import 'package:spotify/data/sources/auth/auth_firebase_service.dart';

import 'auth_firebase_service_impl_test.mocks.dart';

@GenerateMocks([
  FirebaseAuth,
  FirebaseFirestore,
  UserCredential,
  User,
])
@GenerateNiceMocks([
  MockSpec<CollectionReference<Map<String, dynamic>>>(),
  MockSpec<DocumentReference<Map<String, dynamic>>>(),
])
void main() {
  late AuthFirebaseServiceImpl service;
  late MockFirebaseAuth firebaseAuth;
  late MockFirebaseFirestore firestore;

  late MockCollectionReference usersCollection;
  late MockDocumentReference userDocument;

  const usersPath = 'Users';

  setUp(() {
    firebaseAuth = MockFirebaseAuth();
    firestore = MockFirebaseFirestore();

    usersCollection = MockCollectionReference();
    userDocument = MockDocumentReference();

    service = AuthFirebaseServiceImpl(
      firebaseAuth: firebaseAuth,
      firestore: firestore,
    );
  });

  group('signup', () {
    final userReq = CreateUserDto(
      email: 'test@test.com',
      password: '123456',
      fullName: 'Test User',
    );

    test(
        'should create user and save data in Firestore when signup is successful',
        () async {
      // Arrange
      final user = MockUser();
      when(user.uid).thenReturn('uid_123');
      when(user.email).thenReturn(userReq.email);

      final credential = MockUserCredential();
      when(credential.user).thenReturn(user);

      when(firebaseAuth.createUserWithEmailAndPassword(
        email: userReq.email,
        password: userReq.password,
      )).thenAnswer((_) async => credential);

      when(firestore.collection(usersPath)).thenReturn(usersCollection);
      when(usersCollection.doc('uid_123')).thenReturn(userDocument);
      when(userDocument.set(any)).thenAnswer((_) async {});

      // Act
      final result = await service.signup(userReq);

      // Assert
      expect(result, const Right('Signup was Successfully'));

      verify(firebaseAuth.createUserWithEmailAndPassword(
        email: userReq.email,
        password: userReq.password,
      )).called(1);

      verify(userDocument.set(any)).called(1);
      verifyNoMoreInteractions(firebaseAuth);
    });

    test('should return Failure when email is already in use', () async {
      // Arrange
      when(firebaseAuth.createUserWithEmailAndPassword(
        email: userReq.email,
        password: userReq.password,
      )).thenThrow(
        FirebaseAuthException(code: 'email-already-in-use'),
      );

      // Act
      final result = await service.signup(userReq);

      // Assert
      expect(
        result,
        Left(Failure('The account already exists for that email.')),
      );

      verifyZeroInteractions(firestore);
    });

    test('should return Failure when password is too weak', () async {
      // Arrange
      when(firebaseAuth.createUserWithEmailAndPassword(
        email: userReq.email,
        password: userReq.password,
      )).thenThrow(
        FirebaseAuthException(code: 'weak-password'),
      );

      // Act
      final result = await service.signup(userReq);

      // Assert
      expect(
        result,
        Left(Failure('The password provided is too weak.')),
      );
    });

    test('should return Failure on unknown FirebaseAuth error', () async {
      // Arrange
      when(firebaseAuth.createUserWithEmailAndPassword(
        email: userReq.email,
        password: userReq.password,
      )).thenThrow(
        FirebaseAuthException(code: 'unknown'),
      );

      // Act
      final result = await service.signup(userReq);

      // Assert
      expect(
        result,
        Left(Failure('Unknown error')),
      );
    });

    test('should return Failure when Firestore write fails', () async {
      // Arrange
      final user = MockUser();
      when(user.uid).thenReturn('uid_123');
      when(user.email).thenReturn(userReq.email);

      final credential = MockUserCredential();
      when(credential.user).thenReturn(user);

      when(firebaseAuth.createUserWithEmailAndPassword(
        email: userReq.email,
        password: userReq.password,
      )).thenAnswer((_) async => credential);

      when(firestore.collection(usersPath)).thenReturn(usersCollection);
      when(usersCollection.doc('uid_123')).thenReturn(userDocument);
      when(userDocument.set(any)).thenAnswer(
        (_) => Future<void>.error(
          FirebaseException(
            plugin: 'cloud_firestore',
            message: 'Write failed',
          ),
        ),
      );

      // Act
      final result = await service.signup(userReq);

      // Assert
      expect(
        result,
        Left(Failure('Failed to save user data.')),
      );
    });
  });
}
