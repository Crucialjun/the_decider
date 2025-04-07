

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:the_decider/core/failure.dart';


abstract class FirebaseService {
  Future<Either<Failure, User>> userAuthStatus();
  Future<Either<Failure, User?>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<Either<Failure, User?>> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<Either<Failure, void>> addUsertoDb({
    required Map<String, dynamic> user,
    required String dbName,
  });
  Future<Either<Failure, DocumentSnapshot<Map<String, dynamic>>>> getUserFromDb(
      {required String collectionName, required String uid});
  Future<Either<Failure, void>> updateUserOnDb({
    required Map<String, dynamic> user,
    required String dbName,
  });
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, void>> addProductToDb({
    required Map<String, dynamic> product,
    required String dbName,
  });
  Future<Either<Failure, User?>> signInWithGoogle();
  Future<Either<Failure, User?>> signInWithFacebook();
  Future<Either<Failure, User?>> signInWithApple();

  Future<Either<Failure, void>> deleteUserFromDb({
    required String collectionName,
    required String uid,
  });
  //delete user
  Future<Either<Failure, void>> deleteUser();
  Future<Either<Failure,User?>> loginAnonymously();
}
