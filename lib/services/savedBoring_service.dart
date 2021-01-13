import 'dart:math';

import 'package:the_boring_app/models/savedBoringActivity_model.dart';
import 'package:flutter_riverpod/all.dart';

final savedBoringServiceProvider = Provider<SavedBoringService>((ref) => SavedBoringService());

abstract class SavedBoringServices {
  //Future<List<SavedBoringActivity>> getSavedBoringActivity();
  Future<void> addSavedBoringActivity(SavedBoringActivity boringActivity);
  Future<void> removeSavedBoringActivity(String key);
}

class SavedBoringActivityException implements Exception {
  const SavedBoringActivityException(this.error);

  final String error;

  @override
  String toString() {
    return '''Saved Boring Activity Error: $error''';
  }
}


const double errorLikelihood = 0.0;

final _savedBoringActivities = [
  SavedBoringActivity(
    activity: "Explore a park you have never been to before",
    type: "recreational",
    participants: 1,
    price: 0,
    link: "",
    key: "8159356",
    accessibility: 0,
    saved: true,
  ),
  SavedBoringActivity(
    activity: "Text a friend you haven't talked to in a long time",
    type: "social",
    participants: 2,
    price: 0.05,
    link: "",
    key: "6081071",
    accessibility: 0.2,
    saved: true,
  ),
];

class SavedBoringService implements SavedBoringServices {
  SavedBoringService() : random = Random() {
    savedBoringActivitiesStorage = [];
    savedBoringActivitiesStorage..addAll(_savedBoringActivities);
  //getSavedBoringActivity()
  }

  final Random random;
  List<SavedBoringActivity> savedBoringActivitiesStorage;

 @override
 Future<List<SavedBoringActivity>> getSavedBoringActivity() async {
   await _waitRandomTime();
   // retrieving mock storage
   if (random.nextDouble() < errorLikelihood) {
     throw const SavedBoringActivityException('Saved boring activities could not be return');
   } else {
     return savedBoringActivitiesStorage;
   }
 }

  @override
  Future<void> addSavedBoringActivity(SavedBoringActivity boringActivity) async {
    await _waitRandomTime();
    // add to storage
    if (random.nextDouble() < 0.0) {
      throw const SavedBoringActivityException('Activity could not be saved');
    } else {
      if(savedBoringActivitiesStorage.isNotEmpty){
        savedBoringActivitiesStorage = [...savedBoringActivitiesStorage]..add(boringActivity);
      }else{
        throw const SavedBoringActivityException('Activity could not be saved');
      }
    }
  }

  @override
  Future<void> removeSavedBoringActivity(String key) async {
    await _waitRandomTime();
    // remove from storage
    if (random.nextDouble() < errorLikelihood) {
      throw const SavedBoringActivityException('Activity could not be removed');
    } else {
      savedBoringActivitiesStorage = savedBoringActivitiesStorage.where((e) => e.key != key).toList();
    }
  }

  // simulate loading
  Future<void> _waitRandomTime() async {
    await Future.delayed(
      Duration(seconds: random.nextInt(1)), //() {},
    );
  }
}
