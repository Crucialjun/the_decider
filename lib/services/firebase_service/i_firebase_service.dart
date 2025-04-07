

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:the_decider/core/failure.dart';
import 'package:the_decider/services/firebase_service/firebase_service.dart';


class IFirebaseService implements FirebaseService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  final _logger = Logger();

  @override
  Future<Either<Failure, User>> userAuthStatus() async {
    final user = _firebaseAuth.currentUser;

    if (user != null) {
      return Right(user);
    } else {
      return const Left(Failure("User not authenticated"));
    }
  }

  @override
  Future<Either<Failure, User?>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return Right(credential.user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _logger.e('No user found for that email.');
        return const Left(Failure('No user found for that email.'));
      } else if (e.code == 'wrong-password') {
        _logger.e('Wrong password provided for that user.');
        return const Left(Failure('Wrong password provided for that user.'));
      } else if (e.code == 'invalid-email') {
        _logger.e('Invalid email provided.');
        return const Left(Failure('Invalid email provided.'));
      } else if (e.code == 'user-disabled') {
        _logger.e('User disabled.');
        return const Left(Failure('User disabled.'));
      } else if (e.code == 'too-many-requests') {
        _logger.e('Too many requests.');
        return const Left(Failure('Too many requests.'));
      } else if (e.code == 'operation-not-allowed') {
        _logger.e('Operation not allowed.');
        return const Left(Failure('Operation not allowed.'));
      } else if (e.code == 'invalid-credential') {
        _logger.e('Invalid Credential.');
        return const Left(
          Failure(
            'Invalid Credentials, please try again with a valid email and password.',
          ),
        );
      } else {
        _logger.e(e.toString());
        return Left(Failure(e.toString()));
      }
    } catch (e) {
      _logger.e(e.toString());
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User?>> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return Right(credential.user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _logger.e('The password provided is too weak.');
        return const Left(Failure('The password provided is too weak.'));
      } else if (e.code == 'email-already-in-use') {
        _logger.e('The account already exists for that email.');
        return const Left(
          Failure('The account already exists for that email.'),
        );
      } else {
        _logger.e(e.toString());
        return Left(Failure(e.toString()));
      }
    } catch (e) {
      _logger.e(e.toString());
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addUsertoDb({
    required Map<String, dynamic> user,
    required String dbName,
  }) async {
    try {
      final res =
          await _db.collection(dbName).doc(user["uid"]).set(user).onError(
                (error, stackTrace) => throw Failure(
                  "Error adding user to database: ${error.toString()}",
                ),
              );

      return Right(res);
    } on Failure catch (e) {
      _logger.e(e.toString());
      return Left(Failure(e.toString()));
    } catch (e) {
      _logger.e(e.toString());
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DocumentSnapshot<Map<String, dynamic>>>> getUserFromDb(
      {required String collectionName, required String uid}) async {
    try {
      Logger().i(
        "Getting user from database, uid: $uid, collection: $collectionName",
      );

      var res = await _db.collection(collectionName).doc(uid).get().onError(
            (error, stackTrace) => throw Failure(
              "Error getting user from database: ${error.toString()}",
            ),
          );

      return Right(res);
    } on Failure catch (e) {
      _logger.e(e.toString());
      return Left(Failure(e.toString()));
    } catch (e) {
      _logger.e(e.toString());
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserOnDb({
    required Map<String, dynamic> user,
    required String dbName,
  }) async {
    try {
      final res =
          await _db.collection(dbName).doc(user["uid"]).update(user).onError(
                (error, stackTrace) => throw Failure(
                  "Error adding user to database: ${error.toString()}",
                ),
              );

      return Right(res);
    } on Failure catch (e) {
      _logger.e(e.toString());
      return Left(Failure(e.toString()));
    } catch (e) {
      _logger.e(e.toString());
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addProductToDb({
    required Map<String, dynamic> product,
    required String dbName,
  }) async {
    try {
      final res = await _db.collection(dbName).add(product).onError(
            (error, stackTrace) => throw Failure(
              "Error adding product to database: ${error.toString()}",
            ),
          );

      return Right(res);
    } on Failure catch (e) {
      _logger.e(e.toString());
      return Left(Failure(e.toString()));
    } catch (e) {
      _logger.e(e.toString());
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, User?>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      var res = await FirebaseAuth.instance.signInWithCredential(credential);

      return Right(res.user);
    } on Failure catch (e) {
      _logger.e(e.toString());
      return Left(Failure(e.toString()));
    } catch (e) {
      _logger.e(e.toString());
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User?>> signInWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();

      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(
              loginResult.accessToken?.tokenString ?? '');

      // Once signed in, return the UserCredential
      final credential = await FirebaseAuth.instance.signInWithCredential(
        facebookAuthCredential,
      );

      return Right(credential.user);
    } on Failure catch (e) {
      _logger.e(e.toString());
      return Left(Failure(e.toString()));
    } catch (e) {
      _logger.e(e.toString());
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User?>> signInWithApple() async {
    try {
      final appleProvider = AppleAuthProvider();
      final credential =
          await FirebaseAuth.instance.signInWithProvider(appleProvider);

      return Right(credential.user);
    } on Failure catch (e) {
      _logger.e(e.toString());
      return Left(Failure(e.toString()));
    } catch (e) {
      _logger.e(e.toString());
      return Left(Failure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> deleteUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        return Right(user.delete());
      } else {
        return const Left(Failure("User not authenticated"));
      }
    } on Failure catch (e) {
      _logger.e(e.toString());
      return Left(Failure(e.toString()));
    } catch (e) {
      _logger.e(e.toString());
      return Left(Failure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> deleteUserFromDb({required String collectionName, required String uid})async  {
    try {
      final res = _db.collection(collectionName).doc(uid).delete().onError(
            (error, stackTrace) => throw Failure(
              "Error deleting user from database: ${error.toString()}",
            ),
          );

      return Right(res);
    } on Failure catch (e) {
      _logger.e(e.toString());
      return Left(Failure(e.toString()));
    } catch (e) {
      _logger.e(e.toString());
      return Left(Failure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, User?>> loginAnonymously() async{
    try {
      final credential = await _firebaseAuth.signInAnonymously();
      return Right(credential.user);
    } on Failure catch (e) {
      _logger.e(e.toString());
      return Left(Failure(e.toString()));
    } catch (e) {
      _logger.e(e.toString());
      return Left(Failure(e.toString()));
    }
  }
}
